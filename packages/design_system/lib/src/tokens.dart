import 'package:flutter/material.dart';

import 'theme.dart';

/// ============================================================================
/// QUICKSEVA LAYOUT, TYPE & MOTION TOKENS
/// Single source of truth for corner radii, spacing, the type scale and
/// animation timing. Screens should use these instead of ad-hoc numbers so
/// both apps stay visually consistent.
/// ============================================================================

/// Corner radius scale.
class QRadius {
  QRadius._();

  /// Tags, tiny badges.
  static const double xs = 6;

  /// Chips, small buttons, icon tiles.
  static const double sm = 10;

  /// Buttons, inputs, inner tiles.
  static const double md = 12;

  /// Standard cards.
  static const double lg = 18;

  /// Hero cards, bottom sheets.
  static const double xl = 24;

  /// Fully rounded pill.
  static const double pill = 999;
}

/// 4-pt spacing scale.
class QSpace {
  QSpace._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal gutter for every screen.
  static const double gutter = 18;

  /// Vertical gap between home sections.
  static const double section = 26;
}

/// Type scale. Colors default to ink tokens and can be overridden with
/// `.copyWith(color: ...)`.
class QText {
  QText._();

  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: QColors.inkDark,
    letterSpacing: -0.8,
    height: 1.12,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: QColors.inkDark,
    letterSpacing: -0.5,
    height: 1.18,
  );

  /// Home section titles.
  static const TextStyle section = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w800,
    color: QColors.inkDark,
    letterSpacing: -0.4,
    height: 1.2,
  );

  static const TextStyle title = TextStyle(
    fontSize: 15.5,
    fontWeight: FontWeight.w700,
    color: QColors.inkDark,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static const TextStyle body = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    color: QColors.inkBody,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: QColors.inkMuted,
    height: 1.35,
  );

  /// Uppercase-friendly micro label for badges and tags.
  static const TextStyle label = TextStyle(
    fontSize: 10.5,
    fontWeight: FontWeight.w800,
    color: QColors.inkDark,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: QColors.inkDark,
    letterSpacing: -0.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

/// Motion timing tokens + accessibility (reduce motion) helpers.
class QMotion {
  QMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration emphasized = Duration(milliseconds: 600);

  /// Material 3 "emphasized decelerate" curve, used for entrances.
  static const Curve enter = Cubic(0.05, 0.7, 0.1, 1.0);

  /// Material 3 "emphasized accelerate" curve, used for exits.
  static const Curve exit = Cubic(0.3, 0.0, 0.8, 0.15);

  /// Standard curve for state changes.
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Playful overshoot for confirmations and bounces.
  static const Curve spring = Curves.easeOutBack;

  /// True when the OS asks for reduced motion (Android "Remove animations",
  /// iOS "Reduce Motion").
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// Returns [d], or [Duration.zero] when reduce-motion is on.
  static Duration of(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}

