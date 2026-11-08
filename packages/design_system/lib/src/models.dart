import 'package:flutter/material.dart';
import 'l10n.dart';

/// Top-level service category (7 categories pre-seeded)
class ServiceCategory {
  final String id;
  final Tr name;
  final Tr subtitle;
  final IconData icon;
  final String imageUrl;
  final bool hasInstantBadge;
  final Tr? badgeText;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.imageUrl,
    this.hasInstantBadge = false,
    this.badgeText,
  });
}

/// Duration or package tier card (e.g. "45 mins • ₹49 ~~₹225~~ 78% OFF" in UC Screenshot #1)
class ServicePackageTier {
  final String id;
  final Tr title;
  final Tr subtitle;
  final int priceRupees;
  final int originalPriceRupees;
  final int durationMinutes;
  final bool isBestseller;
  final List<Tr> inclusions;

  const ServicePackageTier({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceRupees,
    required this.originalPriceRupees,
    required this.durationMinutes,
    this.isBestseller = false,
    this.inclusions = const [],
  });

  int get discountPercent {
    if (originalPriceRupees <= priceRupees) return 0;
    return (((originalPriceRupees - priceRupees) / originalPriceRupees) * 100)
        .round();
  }
}

/// Super Saver multi-visit pack banner (matching UC Screenshot #1)
class SuperSaverPack {
  final String id;
  final Tr badgeText;
  final Tr headline;
  final Tr pricePerVisitText;
  final Tr validityText;
  final int packPriceRupees;
  final int originalPriceRupees;

  const SuperSaverPack({
    required this.id,
    required this.badgeText,
    required this.headline,
    required this.pricePerVisitText,
    required this.validityText,
    required this.packPriceRupees,
    required this.originalPriceRupees,
  });
}

/// Dynamic service booking form field (Section 10 of ARCHITECTURE.md)
enum FormFieldType { select, stepper, checklist }

class ServiceFormOption {
  final String value;
  final Tr label;
  final int extraPriceRupees;

  const ServiceFormOption({
    required this.value,
    required this.label,
    this.extraPriceRupees = 0,
  });
}

class ServiceFormField {
  final String key;
  final FormFieldType type;
  final Tr label;
  final List<ServiceFormOption> options;
  final int min;
  final int max;
  final int defaultValue;

  const ServiceFormField({
    required this.key,
    required this.type,
    required this.label,
    this.options = const [],
    this.min = 1,
    this.max = 5,
    this.defaultValue = 1,
  });
}

/// Individual bookable service in the catalogue
class ServiceItem {
  final String id;
  final String categoryId;
  final Tr name;
  final Tr tagline;
  final Tr description;
  final String imageUrl;
  final double rating;
  final String bookingsCountLabel;
  final bool supportsInstant;
  final int instantEtaMinutes;
  final int startingPriceRupees;
  final int originalStartingPriceRupees;
  final int estimatedDurationMinutes;
  final List<ServicePackageTier> packages;
  final SuperSaverPack? superSaverPack;
  final List<Tr> capabilities;
  final List<ServiceFormField> formFields;

  const ServiceItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.bookingsCountLabel,
    required this.supportsInstant,
    this.instantEtaMinutes = 14,
    required this.startingPriceRupees,
    required this.originalStartingPriceRupees,
    required this.estimatedDurationMinutes,
    required this.packages,
    this.superSaverPack,
    this.capabilities = const [],
    this.formFields = const [],
  });
}

/// Masonry discovery card item (matching UC Screenshot #2 "Discover")
class DiscoveryCardItem {
  final String id;
  final String serviceId;
  final Tr title;
  final String imageUrl;
  final double aspectRatio;
  final Tr? badge;

  const DiscoveryCardItem({
    required this.id,
    required this.serviceId,
    required this.title,
    required this.imageUrl,
    required this.aspectRatio,
    this.badge,
  });
}

/// Date card in the Schedule picker (matching UC Screenshot #3)
enum DemandTrend { none, highUp, lowDown }

class DateSlotItem {
  final String id;
  final Tr dayShort;
  final String dateNumber;
  final Tr fullDateLabel;
  final DemandTrend trend;

  const DateSlotItem({
    required this.id,
    required this.dayShort,
    required this.dateNumber,
    required this.fullDateLabel,
    this.trend = DemandTrend.none,
  });
}

/// Time slot cell in the Schedule picker (matching UC Screenshot #3)
class TimeSlotItem {
  final String id;
  final String label;
  final int peakSurchargeRupees;
  final bool isAvailable;

  const TimeSlotItem({
    required this.id,
    required this.label,
    this.peakSurchargeRupees = 0,
    this.isAvailable = true,
  });
}

/// Booking lifecycle statuses (Section 8.1 of ARCHITECTURE.md)
enum BookingStatus {
  searching,
  assigned,
  enRoute,
  arrived,
  inProgress,
  completed,
}

/// Payment modes for MVP (Cash + Dummy Online PG)
enum PaymentMode {
  cash('CASH', Tr('Pay by Cash after service', 'सेवा के बाद नकद भुगतान करें')),
  dummyOnline(
    'DUMMY_PG',
    Tr('Online UPI / Card (Instant Demo PG)', 'ऑनलाइन UPI / कार्ड (डेमो पेमेंट)'),
  );

  final String code;
  final Tr label;
  const PaymentMode(this.code, this.label);
}

/// Active or past booking order
class BookingOrder {
  final String id;
  final ServiceItem service;
  final ServicePackageTier selectedPackage;
  final bool isInstant;
  final String scheduleLabel;
  final int totalAmountRupees;
  final PaymentMode paymentMode;
  final String startOtp;
  final Tr providerName;
  final String providerRating;
  final String providerPhoneMasked;
  BookingStatus status;
  int extraSparePartsRupees;
  int? ratingStars;
  int tipRupees;
  bool isRecurring;
  String? warrantyClaimStatus;

  BookingOrder({
    required this.id,
    required this.service,
    required this.selectedPackage,
    required this.isInstant,
    required this.scheduleLabel,
    required this.totalAmountRupees,
    required this.paymentMode,
    this.startOtp = '4829',
    this.providerName = const Tr('Rameshwar Sharma', 'रमेश्वर शर्मा'),
    this.providerRating = '4.9 ★ (312 jobs)',
    this.providerPhoneMasked = '+91 8045-XX-XX92 (Masked)',
    this.status = BookingStatus.assigned,
    this.extraSparePartsRupees = 0,
    this.ratingStars,
    this.tipRupees = 0,
    this.isRecurring = false,
    this.warrantyClaimStatus,
  });
}

/// Incoming job offer for the Labor / Provider app
class ProviderJobOffer {
  final String offerId;
  final String bookingId;
  final Tr serviceName;
  final Tr packageName;
  final bool isInstant;
  final Tr customerName;
  final Tr addressArea;
  final Tr fullAddress;
  final double distanceKm;
  final int etaMinutes;
  final int grossAmountRupees;
  final int platformFeeRupees;
  final int netPayoutRupees;
  final PaymentMode paymentMode;
  final String startOtp;
  final List<Tr> taskChecklist;

  const ProviderJobOffer({
    required this.offerId,
    required this.bookingId,
    required this.serviceName,
    required this.packageName,
    required this.isInstant,
    required this.customerName,
    required this.addressArea,
    required this.fullAddress,
    required this.distanceKm,
    required this.etaMinutes,
    required this.grossAmountRupees,
    required this.platformFeeRupees,
    required this.netPayoutRupees,
    required this.paymentMode,
    this.startOtp = '4829',
    required this.taskChecklist,
  });
}

/// Double-entry ledger journal line for Provider Wallet & Analytics
class LedgerJournalItem {
  final String id;
  final Tr title;
  final Tr subtitle;
  final String timestampLabel;
  final int amountRupees;
  final bool isCredit;
  final Tr tag;

  const LedgerJournalItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestampLabel,
    required this.amountRupees,
    required this.isCredit,
    required this.tag,
  });
}

