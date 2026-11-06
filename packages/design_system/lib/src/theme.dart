import 'package:flutter/material.dart';

import 'tokens.dart';

/// ============================================================================
/// QUICKSEVA THEME SYSTEM
///
/// Dual-theme architecture:
///   • **Peach Pop** – warm pastel glassmorphism (customer app)
///   • **Forest Green** – emerald/ivory flat solids (provider app)
///
/// Both share the same token infrastructure (QRadius, QSpace, QText, QMotion).
/// App-specific colors come from [QSevaColors] ThemeExtension.
/// ============================================================================

// ---------------------------------------------------------------------------
// LEGACY COLORS (provider-app backward compat – DO NOT REMOVE)
// ---------------------------------------------------------------------------

/// Forest Green / Stitch Karmic Motion color palette.
///
/// Kept unchanged so `provider_app` continues to compile and render identically.
/// Customer app should use [QSevaColors] from the theme instead.
class QColors {
  QColors._();

  // Primary Brand Greens
  static const Color primaryGreen = Color(0xFF0B6E4F);
  static const Color primaryGreenDark = Color(0xFF074E38);
  static const Color accentGreen = Color(0xFF10966C);
  static const Color vibrantMint = Color(0xFF16A34A);
  static const Color softGreenTint = Color(0xFFE7F6F0);
  static const Color softGreenBorder = Color(0xFFB7E4D3);

  // Stitch "Karmic Motion" High-Contrast Solid Accents
  static const Color deepSlate = Color(0xFF0F172A);
  static const Color deepSlateSurface = Color(0xFF1E293B);
  static const Color deepSlateShape = Color(0xFF334155);
  static const Color karmicOrange = Color(0xFFEA580C);
  static const Color karmicOrangeSoft = Color(0xFFFFEDD5);
  static const Color trustBlue = Color(0xFF2563EB);
  static const Color trustBlueSoft = Color(0xFFEFF6FF);
  static const Color violetSoft = Color(0xFFF3E8FF);
  static const Color violetInk = Color(0xFF7C3AED);

  // Clean White & Warm Ivory Surfaces
  static const Color cleanWhite = Color(0xFFFFFFFF);
  static const Color warmIvoryBg = Color(0xFFFAF7F2);
  static const Color warmIvorySurface = Color(0xFFF3EFE6);
  static const Color warmIvoryHighlight = Color(0xFFEBE4D6);
  static const Color borderSubtle = Color(0xFFE6E1D6);
  static const Color borderStrong = Color(0xFFD2CBB8);

  // Typography & Ink Colors
  static const Color inkDark = Color(0xFF131B17);
  static const Color inkBody = Color(0xFF2D3833);
  static const Color inkMuted = Color(0xFF66736C);
  static const Color inkLight = Color(0xFF94A09A);

  // Badges, Promos & Status Accents
  static const Color bestsellerForest = Color(0xFF14532D);
  static const Color superSaverBg = Color(0xFF0B6E4F);
  static const Color offlineSlate = Color(0xFF37413B);
  static const Color mapSurface = Color(0xFFEAF5EF);
  static const Color amberGold = Color(0xFFD97706);
  static const Color amberSoftBg = Color(0xFFFEF3C7);
  static const Color dangerRed = Color(0xFFDC2626);
  static const Color dangerSoftBg = Color(0xFFFEE2E2);
  static const Color infoTeal = Color(0xFF0D9488);
}

// ---------------------------------------------------------------------------
// SEVA COLORS – ThemeExtension for dual-theme support
// ---------------------------------------------------------------------------

/// Semantic color tokens that adapt to Peach Pop or Forest Green theme.
///
/// Access via `Theme.of(context).extension<QSevaColors>()!` or use the
/// convenience `QSevaColors.of(context)`.
@immutable
class QSevaColors extends ThemeExtension<QSevaColors> {
  // Backgrounds
  final Color base;
  final Color surface;
  final Color surfaceSunken;

  // Glass
  final Color glassFill;
  final Color glassBorder;
  final Color glassHairline;

  // Ink / text
  final Color ink;
  final Color inkSecondary;
  final Color inkMuted;

  // Borders
  final Color border;

  // Accent gradient endpoints
  final Color accentStart;
  final Color accentEnd;
  final Color onAccent;

  // Semantic
  final Color highlight;
  final Color danger;
  final Color warning;

  // Support pastels (category tiles, chip backgrounds, illustration backdrops)
  final Color pistachio;
  final Color sky;
  final Color lilac;
  final Color rose;
  final Color peachTint;

  // Elevation shadows for this brightness
  final List<BoxShadow> e1;
  final List<BoxShadow> e2;
  final List<BoxShadow> e3;
  final List<BoxShadow> accentGlow;

  const QSevaColors({
    required this.base,
    required this.surface,
    required this.surfaceSunken,
    required this.glassFill,
    required this.glassBorder,
    required this.glassHairline,
    required this.ink,
    required this.inkSecondary,
    required this.inkMuted,
    required this.border,
    required this.accentStart,
    required this.accentEnd,
    required this.onAccent,
    required this.highlight,
    required this.danger,
    required this.warning,
    required this.pistachio,
    required this.sky,
    required this.lilac,
    required this.rose,
    required this.peachTint,
    required this.e1,
    required this.e2,
    required this.e3,
    required this.accentGlow,
  });

  /// Convenience accessor.
  static QSevaColors of(BuildContext context) =>
      Theme.of(context).extension<QSevaColors>()!;

  /// The 135° accent gradient. Allowed on: primary button, hero surface,
  /// progress bar, selected state, and success moment.
  LinearGradient get accentGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight, // ≈ 135°
        colors: [accentStart, accentEnd],
      );

  /// Rotates through support pastels by index for category tiles.
  Color supportColor(int index) {
    final colors = [pistachio, sky, lilac, rose, peachTint];
    return colors[index % colors.length];
  }

  // ---- Peach Pop instances ------------------------------------------------

  static const peachPopLight = QSevaColors(
    base: Color(0xFFFFF8F2),
    surface: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFFFEFE4),
    glassFill: Color.fromRGBO(255, 255, 255, 0.70),
    glassBorder: Color.fromRGBO(255, 255, 255, 0.80),
    glassHairline: Color.fromRGBO(51, 32, 28, 0.06),
    ink: Color(0xFF33201C),
    inkSecondary: Color(0xFF8A6A60),
    inkMuted: Color(0xFFB39B92),
    border: Color.fromRGBO(51, 32, 28, 0.10),
    accentStart: Color(0xFFFF9E80),
    accentEnd: Color(0xFFFFC857),
    onAccent: Color(0xFF33201C),
    highlight: Color(0xFF2BC6B4),
    danger: Color(0xFFE5605F),
    warning: Color(0xFFF5A524),
    pistachio: Color(0xFFD4F0C8),
    sky: Color(0xFFCFE6FF),
    lilac: Color(0xFFE6D9FF),
    rose: Color(0xFFFFD6E4),
    peachTint: Color(0xFFFFE3D6),
    e1: QElevation.lightE1,
    e2: QElevation.lightE2,
    e3: QElevation.lightE3,
    accentGlow: QElevation.lightAccentGlow,
  );

  static const peachPopDark = QSevaColors(
    base: Color(0xFF1C1311),
    surface: Color(0xFF2A1C19),
    surfaceSunken: Color(0xFF241715),
    glassFill: Color.fromRGBO(255, 255, 255, 0.08),
    glassBorder: Color.fromRGBO(255, 255, 255, 0.16),
    glassHairline: Color.fromRGBO(0, 0, 0, 0.30),
    ink: Color(0xFFFFF3EC),
    inkSecondary: Color(0xFFC9A99E),
    inkMuted: Color(0xFF8C7168),
    border: Color.fromRGBO(255, 255, 255, 0.12),
    accentStart: Color(0xFFFF9E80),
    accentEnd: Color(0xFFFFC857),
    onAccent: Color(0xFF33201C),
    highlight: Color(0xFF2BC6B4),
    danger: Color(0xFFF27D7C),
    warning: Color(0xFFF7B955),
    pistachio: Color(0xFFD4F0C8),
    sky: Color(0xFFCFE6FF),
    lilac: Color(0xFFE6D9FF),
    rose: Color(0xFFFFD6E4),
    peachTint: Color(0xFFFFE3D6),
    e1: QElevation.darkE1,
    e2: QElevation.darkE2,
    e3: QElevation.darkE3,
    accentGlow: QElevation.darkAccentGlow,
  );

  // ---- Forest Green instances (for provider app) --------------------------

  static const forestGreenLight = QSevaColors(
    base: Color(0xFFFAF7F2), // warmIvoryBg
    surface: Color(0xFFFFFFFF), // cleanWhite
    surfaceSunken: Color(0xFFF3EFE6), // warmIvorySurface
    glassFill: Color.fromRGBO(255, 255, 255, 0.80),
    glassBorder: Color.fromRGBO(255, 255, 255, 0.90),
    glassHairline: Color.fromRGBO(19, 27, 23, 0.06),
    ink: Color(0xFF131B17), // inkDark
    inkSecondary: Color(0xFF2D3833), // inkBody
    inkMuted: Color(0xFF66736C), // inkMuted
    border: Color(0xFFE6E1D6), // borderSubtle
    accentStart: Color(0xFF0B6E4F), // primaryGreen
    accentEnd: Color(0xFF10966C), // accentGreen
    onAccent: Color(0xFFFFFFFF),
    highlight: Color(0xFF0D9488), // infoTeal
    danger: Color(0xFFDC2626), // dangerRed
    warning: Color(0xFFD97706), // amberGold
    pistachio: Color(0xFFE7F6F0), // softGreenTint
    sky: Color(0xFFEFF6FF), // trustBlueSoft
    lilac: Color(0xFFF3E8FF), // violetSoft
    rose: Color(0xFFFEE2E2), // dangerSoftBg
    peachTint: Color(0xFFFFEDD5), // karmicOrangeSoft
    e1: QElevation.lightE1,
    e2: QElevation.lightE2,
    e3: QElevation.lightE3,
    accentGlow: QElevation.lightAccentGlow,
  );

  // ---- ThemeExtension boilerplate ----------------------------------------

  @override
  QSevaColors copyWith({
    Color? base,
    Color? surface,
    Color? surfaceSunken,
    Color? glassFill,
    Color? glassBorder,
    Color? glassHairline,
    Color? ink,
    Color? inkSecondary,
    Color? inkMuted,
    Color? border,
    Color? accentStart,
    Color? accentEnd,
    Color? onAccent,
    Color? highlight,
    Color? danger,
    Color? warning,
    Color? pistachio,
    Color? sky,
    Color? lilac,
    Color? rose,
    Color? peachTint,
    List<BoxShadow>? e1,
    List<BoxShadow>? e2,
    List<BoxShadow>? e3,
    List<BoxShadow>? accentGlow,
  }) {
    return QSevaColors(
      base: base ?? this.base,
      surface: surface ?? this.surface,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      glassHairline: glassHairline ?? this.glassHairline,
      ink: ink ?? this.ink,
      inkSecondary: inkSecondary ?? this.inkSecondary,
      inkMuted: inkMuted ?? this.inkMuted,
      border: border ?? this.border,
      accentStart: accentStart ?? this.accentStart,
      accentEnd: accentEnd ?? this.accentEnd,
      onAccent: onAccent ?? this.onAccent,
      highlight: highlight ?? this.highlight,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      pistachio: pistachio ?? this.pistachio,
      sky: sky ?? this.sky,
      lilac: lilac ?? this.lilac,
      rose: rose ?? this.rose,
      peachTint: peachTint ?? this.peachTint,
      e1: e1 ?? this.e1,
      e2: e2 ?? this.e2,
      e3: e3 ?? this.e3,
      accentGlow: accentGlow ?? this.accentGlow,
    );
  }

  @override
  QSevaColors lerp(covariant QSevaColors? other, double t) {
    if (other == null) return this;
    return QSevaColors(
      base: Color.lerp(base, other.base, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassHairline: Color.lerp(glassHairline, other.glassHairline, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSecondary: Color.lerp(inkSecondary, other.inkSecondary, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      accentStart: Color.lerp(accentStart, other.accentStart, t)!,
      accentEnd: Color.lerp(accentEnd, other.accentEnd, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      pistachio: Color.lerp(pistachio, other.pistachio, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      lilac: Color.lerp(lilac, other.lilac, t)!,
      rose: Color.lerp(rose, other.rose, t)!,
      peachTint: Color.lerp(peachTint, other.peachTint, t)!,
      e1: t < 0.5 ? e1 : other.e1,
      e2: t < 0.5 ? e2 : other.e2,
      e3: t < 0.5 ? e3 : other.e3,
      accentGlow: t < 0.5 ? accentGlow : other.accentGlow,
    );
  }
}

// ---------------------------------------------------------------------------
// THEME BUILDER
// ---------------------------------------------------------------------------

class QTheme {
  QTheme._();

  /// Font families.
  static const String fontFamily = QFonts.body;
  static const List<String> fontFamilyFallback = QFonts.fallback;

  // =========================================================================
  // PEACH POP THEMES (customer app)
  // =========================================================================

  static ThemeData peachPopLight() {
    const c = QSevaColors.peachPopLight;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      scaffoldBackgroundColor: c.base,
      colorScheme: ColorScheme.light(
        primary: c.accentStart,
        onPrimary: c.onAccent,
        secondary: c.accentEnd,
        onSecondary: c.onAccent,
        surface: c.surface,
        onSurface: c.ink,
        error: c.danger,
      ),
    );

    return base.copyWith(
      extensions: const [c],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.chip),
        ),
        side: BorderSide(color: c.border),
        showCheckmark: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.ink,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: c.base,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.md),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.card),
          side: BorderSide(color: c.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accentStart,
          foregroundColor: c.onAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QRadius.button),
          ),
          textStyle: const TextStyle(
            fontFamily: QFonts.body,
            fontFamilyFallback: QFonts.fallback,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.ink,
          side: BorderSide(color: c.border, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QRadius.button),
          ),
          textStyle: const TextStyle(
            fontFamily: QFonts.body,
            fontFamilyFallback: QFonts.fallback,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(QRadius.sheetTop),
          ),
        ),
      ),
    );
  }

  static ThemeData peachPopDark() {
    const c = QSevaColors.peachPopDark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      scaffoldBackgroundColor: c.base,
      colorScheme: ColorScheme.dark(
        primary: c.accentStart,
        onPrimary: c.onAccent,
        secondary: c.accentEnd,
        onSecondary: c.onAccent,
        surface: c.surface,
        onSurface: c.ink,
        error: c.danger,
      ),
    );

    return base.copyWith(
      extensions: const [c],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.chip),
        ),
        side: BorderSide(color: c.border),
        showCheckmark: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.ink,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFamilyFallback,
          color: c.base,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.md),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.card),
          side: BorderSide(color: c.border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accentStart,
          foregroundColor: c.onAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QRadius.button),
          ),
          textStyle: const TextStyle(
            fontFamily: QFonts.body,
            fontFamilyFallback: QFonts.fallback,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.ink,
          side: BorderSide(color: c.border, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QRadius.button),
          ),
          textStyle: const TextStyle(
            fontFamily: QFonts.body,
            fontFamilyFallback: QFonts.fallback,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(QRadius.sheetTop),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // FOREST GREEN THEME (provider app – unchanged behavior)
  // =========================================================================

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      scaffoldBackgroundColor: QColors.warmIvoryBg,
      colorScheme: const ColorScheme.light(
        primary: QColors.primaryGreen,
        onPrimary: Colors.white,
        secondary: QColors.accentGreen,
        onSecondary: Colors.white,
        surface: QColors.cleanWhite,
        onSurface: QColors.inkDark,
        error: QColors.dangerRed,
      ),
    );

    return base.copyWith(
      extensions: const [QSevaColors.forestGreenLight],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.pill),
        ),
        side: const BorderSide(color: QColors.borderSubtle),
        showCheckmark: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: QColors.deepSlate,
        contentTextStyle: const TextStyle(
          fontFamily: QFonts.body,
          fontFamilyFallback: QFonts.fallback,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.md),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: QColors.cleanWhite,
        foregroundColor: QColors.inkDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: QColors.cleanWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(QRadius.lg),
          side: const BorderSide(color: QColors.borderSubtle, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: QColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: QColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: QFonts.body,
            fontFamilyFallback: QFonts.fallback,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: QColors.primaryGreen,
          side: const BorderSide(color: QColors.borderSubtle, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(QRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: QFonts.body,
            fontFamilyFallback: QFonts.fallback,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // LEGACY SHADOW HELPERS (provider-app compat – delegate to QElevation)
  // =========================================================================

  static List<BoxShadow> get softShadow => QElevation.softShadow;
  static List<BoxShadow> get elevatedShadow => QElevation.elevatedShadow;
  static List<BoxShadow> get darkSlateShadow => QElevation.darkSlateShadow;
}
