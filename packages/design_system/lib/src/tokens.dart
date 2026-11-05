import 'dart:ui';

import 'package:flutter/material.dart';

/// ============================================================================
/// QUICKSEVA DESIGN TOKENS
/// Single source of truth for radius, spacing, typography, motion, elevation,
/// and glass settings. Derived from design_tokens.json (Peach Pop v0.1.0).
///
/// Color tokens live in theme.dart as [QSevaColors] ThemeExtension.
/// Legacy color constants remain in [QColors] for provider-app compat.
/// ============================================================================

// ---------------------------------------------------------------------------
// CORNER RADIUS (dp)
// ---------------------------------------------------------------------------

/// Corner radius scale. Use semantic aliases when available.
class QRadius {
  QRadius._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 28;
  static const double pill = 999;

  // Semantic aliases (from design_tokens.json radius.usage)
  static const double button = pill;
  static const double chip = pill;
  static const double input = md;
  static const double tile = lg;
  static const double card = lg;
  static const double sheetTop = xl;
  static const double thumbnail = sm;
}

// ---------------------------------------------------------------------------
// SPACING – 4-pt grid (dp)
// ---------------------------------------------------------------------------

/// Spacing scale built on a 4 dp base unit.
class QSpace {
  QSpace._();

  static const double unit = 4;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double jumbo = 56;

  /// Horizontal screen padding.
  static const double screenH = 20;

  /// Vertical gap between home-page sections.
  static const double section = 28;

  /// Backward-compat alias used by provider app.
  static const double gutter = screenH;
}

// ---------------------------------------------------------------------------
// FONT FAMILIES
// ---------------------------------------------------------------------------

/// Brand font family constants.
///
/// Display font (Bricolage Grotesque) is used for headlines, prices and big
/// numbers. Body font (Plus Jakarta Sans) is used for everything else. Noto
/// Sans Devanagari is the Hindi fallback for both.
class QFonts {
  QFonts._();

  /// Headlines, prices, big numbers.
  static const String display = 'packages/design_system/BricolageGrotesque';

  /// Everything else.
  static const String body = 'packages/design_system/PlusJakartaSans';

  /// Hindi script fallback.
  static const List<String> fallback = [
    'packages/design_system/NotoSansDevanagari',
  ];
}

// ---------------------------------------------------------------------------
// TYPE SCALE
// ---------------------------------------------------------------------------

/// Typography scale derived from design_tokens.json.
///
/// Styles do **not** include color so they work with both Peach Pop and
/// Forest Green themes. Apply color via `.copyWith(color: ...)` or let the
/// theme's default text style handle it.
class QText {
  QText._();

  // ---- Display font (Bricolage Grotesque) --------------------------------

  static const TextStyle displayL = TextStyle(
    fontFamily: QFonts.display,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 40 / 34, // line height 40
    letterSpacing: -0.5,
  );

  static const TextStyle displayM = TextStyle(
    fontFamily: QFonts.display,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 34 / 28,
    letterSpacing: -0.4,
  );

  static const TextStyle titleL = TextStyle(
    fontFamily: QFonts.display,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
    letterSpacing: -0.2,
  );

  // ---- Body font (Plus Jakarta Sans) -------------------------------------

  static const TextStyle titleM = TextStyle(
    fontFamily: QFonts.body,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
  );

  static const TextStyle bodyL = TextStyle(
    fontFamily: QFonts.body,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
  );

  static const TextStyle body = TextStyle(
    fontFamily: QFonts.body,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 22 / 15,
  );

  static const TextStyle bodyS = TextStyle(
    fontFamily: QFonts.body,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
  );

  static const TextStyle labelL = TextStyle(
    fontFamily: QFonts.body,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 20 / 16,
  );

  static const TextStyle label = TextStyle(
    fontFamily: QFonts.body,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 16 / 13,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: QFonts.body,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
  );

  /// Price with tabular figures — uses display font for punch.
  static const TextStyle price = TextStyle(
    fontFamily: QFonts.display,
    fontFamilyFallback: QFonts.fallback,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ---- Legacy aliases (provider-app backward compat) ---------------------

  /// Alias for [displayM].
  static TextStyle get display => displayM;

  /// Alias for [titleL].
  static TextStyle get headline => titleL;

  /// Section header style (between titleL and titleM).
  static TextStyle get section =>
      titleL.copyWith(fontSize: 19, fontWeight: FontWeight.w800);

  /// Alias for [titleM] at a slightly smaller size.
  static TextStyle get title =>
      titleM.copyWith(fontSize: 15.5, letterSpacing: -0.2);
}

// ---------------------------------------------------------------------------
// MOTION
// ---------------------------------------------------------------------------

/// Motion timing tokens, curves, springs, and accessibility helpers.
class QMotion {
  QMotion._();

  // ---- Durations ---------------------------------------------------------

  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 450);
  static const Duration hero = Duration(milliseconds: 700);

  /// Legacy alias for [hero].
  static const Duration emphasized = hero;

  // ---- Curves ------------------------------------------------------------

  /// General-purpose transition.
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Entrance / decelerate.
  static const Curve enter = Cubic(0.05, 0.7, 0.1, 1.0);

  /// Exit / accelerate.
  static const Curve exit = Cubic(0.3, 0.0, 0.8, 0.15);

  /// Playful overshoot.
  static const Curve spring = Curves.easeOutBack;

  // ---- Physics springs ---------------------------------------------------

  static SpringDescription get softSpring =>
      const SpringDescription(mass: 1, stiffness: 180, damping: 20);

  static SpringDescription get snappySpring =>
      const SpringDescription(mass: 1, stiffness: 320, damping: 24);

  static SpringDescription get bouncySpring =>
      const SpringDescription(mass: 1, stiffness: 220, damping: 14);

  // ---- Stagger -----------------------------------------------------------

  /// Delay between consecutive staggered items.
  static const Duration staggerStep = Duration(milliseconds: 50);

  /// Maximum items in a staggered reveal.
  static const int staggerMax = 8;

  // ---- Press feedback ----------------------------------------------------

  /// Scale factor when pressing a card / button.
  static const double pressScale = 0.97;

  // ---- Float 3D (for category icons) -------------------------------------

  /// Vertical float amplitude (dp).
  static const double floatAmplitude = 6;

  /// Float loop period.
  static const Duration floatPeriod = Duration(milliseconds: 3200);

  /// Maximum tilt angle (degrees).
  static const double floatTiltMax = 6;

  /// Shadow scale range [min, max].
  static const double floatShadowMin = 0.9;
  static const double floatShadowMax = 1.0;

  // ---- Accessibility helpers ---------------------------------------------

  /// True when the OS asks for reduced motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// Returns [d], or 120 ms when reduced-motion is on (spec: 120 ms fade).
  static Duration of(BuildContext context, Duration d) =>
      reduced(context) ? const Duration(milliseconds: 120) : d;

  /// Returns [Duration.zero] when reduced-motion is on (for loops/parallax).
  static Duration orZero(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}

// ---------------------------------------------------------------------------
// ELEVATION (themed box shadows)
// ---------------------------------------------------------------------------

/// Elevation shadow sets. Use [QSevaElevation] from the theme for themed
/// values, or these static helpers for quick access.
class QElevation {
  QElevation._();

  // ---- Light theme -------------------------------------------------------

  static const List<BoxShadow> lightE1 = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(51, 32, 28, 0.06),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 12,
      color: Color.fromRGBO(51, 32, 28, 0.06),
    ),
  ];

  static const List<BoxShadow> lightE2 = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      color: Color.fromRGBO(51, 32, 28, 0.06),
    ),
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 28,
      color: Color.fromRGBO(51, 32, 28, 0.10),
    ),
  ];

  static const List<BoxShadow> lightE3 = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 8,
      color: Color.fromRGBO(51, 32, 28, 0.08),
    ),
    BoxShadow(
      offset: Offset(0, 24),
      blurRadius: 48,
      color: Color.fromRGBO(51, 32, 28, 0.14),
    ),
  ];

  static const List<BoxShadow> lightAccentGlow = [
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 24,
      color: Color.fromRGBO(255, 158, 128, 0.45),
    ),
  ];

  // ---- Dark theme --------------------------------------------------------

  static const List<BoxShadow> darkE1 = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color.fromRGBO(0, 0, 0, 0.30),
    ),
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 12,
      color: Color.fromRGBO(0, 0, 0, 0.30),
    ),
  ];

  static const List<BoxShadow> darkE2 = [
    BoxShadow(
      offset: Offset(0, 2),
      blurRadius: 4,
      color: Color.fromRGBO(0, 0, 0, 0.35),
    ),
    BoxShadow(
      offset: Offset(0, 12),
      blurRadius: 28,
      color: Color.fromRGBO(0, 0, 0, 0.45),
    ),
  ];

  static const List<BoxShadow> darkE3 = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 8,
      color: Color.fromRGBO(0, 0, 0, 0.40),
    ),
    BoxShadow(
      offset: Offset(0, 24),
      blurRadius: 48,
      color: Color.fromRGBO(0, 0, 0, 0.55),
    ),
  ];

  static const List<BoxShadow> darkAccentGlow = [
    BoxShadow(
      offset: Offset(0, 8),
      blurRadius: 24,
      color: Color.fromRGBO(255, 158, 128, 0.25),
    ),
  ];

  // ---- Forest Green legacy shadows (provider-app compat) -----------------

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF131B17).withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: const Color(0xFF0B6E4F).withValues(alpha: 0.14),
          blurRadius: 22,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get darkSlateShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.16),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];
}

// ---------------------------------------------------------------------------
// GLASS SURFACE TOKENS
// ---------------------------------------------------------------------------

/// Glass morphism settings per brightness.
class QGlass {
  final double blurSigma;
  final Color fill;
  final Color border;
  final Color hairline;
  final double borderWidth;
  final Color topHighlight;

  const QGlass({
    required this.blurSigma,
    required this.fill,
    required this.border,
    required this.hairline,
    this.borderWidth = 1,
    required this.topHighlight,
  });

  static const QGlass light = QGlass(
    blurSigma: 24,
    fill: Color.fromRGBO(255, 255, 255, 0.70),
    border: Color.fromRGBO(255, 255, 255, 0.80),
    hairline: Color.fromRGBO(51, 32, 28, 0.06),
    topHighlight: Color.fromRGBO(255, 255, 255, 0.90),
  );

  static const QGlass dark = QGlass(
    blurSigma: 24,
    fill: Color.fromRGBO(255, 255, 255, 0.08),
    border: Color.fromRGBO(255, 255, 255, 0.16),
    hairline: Color.fromRGBO(0, 0, 0, 0.30),
    topHighlight: Color.fromRGBO(255, 255, 255, 0.18),
  );

  /// Max number of blurred layers per screen.
  static const int maxBlurLayersPerScreen = 2;
}
