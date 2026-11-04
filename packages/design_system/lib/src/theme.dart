import 'package:flutter/material.dart';

/// ============================================================================
/// QUICKSEVA DESIGN TOKENS: CLEAN WHITE + FOREST/EMERALD GREEN + WARM IVORY
/// + STITCH "KARMIC MOTION" LAYERED SOLID ACCENTS (ZERO GRADIENTS)
/// ============================================================================
class QColors {
  QColors._();

  // Primary Brand Greens (Deep Emerald / Forest Green)
  static const Color primaryGreen = Color(0xFF0B6E4F);
  static const Color primaryGreenDark = Color(0xFF074E38);
  static const Color accentGreen = Color(0xFF10966C);
  static const Color vibrantMint = Color(0xFF16A34A);
  static const Color softGreenTint = Color(0xFFE7F6F0);
  static const Color softGreenBorder = Color(0xFFB7E4D3);

  // Stitch "Karmic Motion" High-Contrast Solid Accents (No Gradients)
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

  // Badges, Promos & Status Accents (flat solid colours only, no gradients)
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

class QTheme {
  QTheme._();

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
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
          borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
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
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

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
