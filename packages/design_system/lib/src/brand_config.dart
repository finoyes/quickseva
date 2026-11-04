import 'l10n.dart';

/// ============================================================================
/// SINGLE-LINE BRAND CONFIGURATION TOKEN
/// Change [brandName] or [brandNameHindi] here to rebrand both Customer &
/// Labor/Provider apps across all screens instantly.
/// ============================================================================
class BrandConfig {
  BrandConfig._();

  /// Primary brand name in English (change this single line to rename the app)
  static const String brandName = 'QuickSeva';

  /// Primary brand name in Hindi
  static const String brandNameHindi = 'क्विकसेवा';

  /// Partner / Labor app suffix
  static const Tr partnerAppTitle = Tr(
    'QuickSeva Partner',
    'क्विकसेवा पार्टनर',
  );

  /// Customer app title
  static Tr get customerAppTitle => const Tr(
        brandName,
        brandNameHindi,
      );

  /// Tagline
  static const Tr tagline = Tr(
    'Trusted home services in minutes',
    'मिनटों में भरोसेमंद होम सर्विसेज़',
  );

  /// Default launch address (matching UC reference style)
  static const Tr defaultAddressLabel = Tr('Home', 'घर');
  static const Tr defaultAddressLine = Tr(
    'House 416, Sector 3, Udaipur, Rajasthan',
    'मकान 416, सेक्टर 3, उदयपुर, राजस्थान',
  );

  /// Instant service promise time in minutes
  static const int instantPromiseMinutes = 14;

  /// Currency symbol
  static const String currency = '₹';

  /// Helper to resolve brand name by current language
  static String name(AppLanguage lang) =>
      lang == AppLanguage.hi ? brandNameHindi : brandName;
}

