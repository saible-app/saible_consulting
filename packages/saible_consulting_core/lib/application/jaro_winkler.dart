// Copyright 2026 Saible Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math';

/// Jaro-Winkler string similarity.
///
/// Instances hold reusable scratch buffers to avoid allocating two match
/// arrays on every call. They are therefore not safe for concurrent use;
/// in practice the single-threaded nature of a Dart isolate makes this a
/// non-issue.
class JaroWinkler([this._scalingFactor = 0.1]) {
  /// Creates a [JaroWinkler] similarity metric instance with an optional
  /// prefix [_scalingFactor] (defaults to 0.1).
  this;

  /// The maximum number of leading characters considered for the
  /// Winkler common-prefix bonus.
  static const _maxPrefixLength = 4;

  final double _scalingFactor;
  List<bool> _s1Matches = const [];
  List<bool> _s2Matches = const [];

  /// An upper bound on the similarity of any two strings of the given
  /// lengths, regardless of their content.
  ///
  /// A Jaro similarity can reach at most `(2 + minLength / maxLength) / 3`,
  /// and the Winkler prefix bonus can lift that by at most
  /// `4 * _scalingFactor` of the remaining gap. This bound lets callers
  /// reject candidates by length alone, without running the full
  /// O(n·m) comparison.
  double similarityUpperBound(int len1, int len2) {
    if (len1 == 0 || len2 == 0) return 0;
    final ratio = min(len1, len2) / max(len1, len2);
    final jaroBound = (2 + ratio) / 3;
    final maxPrefixBonus = _maxPrefixLength * _scalingFactor;
    return min(1, jaroBound + maxPrefixBonus * (1 - jaroBound));
  }

  /// Calculates the Jaro-Winkler similarity between [s1] and [s2],
  /// returning a score between 0.0 (completely dissimilar) and 1.0 (identical).
  double similarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0;
    if (s1 == s2) return 1;
    final matchDistance = (max(s1.length, s2.length) / 2).ceil() - 1;
    final s1Matches = _acquire(_s1Matches, s1.length);
    _s1Matches = s1Matches;
    final s2Matches = _acquire(_s2Matches, s2.length);
    _s2Matches = s2Matches;
    var matches = 0;
    var transpositions = 0;
    for (var i = 0; i < s1.length; ++i) {
      final start = max(0, i - matchDistance);
      final end = min(s2.length - 1, i + matchDistance);
      for (var j = start; j <= end; ++j) {
        if (s2Matches[j]) continue;
        if (s1[i] != s2[j]) continue;
        s1Matches[i] = true;
        s2Matches[j] = true;
        ++matches;
        break;
      }
    }

    if (matches == 0) return 0;
    var k = 0;
    for (var i = 0; i < s1.length; i++) {
      if (!s1Matches[i]) continue;
      while (!s2Matches[k]) {
        ++k;
      }

      if (s1[i] != s2[k]) ++transpositions;
      ++k;
    }

    final jaro = ((matches / s1.length) + (matches / s2.length) + ((matches - transpositions / 2) / matches)) / 3.0;

    var prefix = 0;
    for (var i = 0; i < min(min(_maxPrefixLength, s1.length), s2.length); i++) {
      if (s1[i] == s2[i]) {
        prefix++;
      } else {
        break;
      }
    }

    return jaro + (prefix * _scalingFactor * (1 - jaro));
  }

  /// Calculates the Jaro-Winkler distance between [s1] and [s2],
  /// which is `1 - similarity(s1, s2)`.
  double distance(String s1, String s2) => 1 - similarity(s1, s2);

  /// Returns a cleared scratch buffer of at least [length] entries,
  /// reusing [current] when it is already large enough.
  List<bool> _acquire(List<bool> current, int length) {
    if (current.length < length) return List<bool>.filled(length, false);
    current.fillRange(0, length, false);
    return current;
  }
}
