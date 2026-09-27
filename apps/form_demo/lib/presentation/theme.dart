import 'package:form_demo/presentation/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

TextTheme _createSaibleTextTheme(TextTheme baseTextTheme) {
  final workSansFamily = GoogleFonts.workSans().fontFamily;
  final signikaFamily = GoogleFonts.signika().fontFamily;

  return baseTextTheme.copyWith(
    // Display and Headline styles using Signika
    displayLarge: baseTextTheme.displayLarge?.copyWith(fontFamily: signikaFamily),
    displayMedium: baseTextTheme.displayMedium?.copyWith(fontFamily: signikaFamily),
    displaySmall: baseTextTheme.displaySmall?.copyWith(fontFamily: signikaFamily),
    headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontFamily: signikaFamily),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontFamily: signikaFamily),
    headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontFamily: signikaFamily),
    titleLarge: baseTextTheme.titleLarge?.copyWith(fontFamily: signikaFamily),
    titleMedium: baseTextTheme.titleMedium?.copyWith(fontFamily: signikaFamily),
    titleSmall: baseTextTheme.titleSmall?.copyWith(fontFamily: signikaFamily),

    // Body and Label styles using Work Sans
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontFamily: workSansFamily),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontFamily: workSansFamily),
    bodySmall: baseTextTheme.bodySmall?.copyWith(fontFamily: workSansFamily),
    labelLarge: baseTextTheme.labelLarge?.copyWith(fontFamily: workSansFamily),
    labelMedium: baseTextTheme.labelMedium?.copyWith(fontFamily: workSansFamily),
    labelSmall: baseTextTheme.labelSmall?.copyWith(fontFamily: workSansFamily),
  );
}

/// Defines the Saible application theme configuration and builder.
class SaibleTheme({
    this.buttonTextStyle = const WidgetStatePropertyAll(
      TextStyle(fontSize: 16, fontWeight: FontWeight.w800, inherit: false),
    ),
    this.buttonFixedSize = const WidgetStatePropertyAll(Size(double.infinity, 48)),
    this.shapeBorder = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  }) {
  /// The shape border applied to themed buttons and cards.
  final RoundedRectangleBorder shapeBorder;

  /// The text style applied to button labels.
  final WidgetStateProperty<TextStyle> buttonTextStyle;

  /// The fixed size applied to themed buttons.
  final WidgetStateProperty<Size> buttonFixedSize;

  /// Creates a [SaibleTheme] instance with default button styles and shapes.
  this;

  /// The dark [ColorScheme] for the Saible brand.
  static ColorScheme darkScheme() => const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff8dd5b3),
    surfaceTint: Color(0xff8dd5b3),
    onPrimary: Color(0xff003826),
    primaryContainer: Color(0xff005138),
    onPrimaryContainer: Color(0xffa8f2ce),
    secondary: Color(0xffb3ccbe),
    onSecondary: Color(0xff1f352a),
    secondaryContainer: Color(0xff354b40),
    onSecondaryContainer: Color(0xffcfe9d9),
    tertiary: Color(0xffa5ccdf),
    onTertiary: Color(0xff073543),
    tertiaryContainer: Color(0xff244c5b),
    onTertiaryContainer: Color(0xffc1e9fb),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff0f1511),
    onSurface: Color(0xffdee4de),
    onSurfaceVariant: Color(0xffbfc9c2),
    outline: Color(0xff8a938c),
    outlineVariant: Color(0xff404943),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffdee4de),
    inversePrimary: Color(0xff1f6a4e),
    primaryFixed: Color(0xffa8f2ce),
    onPrimaryFixed: Color(0xff002114),
    primaryFixedDim: Color(0xff8dd5b3),
    onPrimaryFixedVariant: Color(0xff005138),
    secondaryFixed: Color(0xffcfe9d9),
    onSecondaryFixed: Color(0xff0a1f16),
    secondaryFixedDim: Color(0xffb3ccbe),
    onSecondaryFixedVariant: Color(0xff354b40),
    tertiaryFixed: Color(0xffc1e9fb),
    onTertiaryFixed: Color(0xff001f29),
    tertiaryFixedDim: Color(0xffa5ccdf),
    onTertiaryFixedVariant: Color(0xff244c5b),
    surfaceDim: Color(0xff0f1511),
    surfaceBright: Color(0xff353b37),
    surfaceContainerLowest: Color(0xff0a0f0c),
    surfaceContainerLow: Color(0xff171d1a),
    surfaceContainer: Color(0xff1b211e),
    surfaceContainerHigh: Color(0xff252b28),
    surfaceContainerHighest: Color(0xff303632),
  );

  /// Generates the dark [ThemeData] for the Saible theme.
  ThemeData dark() => theme(darkScheme());

  /// Builds a [ThemeData] based on the given [colorScheme] with Saible typography and widgets.
  ThemeData theme(ColorScheme colorScheme) {
    // 1. Generate M3 base theme with appropriate ColorScheme and default metrics
    final baseTheme = ThemeData(useMaterial3: true, brightness: colorScheme.brightness, colorScheme: colorScheme);

    // 2. Build custom typography onto the base Material 3 TextTheme
    final customTextTheme = _createSaibleTextTheme(baseTheme.textTheme);

    final primaryBorderSide = BorderSide(color: colorScheme.primary, width: 1.5);
    const defaultBorderSide = BorderSide(color: Color(0xFF374151));

    final focusedBorder = OutlineInputBorder(borderSide: primaryBorderSide, borderRadius: BorderRadius.circular(8));

    final errorBorder = focusedBorder.copyWith(
      borderSide: primaryBorderSide.copyWith(color: colorScheme.error, width: 1),
    );

    final focusedErrorBorder = focusedBorder.copyWith(borderSide: primaryBorderSide.copyWith(color: colorScheme.error));

    final enabledBorder = OutlineInputBorder(borderSide: defaultBorderSide, borderRadius: BorderRadius.circular(8));

    final disabledBorder = OutlineInputBorder(
      borderSide: defaultBorderSide.copyWith(color: colorScheme.outlineVariant),
      borderRadius: BorderRadius.circular(8),
    );

    // 3. Attach customTextTheme to ThemeData
    return baseTheme.copyWith(
      textTheme: customTextTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        hintStyle: TextStyle(color: colorScheme.onSurface.withAlpha(96)),
        labelStyle: TextStyle(color: colorScheme.onSurface.withAlpha(96)),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        disabledBorder: disabledBorder,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
      ),
      navigationBarTheme: const NavigationBarThemeData(labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 9))),
      bannerTheme: const MaterialBannerThemeData(contentTextStyle: TextStyle(color: Colors.white)),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: buttonTextStyle,
          fixedSize: buttonFixedSize,
          minimumSize: buttonFixedSize,
          shape: WidgetStatePropertyAll(shapeBorder),
          foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: buttonTextStyle,
          fixedSize: buttonFixedSize,
          minimumSize: buttonFixedSize,
          shape: WidgetStatePropertyAll(shapeBorder),
          backgroundBuilder: (context, states, child) => DecoratedBox(
            decoration: ShapeDecoration(
              shape: shapeBorder,
              gradient: states.contains(WidgetState.disabled)
                ? null
                : const LinearGradient(colors: [saibleLightGreen, saibleGreen]),
            ),
            child: child,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: buttonTextStyle,
          fixedSize: buttonFixedSize,
          minimumSize: buttonFixedSize,
          shape: WidgetStatePropertyAll(shapeBorder),
          side: WidgetStateProperty.all(BorderSide(color: colorScheme.primary)),
        ),
      ),
    );
  }
}

/// Typography extensions for Saible title styles on [TextTheme].
extension TitleTheme on TextTheme {
  /// A stylized titleMedium text style with increased weight and font size.
  TextStyle? get saibleTitle => titleMedium?.apply(fontWeightDelta: 2, fontSizeDelta: 2);
}
