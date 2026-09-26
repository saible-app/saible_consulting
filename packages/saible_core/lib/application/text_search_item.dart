import 'dart:math' as math;

import 'package:saible_core/application/jaro_winkler.dart';


class TextSearchItemTerm(this.term, [this.scorePenalty = 0.0]) {
  final String term;
  final double scorePenalty;

  /// [term] in lowercase, precomputed once so that per-keystroke searches
  /// do not allocate.
  late final String lower = term.toLowerCase();

  /// Whether [term] contains no space, i.e. consists of a single word.
  late final bool isSingleWord = !lower.contains(' ');

  /// The individual lowercase words of a multi-word [term]; empty for
  /// single-word terms.
  late final List<String> words = isSingleWord ? const <String>[] : lower.split(' ');

  /// [lower] with all spaces removed, precomputed.
  late final String stripped = isSingleWord ? lower : lower.replaceAll(' ', '');
}

class const TextSearchItem<T>(this.item, this.terms) {
  final T item;
  final Iterable<TextSearchItemTerm> terms;
  factory TextSearchItem.fromTerms(T object, Iterable<String> terms) => TextSearchItem(
    object, terms.map(TextSearchItemTerm.new
  ));
}

class TextSearchResult<T>(this.item, this.score) {
  final T item;
  final double score;
}

/// Used for doing simple in-memory text searching based on a given set of
/// `TextSearchItem`s. Lower scores are better, with exact case-insensitive
/// matches scoring 0. Uses the `JaroWinkler` distance.
///
/// An empty search term matches every item (with a score of 0), which both
/// [TextSearch.search] and [TextSearch.fastSearch] agree on.
class TextSearch<T>(this.items) {
  static final _editDistance = JaroWinkler();
  final List<TextSearchItem<T>> items;

  /// Returns the search results along with their scores, ordered by
  /// increasing score (best match first). Items whose best score is not
  /// below [matchThreshold] are excluded.
  List<TextSearchResult<T>> search(
    String term, {double matchThreshold = 1.5, bool alwaysMatchPrefix = false}
  ) {
    if (term.isEmpty) {
      return [for (final item in items) TextSearchResult(item.item, 0)];
    }
    final lcSearch = term.toLowerCase();
    final results = <TextSearchResult<T>>[];
    for (final item in items) {
      final score = _bestScore(lcSearch, item, matchThreshold, alwaysMatchPrefix);
      if (score < matchThreshold) results.add(TextSearchResult(item.item, score));
    }
    results.sort((a, b) => a.score.compareTo(b.score));
    return results;
  }

  /// Returns matching items ordered by increasing score (best match first),
  /// at most [limit] of them. Uses bounded top-k selection, so unlike
  /// [search] it does not have to score-sort every passing candidate —
  /// candidates that cannot beat the current k-th best result are dropped
  /// as soon as they are scored.
  List<T> fastSearch(
    String term, {
    double matchThreshold = 1.5,
    bool alwaysMatchPrefix = false,
    int? limit,
  }) {
    if (limit != null && limit <= 0) return const [];
    if (term.isEmpty) {
      final all = items.map((e) => e.item).toList();
      return limit == null ? all : all.sublist(0, math.min(limit, all.length));
    }
    final lcSearch = term.toLowerCase();
    final capacity = limit;
    // Without a limit, collect every passing candidate and sort once.
    // With a limit, use bounded top-k selection instead: candidates that
    // cannot beat the current k-th best result are dropped as soon as
    // they are scored, and only the retained ones are kept in order.
    if (capacity == null) {
      final passing = <(double, T)>[];
      for (final item in items) {
        final score = _bestScore(lcSearch, item, matchThreshold, alwaysMatchPrefix);
        if (score < matchThreshold) passing.add((score, item.item));
      }
      passing.sort((a, b) => a.$1.compareTo(b.$1));
      return [for (final entry in passing) entry.$2];
    }
    final best = <(double, T)>[];
    var worstScore = double.infinity;
    for (final item in items) {
      final score = _bestScore(lcSearch, item, matchThreshold, alwaysMatchPrefix);
      if (score >= matchThreshold) continue;
      if (best.length == capacity) {
        if (score >= worstScore) continue;
        best.removeLast();
      }
      var index = best.length;
      while (index > 0 && best[index - 1].$1 > score) {
        --index;
      }
      best.insert(index, (score, item.item));
      worstScore = best.last.$1;
    }
    return [for (final entry in best) entry.$2];
  }

  /// The best (lowest) score across all of the item's terms, or
  /// [double.infinity] when the item has no terms at all.
  double _bestScore(String lcSearch, TextSearchItem<T> item, double matchThreshold, bool alwaysMatchPrefix) {
    var best = double.infinity;
    for (final itemTerm in item.terms) {
      final score = _scoreTerm(lcSearch, itemTerm, matchThreshold, alwaysMatchPrefix);
      if (score < best) best = score;
    }
    return best;
  }

  double _scoreTerm(String lcSearch, TextSearchItemTerm itemTerm, double matchThreshold, bool alwaysMatchPrefix) {
    final penalty = itemTerm.scorePenalty;
    // The highest score a single path may contribute and still let the item
    // pass the threshold once its penalty has been applied.
    final thresholdDelta = matchThreshold - penalty;
    final double effectiveThreshold = thresholdDelta > 0 ? thresholdDelta : 0;

    // Single character terms (e.g. ISO-2 codes) match when the search term
    // starts with them.
    if (itemTerm.term.length == 1) {
      return lcSearch.startsWith(itemTerm.lower) ? penalty : 4;
    }

    if (alwaysMatchPrefix && itemTerm.lower.startsWith(lcSearch)) {
      return penalty;
    }

    if (lcSearch == itemTerm.lower) {
      return penalty;
    }
    // Direct comparison (regardless of word or sentence).
    final initialScore = _scaledDistance(lcSearch, itemTerm.lower, effectiveThreshold);
    if (itemTerm.isSingleWord) {
      return initialScore + penalty;
    }

    if (itemTerm.lower.startsWith(lcSearch)) {
      return math.max(0.05, 0.5 - lcSearch.length / itemTerm.lower.length) + penalty;
    }

    if (itemTerm.lower.contains(lcSearch)) {
      return math.max(0.05, 0.7 - lcSearch.length / itemTerm.lower.length) + penalty;
    }

    // Compare to sentences by splitting to each component word.
    var hasConsideredWords = false;
    var perWordScore = double.infinity;
    for (final word in itemTerm.words) {
      if (word.length <= 1) continue;
      hasConsideredWords = true;
      // Penalize longer sentences and avoid multiplying by 0 (exact match).
      final scale = math.sqrt(word.length + 1);
      final floor = (1 - _editDistance.similarityUpperBound(lcSearch.length, word.length)) * lcSearch.length;
      if (scale * (0.1 + floor) >= effectiveThreshold) continue; // Provably failing word.
      final score = scale * (0.1 + _scaledDistance(lcSearch, word, effectiveThreshold));
      if (score < perWordScore) perWordScore = score;
    }
    // A multi-word term whose words are all single characters matches
    // everything, matching the historical behaviour of this search.
    if (!hasConsideredWords) return penalty;

    final strippedScore = _scoreStripped(lcSearch.replaceAll(' ', ''), itemTerm.stripped, effectiveThreshold);
    return math.min(strippedScore, math.min(initialScore, perWordScore)) + penalty;
  }

  /// Scores the space-stripped search term against the space-stripped item
  /// term, mirroring the single-word scoring rules.
  double _scoreStripped(String strippedSearch, String strippedTerm, double effectiveThreshold) {
    if (strippedTerm.length == 1) {
      return strippedSearch.startsWith(strippedTerm) ? 0 : 4;
    }
    if (strippedSearch == strippedTerm) return 0;
    return _scaledDistance(strippedSearch, strippedTerm, effectiveThreshold);
  }

  /// The Jaro-Winkler distance between [lcSearch] and [candidate] (both
  /// lowercase), scaled by the search length, or [effectiveThreshold] when
  /// even a perfect match of the two lengths could not score below the
  /// threshold.
  ///
  /// Substituting the threshold in that case is safe: a provably failing
  /// candidate can never win a `min` against a genuinely passing score, so
  /// passing items keep their exact scores while failing ones are rejected
  /// without running the full O(n·m) comparison.
  double _scaledDistance(String lcSearch, String candidate, double effectiveThreshold) {
    final floor = (1 - _editDistance.similarityUpperBound(lcSearch.length, candidate.length)) * lcSearch.length;
    if (floor >= effectiveThreshold) return effectiveThreshold;
    return _editDistance.distance(lcSearch, candidate) * lcSearch.length;
  }
}
