import 'package:flutter/material.dart';
import 'brand_config.dart';
import 'l10n.dart';
import 'models.dart';
import 'theme.dart';
import 'tokens.dart';
import 'widgets.dart';

// =============================================================================
// 1. MONETIZATION PLANS & DEMAND MODES (ARCHITECTURE.md §8, §9, §10)
// =============================================================================

enum MonetizationPlanType {
  commission(
    id: 'plan_commission_15',
    title: Tr('15% Commission Plan', '15% कमीशन प्लान'),
    subtitle: Tr(
      '15% platform fee + 18% GST on fee • Dues cap ₹1,000',
      '15% प्लेटफॉर्म शुल्क + शुल्क पर 18% GST • बकाया सीमा ₹1,000',
    ),
    badge: Tr('DEFAULT MVP', 'डिफ़ॉल्ट MVP'),
    commissionBps: 1500,
    weeklySubscriptionRupees: 0,
    perLeadFeeRupees: 0,
  ),
  subscription(
    id: 'plan_sub_499',
    title: Tr('Zero-Commission Pass (₹499/wk)', 'जीरो-कमीशन पास (₹499/सप्ताह)'),
    subtitle: Tr(
      '0% per-job fee • Keep 100% of job earnings while pass is active',
      '0% प्रति-काम शुल्क • पास सक्रिय रहने पर 100% कमाई आपकी',
    ),
    badge: Tr('0% COMMISSION', '0% कमीशन'),
    commissionBps: 0,
    weeklySubscriptionRupees: 499,
    perLeadFeeRupees: 0,
  ),
  hybrid(
    id: 'plan_hybrid_199_8',
    title: Tr('Hybrid Pro Plan (₹199/wk + 8%)', 'हाइब्रिड प्रो प्लान (₹199/सप्ताह + 8%)'),
    subtitle: Tr(
      'Low ₹199 weekly pass + reduced 8% commission per job',
      'कम ₹199 साप्ताहिक पास + प्रति काम केवल 8% कमीशन',
    ),
    badge: Tr('HYBRID', 'हाइब्रिड'),
    commissionBps: 800,
    weeklySubscriptionRupees: 199,
    perLeadFeeRupees: 0,
  ),
  payPerLead(
    id: 'plan_lead_35',
    title: Tr('Pay-Per-Lead Credits (₹35/lead)', 'पे-पर-लीड क्रेडिट्स (₹35/लीड)'),
    subtitle: Tr(
      'Flat ₹35 deducted from prepaid credits on job accept • 0% commission',
      'जॉब स्वीकार करने पर प्रीपेड वॉलेट से फ्लैट ₹35 • 0% कमीशन',
    ),
    badge: Tr('PREPAID LEADS', 'प्रीपेड लीड'),
    commissionBps: 0,
    weeklySubscriptionRupees: 0,
    perLeadFeeRupees: 35,
  );

  final String id;
  final Tr title;
  final Tr subtitle;
  final Tr badge;
  final int commissionBps;
  final int weeklySubscriptionRupees;
  final int perLeadFeeRupees;

  const MonetizationPlanType({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.commissionBps,
    required this.weeklySubscriptionRupees,
    required this.perLeadFeeRupees,
  });
}

enum DemandSurgeMode {
  normal(
    title: Tr('Normal Demand (0 Surge)', 'सामान्य मांग (जीरो सर्ज)'),
    subtitle: Tr('Standard 14-min express tariff', 'मानक 14-मिनट एक्सप्रेस रेट'),
    surchargeRupees: 0,
  ),
  lowDemandDiscount(
    title: Tr('Off-Peak Happy Hours (−₹15)', 'ऑफ-पीक हैप्पी आवर्स (−₹15)'),
    subtitle: Tr('Extra ₹15 off on mid-day slots', 'दोपहर के स्लॉट पर ₹15 की अतिरिक्त छूट'),
    surchargeRupees: -15,
  ),
  peakRainSurge(
    title: Tr('High Demand / Rain Surge (+₹25)', 'अधिक मांग / बारिश सर्ज (+₹25)'),
    subtitle: Tr('100% of surge goes directly to partner', 'सर्ज का 100% सीधे पार्टनर को मिलता है'),
    surchargeRupees: 25,
  );

  final Tr title;
  final Tr subtitle;
  final int surchargeRupees;

  const DemandSurgeMode({
    required this.title,
    required this.subtitle,
    required this.surchargeRupees,
  });
}

// =============================================================================
// 2. SAVED ADDRESSES, COUPONS & SPARE PARTS MODELS
// =============================================================================

class SavedAddressItem {
  final String id;
  final Tr label;
  final Tr addressLine;
  final String zoneTag;
  final int prosNearby;
  final int etaMinutes;

  const SavedAddressItem({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.zoneTag,
    required this.prosNearby,
    required this.etaMinutes,
  });
}

class CouponPromoItem {
  final String code;
  final Tr title;
  final Tr subtitle;
  final int discountRupees;
  final int minOrderRupees;

  const CouponPromoItem({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.discountRupees,
    required this.minOrderRupees,
  });
}

class SparePartTariffItem {
  final String id;
  final Tr name;
  final Tr warranty;
  final int priceRupees;

  const SparePartTariffItem({
    required this.id,
    required this.name,
    required this.warranty,
    required this.priceRupees,
  });
}

class JournalEntryLine {
  final String accountCode;
  final Tr accountLabel;
  final int debitRupees;
  final int creditRupees;

  const JournalEntryLine({
    required this.accountCode,
    required this.accountLabel,
    required this.debitRupees,
    required this.creditRupees,
  });
}

class FeeBreakdownResult {
  final MonetizationPlanType plan;
  final int labourRupees;
  final int sparePartsRupees;
  final int grossTotalRupees;
  final int platformCommissionRupees;
  final int gstOnFeeRupees;
  final int leadFeeRupees;
  final int totalPlatformTakeRupees;
  final int providerNetPayoutRupees;
  final List<JournalEntryLine> journalLines;

  const FeeBreakdownResult({
    required this.plan,
    required this.labourRupees,
    required this.sparePartsRupees,
    required this.grossTotalRupees,
    required this.platformCommissionRupees,
    required this.gstOnFeeRupees,
    required this.leadFeeRupees,
    required this.totalPlatformTakeRupees,
    required this.providerNetPayoutRupees,
    required this.journalLines,
  });
}

// =============================================================================
// 3. PURE FEE ENGINE & DOUBLE-ENTRY LEDGER GENERATOR (ARCHITECTURE.md §9.2-9.4)
// =============================================================================

class DummyFeeEngine {
  DummyFeeEngine._();

  /// Pure deterministic calculation matching ARCHITECTURE.md Section 9.2.
  /// Spare parts are 0% commission (100% passed through to provider).
  static FeeBreakdownResult computeFees({
    required MonetizationPlanType plan,
    required int labourRupees,
    int sparePartsRupees = 0,
    PaymentMode paymentMode = PaymentMode.dummyOnline,
  }) {
    final gross = labourRupees + sparePartsRupees;
    final rawCommission = ((labourRupees * plan.commissionBps) / 10000).round();
    final gstOnFee = ((rawCommission * 1800) / 10000).round(); // 18% GST on fee
    final leadFee = plan.perLeadFeeRupees;
    final totalPlatformTake = rawCommission + gstOnFee + leadFee;
    final providerNet = (gross - totalPlatformTake).clamp(0, gross);

    final lines = <JournalEntryLine>[];
    if (paymentMode == PaymentMode.dummyOnline) {
      // Flow A: Online Gateway Split (ARCHITECTURE.md §9.4)
      lines.add(
        JournalEntryLine(
          accountCode: 'gateway_clearing',
          accountLabel: const Tr(
            'Gateway Clearing (Razorpay/Cashfree)',
            'गेटवे क्लियरिंग (Razorpay/Cashfree)',
          ),
          debitRupees: gross,
          creditRupees: 0,
        ),
      );
      lines.add(
        JournalEntryLine(
          accountCode: 'provider_payable',
          accountLabel: const Tr(
            'Provider Payable (Split Settlement)',
            'पार्टनर देय राशि (स्प्लिट सेटलमेंट)',
          ),
          debitRupees: 0,
          creditRupees: providerNet,
        ),
      );
      if (rawCommission > 0) {
        lines.add(
          JournalEntryLine(
            accountCode: 'platform_revenue_commission',
            accountLabel: const Tr(
              'Platform Commission Revenue',
              'प्लेटफॉर्म कमीशन आय',
            ),
            debitRupees: 0,
            creditRupees: rawCommission,
          ),
        );
      }
      if (leadFee > 0) {
        lines.add(
          JournalEntryLine(
            accountCode: 'platform_revenue_leads',
            accountLabel: const Tr(
              'Platform Lead Fee Revenue',
              'प्लेटफॉर्म लीड शुल्क आय',
            ),
            debitRupees: 0,
            creditRupees: leadFee,
          ),
        );
      }
      if (gstOnFee > 0) {
        lines.add(
          JournalEntryLine(
            accountCode: 'gst_output_payable',
            accountLabel: const Tr(
              'GST Output Payable (18% on Fee)',
              'GST देय (शुल्क पर 18%)',
            ),
            debitRupees: 0,
            creditRupees: gstOnFee,
          ),
        );
      }
    } else {
      // Flow B: Cash Job Accruing Dues (ARCHITECTURE.md §9.5)
      if (totalPlatformTake > 0) {
        lines.add(
          JournalEntryLine(
            accountCode: 'provider_dues_receivable',
            accountLabel: const Tr(
              'Provider Cash Dues Receivable',
              'पार्टनर नकद बकाया प्राप्य',
            ),
            debitRupees: totalPlatformTake,
            creditRupees: 0,
          ),
        );
        if (rawCommission > 0) {
          lines.add(
            JournalEntryLine(
              accountCode: 'platform_revenue_commission',
              accountLabel: const Tr(
                'Platform Commission Revenue',
                'प्लेटफॉर्म कमीशन आय',
              ),
              debitRupees: 0,
              creditRupees: rawCommission,
            ),
          );
        }
        if (leadFee > 0) {
          lines.add(
            JournalEntryLine(
              accountCode: 'platform_revenue_leads',
              accountLabel: const Tr(
                'Platform Lead Fee Revenue',
                'प्लेटफॉर्म लीड शुल्क आय',
              ),
              debitRupees: 0,
              creditRupees: leadFee,
            ),
          );
        }
        if (gstOnFee > 0) {
          lines.add(
            JournalEntryLine(
              accountCode: 'gst_output_payable',
              accountLabel: const Tr(
                'GST Output Payable (18% on Fee)',
                'GST देय (शुल्क पर 18%)',
              ),
              debitRupees: 0,
              creditRupees: gstOnFee,
            ),
          );
        }
      } else {
        // Zero commission cash job (Subscription active)
        lines.add(
          JournalEntryLine(
            accountCode: 'partner_cash_retained',
            accountLabel: const Tr(
              'Partner Direct Cash Retained (0% Fee)',
              'पार्टनर प्रत्यक्ष नकद (0% शुल्क)',
            ),
            debitRupees: gross,
            creditRupees: gross,
          ),
        );
      }
    }

    return FeeBreakdownResult(
      plan: plan,
      labourRupees: labourRupees,
      sparePartsRupees: sparePartsRupees,
      grossTotalRupees: gross,
      platformCommissionRupees: rawCommission,
      gstOnFeeRupees: gstOnFee,
      leadFeeRupees: leadFee,
      totalPlatformTakeRupees: totalPlatformTake,
      providerNetPayoutRupees: providerNet,
      journalLines: lines,
    );
  }
}

// =============================================================================
// 4. SHARED REACTIVE PITCH DEMO STORE
// =============================================================================

class PitchDemoStore extends ChangeNotifier {
  PitchDemoStore._();
  static final PitchDemoStore instance = PitchDemoStore._();

  MonetizationPlanType _activePlan = MonetizationPlanType.commission;
  DemandSurgeMode _demandMode = DemandSurgeMode.normal;
  int _selectedAddressIndex = 0;
  String? _selectedCouponCode = 'QUICK20';
  int _leadCreditsBalance = 280; // ₹280 prepaid credits (8 leads)
  bool _subscriptionActive = true;

  static const List<CouponPromoItem> availableCoupons = [
    CouponPromoItem(
      code: 'QUICK20',
      title: Tr('Flat ₹20 Instant Discount', 'फ्लैट ₹20 की तुरंत छूट'),
      subtitle: Tr(
        'Valid on all Express & Scheduled bookings',
        'सभी एक्सप्रेस और शेड्यूल बुकिंग पर मान्य',
      ),
      discountRupees: 20,
      minOrderRupees: 40,
    ),
    CouponPromoItem(
      code: 'FIRST50',
      title: Tr('Flat ₹50 Welcome Offer', 'फ्लैट ₹50 वेलकम ऑफर'),
      subtitle: Tr(
        'Special first-order discount on orders above ₹79',
        '₹79 से ऊपर के ऑर्डर पर विशेष छूट',
      ),
      discountRupees: 50,
      minOrderRupees: 79,
    ),
    CouponPromoItem(
      code: 'SAVER100',
      title: Tr('₹100 Off Appliance & Super Packs', 'उपकरण और सुपर पैक पर ₹100 छूट'),
      subtitle: Tr(
        'Applicable on AC servicing & multi-visit packs above ₹199',
        '₹199 से ऊपर की AC सर्विस और पैक पर लागू',
      ),
      discountRupees: 100,
      minOrderRupees: 199,
    ),
  ];

  static const List<SparePartTariffItem> standardSpareParts = [
    SparePartTariffItem(
      id: 'sp_brass_spindle',
      name: Tr('ISI Brass Tap Spindle / Washer', 'ISI ब्रास नल स्पिंडल / वॉशर'),
      warranty: Tr('30-day warranty', '30-दिन वारंटी'),
      priceRupees: 49,
    ),
    SparePartTariffItem(
      id: 'sp_switch_16a',
      name: Tr('Anchor / Havells 16A Switch & Socket', '16A स्विच और सॉकेट रिप्लेसमेंट'),
      warranty: Tr('Fixed spare rate', 'फिक्स स्पेयर रेट'),
      priceRupees: 89,
    ),
    SparePartTariffItem(
      id: 'sp_pvc_pipe',
      name: Tr('Heavy-Duty PVC Drain / Flush Pipe', 'हेवी-ड्यूटी PVC ड्रेन / फ्लश पाइप'),
      warranty: Tr('Zero extra labor', 'कोई अतिरिक्त लेबर नहीं'),
      priceRupees: 119,
    ),
    SparePartTariffItem(
      id: 'sp_ac_capacitor',
      name: Tr('ISI 45mfd AC Start Capacitor', 'ISI 45mfd AC स्टार्ट कैपेसिटर'),
      warranty: Tr('90-day replacement warranty', '90-दिन रिप्लेसमेंट वारंटी'),
      priceRupees: 249,
    ),
  ];

  final List<SavedAddressItem> _addresses = [
    const SavedAddressItem(
      id: 'addr_home',
      label: Tr('Home • Malviya Nagar', 'घर • मालवीय नगर'),
      addressLine: Tr(
        'B-42, Sector 4, Malviya Nagar, Jaipur',
        'बी-42, सेक्टर 4, मालवीय नगर, जयपुर',
      ),
      zoneTag: 'ZONE-JPR-01 • PostGIS Verified',
      prosNearby: 42,
      etaMinutes: 14,
    ),
    const SavedAddressItem(
      id: 'addr_office',
      label: Tr('Office • C-Scheme', 'ऑफिस • सी-स्कीम'),
      addressLine: Tr(
        '3rd Floor, Ahinsa Circle, C-Scheme, Jaipur',
        'तीसरी मंजिल, अहिंसा सर्कल, सी-स्कीम, जयपुर',
      ),
      zoneTag: 'ZONE-JPR-02 • PostGIS Verified',
      prosNearby: 38,
      etaMinutes: 12,
    ),
    const SavedAddressItem(
      id: 'addr_parents',
      label: Tr('Parents • Vaishali Nagar', 'माता-पिता • वैशाली नगर'),
      addressLine: Tr(
        'Plot 19, Amrapali Marg, Vaishali Nagar, Jaipur',
        'प्लॉट 19, आम्रपाली मार्ग, वैशाली नगर, जयपुर',
      ),
      zoneTag: 'ZONE-JPR-04 • PostGIS Verified',
      prosNearby: 29,
      etaMinutes: 15,
    ),
  ];

  MonetizationPlanType get activePlan => _activePlan;
  DemandSurgeMode get demandMode => _demandMode;
  List<SavedAddressItem> get addresses => List.unmodifiable(_addresses);
  int get selectedAddressIndex => _selectedAddressIndex;
  SavedAddressItem get currentAddress => _addresses[_selectedAddressIndex];
  String? get selectedCouponCode => _selectedCouponCode;
  int get leadCreditsBalance => _leadCreditsBalance;
  bool get subscriptionActive => _subscriptionActive;

  CouponPromoItem? get activeCoupon {
    if (_selectedCouponCode == null) return null;
    for (final c in availableCoupons) {
      if (c.code == _selectedCouponCode) return c;
    }
    return null;
  }

  void setPlan(MonetizationPlanType plan) {
    if (_activePlan != plan) {
      _activePlan = plan;
      notifyListeners();
    }
  }

  void setDemandMode(DemandSurgeMode mode) {
    if (_demandMode != mode) {
      _demandMode = mode;
      notifyListeners();
    }
  }

  void selectAddress(int index) {
    if (index >= 0 && index < _addresses.length) {
      _selectedAddressIndex = index;
      notifyListeners();
    }
  }

  void addCustomAddress(String labelEn, String lineEn) {
    _addresses.add(
      SavedAddressItem(
        id: 'addr_${_addresses.length + 1}',
        label: Tr(labelEn, labelEn),
        addressLine: Tr(lineEn, lineEn),
        zoneTag: 'ZONE-JPR-NEW • PostGIS Verified',
        prosNearby: 34,
        etaMinutes: 14,
      ),
    );
    _selectedAddressIndex = _addresses.length - 1;
    notifyListeners();
  }

  void selectCoupon(String? code) {
    _selectedCouponCode = code;
    notifyListeners();
  }

  void topUpLeadCredits(int amountRupees) {
    _leadCreditsBalance += amountRupees;
    notifyListeners();
  }

  void toggleSubscriptionActive(bool value) {
    _subscriptionActive = value;
    notifyListeners();
  }

  void resetDemo() {
    _activePlan = MonetizationPlanType.commission;
    _demandMode = DemandSurgeMode.normal;
    _selectedAddressIndex = 0;
    _selectedCouponCode = 'QUICK20';
    _leadCreditsBalance = 280;
    _subscriptionActive = true;
    notifyListeners();
  }
}

// =============================================================================
// 5. PITCH CONTROL ROOM PILL & BOTTOM SHEET (FOR LIVE CLIENT PITCHES)
// =============================================================================

class PitchControlPill extends StatelessWidget {
  final VoidCallback? onDemoReset;
  const PitchControlPill({super.key, this.onDemoReset});

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return ListenableBuilder(
      listenable: PitchDemoStore.instance,
      builder: (context, _) {
        final plan = PitchDemoStore.instance.activePlan;
        return PressableScale(
          key: const ValueKey('open-pitch-control-room'),
          onTap: () => showPitchControlSheet(context, onDemoReset: onDemoReset),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: c.lilac,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: c.purpleAccent.withValues(alpha: 0.28),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 13,
                  color: c.purpleAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  context.trPair(
                    'Pitch • ${plan.badge.en}',
                    'पिच • ${plan.badge.hi}',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: c.purpleAccent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void showPitchControlSheet(BuildContext context, {VoidCallback? onDemoReset}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PitchControlRoomSheet(onDemoReset: onDemoReset),
  );
}

class _PitchControlRoomSheet extends StatelessWidget {
  final VoidCallback? onDemoReset;
  const _PitchControlRoomSheet({this.onDemoReset});

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final store = PitchDemoStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final sampleBreakdown = DummyFeeEngine.computeFees(
          plan: store.activePlan,
          labourRupees: 200,
          sparePartsRupees: 49,
          paymentMode: PaymentMode.dummyOnline,
        );

        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.86,
            ),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.base,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: c.border, width: 1.5),
              boxShadow: c.e3,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                LayeredShapeCard(
                  backgroundColor: c.ink,
                  primaryShapeColor: c.ink,
                  secondaryShapeColor: c.accentStart,
                  borderRadius: 0,
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: c.accentStart,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              context.trPair(
                                'LIVE CLIENT PITCH CONTROL ROOM',
                                'लाइव क्लाइंट पिच कंट्रोल रूम',
                              ),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        context.trPair(
                          'Configuration-as-Data & Fee Engine Simulator',
                          'कॉन्फ़िगरेशन और शुल्क इंजन सिम्युलेटर',
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.trPair(
                          'Pivot monetization plans, surge rules, and inspect live double-entry accounting without changing code.',
                          'बिना कोड बदले बिजनेस मॉडल, सर्ज नियम और डबल-एंट्री लेजर बदलें।',
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // 1. Monetization Plan Switcher
                      Text(
                        context.trPair(
                          '1. Active Monetization Plan (ARCHITECTURE.md §9.1)',
                          '1. सक्रिय मुद्रीकरण प्लान (ARCHITECTURE.md §9.1)',
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...MonetizationPlanType.values.map((plan) {
                        final selected = store.activePlan == plan;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PressableScale(
                            onTap: () => store.setPlan(plan),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selected ? c.peachTint : c.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected ? c.accentStart : c.border,
                                  width: selected ? 1.8 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    color: selected ? c.accentStart : c.inkMuted,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                context.tr(plan.title),
                                                style: TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w800,
                                                  color: c.ink,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: c.lilac,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                context.tr(plan.badge),
                                                style: TextStyle(
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.w900,
                                                  color: c.purpleAccent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          context.tr(plan.subtitle),
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: c.inkSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),

                      // 2. Demand & Surge Mode
                      Text(
                        context.trPair(
                          '2. Dynamic Demand / Slot Pricing Mode',
                          '2. डायनामिक डिमांड / स्लॉट प्राइसिंग मोड',
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...DemandSurgeMode.values.map((mode) {
                        final selected = store.demandMode == mode;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PressableScale(
                            onTap: () => store.setDemandMode(mode),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selected ? c.pistachio : c.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected ? c.highlight : c.border,
                                  width: selected ? 1.8 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: selected ? c.highlight : c.inkMuted,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr(mode.title),
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                            color: c.ink,
                                          ),
                                        ),
                                        Text(
                                          context.tr(mode.subtitle),
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: c.inkSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),

                      // 3. Live Double-Entry Fee Breakdown Preview
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: c.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_rounded,
                                  size: 16,
                                  color: c.highlight,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    context.trPair(
                                      'Live Fee Engine Preview (₹200 Labour + ₹49 Part)',
                                      'लाइव शुल्क इंजन प्रीव्यू (₹200 लेबर + ₹49 स्पेयर पार्ट)',
                                    ),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: c.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...sampleBreakdown.journalLines.map((line) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        context.tr(line.accountLabel),
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: c.inkSecondary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      line.debitRupees > 0
                                          ? 'DR ${BrandConfig.currency}${line.debitRupees}'
                                          : 'CR ${BrandConfig.currency}${line.creditRupees}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: line.debitRupees > 0
                                            ? c.accentStart
                                            : c.highlight,
                                        fontFamily: QFonts.display,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            Divider(height: 18, color: c.border),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.trPair(
                                    'Partner Net Settlement',
                                    'पार्टनर शुद्ध भुगतान',
                                  ),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: c.ink,
                                  ),
                                ),
                                Text(
                                  '${BrandConfig.currency}${sampleBreakdown.providerNetPayoutRupees} / ${BrandConfig.currency}${sampleBreakdown.grossTotalRupees}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: c.highlight,
                                    fontFamily: QFonts.display,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer Reset Action
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  decoration: BoxDecoration(
                    color: c.surface,
                    border: Border(top: BorderSide(color: c.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            store.resetDemo();
                            onDemoReset?.call();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: c.highlight,
                                content: Text(
                                  context.trPair(
                                    'Pitch demo state reset to clean initial defaults!',
                                    'पिच डेमो स्टेट शुरुआती डिफ़ॉल्ट पर रीसेट हो गया!',
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.restart_alt_rounded,
                            size: 18,
                            color: c.accentStart,
                          ),
                          label: Text(
                            context.trPair(
                              'Reset Pitch Demo',
                              'डेमो रीसेट करें',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            context.trPair('Apply & Close', 'लागू करें'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 6. ADDRESS BOOK & POSTGIS SERVICEABILITY SHEET
// =============================================================================

void showAddressBookSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddressBookSheet(),
  );
}

class _AddressBookSheet extends StatefulWidget {
  const _AddressBookSheet();

  @override
  State<_AddressBookSheet> createState() => _AddressBookSheetState();
}

class _AddressBookSheetState extends State<_AddressBookSheet> {
  final TextEditingController _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final store = PitchDemoStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: c.border),
                boxShadow: c.e3,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: c.peachTint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: c.accentStart,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.trPair(
                                'Select Service Location',
                                'सेवा का स्थान चुनें',
                              ),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: c.ink,
                              ),
                            ),
                            Text(
                              context.trPair(
                                'PostGIS MultiPolygon serviceability & Redis GEO index',
                                'PostGIS सर्विस एरिया और लाइव प्रो उपलब्धता',
                              ),
                              style: TextStyle(
                                fontSize: 11.5,
                                color: c.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close_rounded, color: c.ink),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(store.addresses.length, (i) {
                    final addr = store.addresses[i];
                    final selected = store.selectedAddressIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PressableScale(
                        onTap: () {
                          store.selectAddress(i);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected ? c.peachTint : c.base,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected ? c.accentStart : c.border,
                              width: selected ? 1.8 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: selected ? c.accentStart : c.inkMuted,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr(addr.label),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: c.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      context.tr(addr.addressLine),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: c.inkSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: c.pistachio,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            '✓ ${addr.prosNearby} Pros • ${addr.etaMinutes}m ETA',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: c.highlight,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: c.lilac,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            addr.zoneTag,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              color: c.purpleAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customController,
                          decoration: InputDecoration(
                            hintText: context.trPair(
                              'Add new address / locality (e.g., Mansarovar)...',
                              'नया पता या इलाका जोड़ें (जैसे मानसरोवर)...',
                            ),
                            hintStyle: TextStyle(
                              fontSize: 12.5,
                              color: c.inkMuted,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: c.base,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: c.border),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final text = _customController.text.trim();
                          if (text.isEmpty) return;
                          store.addCustomAddress('Custom Pin • $text', text);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        child: Text(context.trPair('Add', 'जोड़ें')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// 7. VOICE SEARCH SIMULATOR SHEET
// =============================================================================

void showVoiceSearchSheet(
  BuildContext context, {
  required ValueChanged<String> onQuerySelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _VoiceSearchSheet(onQuerySelected: onQuerySelected),
  );
}

class _VoiceSearchSheet extends StatelessWidget {
  final ValueChanged<String> onQuerySelected;
  const _VoiceSearchSheet({required this.onQuerySelected});

  static const List<({String query, Tr label})> _presets = [
    (
      query: 'Rajmistri',
      label: Tr('"Mason / Rajmistri (Brick & Plaster)"', '"राजमिस्त्री (चुनाई और प्लास्टर)"'),
    ),
    (
      query: 'Tile',
      label: Tr('"Tile & Marble Fitting Mistri"', '"टाइल और मार्बल मिस्त्री"'),
    ),
    (
      query: 'Carpenter',
      label: Tr('"Carpenter / Badhai (Door & Furniture)"', '"बढ़ई / कारपेंटर (दरवाजा व फर्नीचर)"'),
    ),
    (
      query: 'Welder',
      label: Tr('"Welder & Iron Gate Repair"', '"वेल्डर और लोहे का गेट रिपेयर"'),
    ),
    (
      query: 'Beldar',
      label: Tr('"Beldar / Construction Helper"', '"बेलदार / निर्माण और शिफ्टिंग मज़दूर"'),
    ),
    (
      query: 'Painter',
      label: Tr('"House Painter & Wall Putty"', '"पेंटर और वॉल पुट्टी"'),
    ),
    (
      query: 'Plumber',
      label: Tr('"Plumber & tap leak repair"', '"प्लम्बर और नल रिपेयर"'),
    ),
    (
      query: 'House help',
      label: Tr('"House help in 14 mins"', '"14 मिनट में हाउस हेल्प"'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.border),
          boxShadow: c.e3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: c.lilac,
                shape: BoxShape.circle,
                border: Border.all(color: c.purpleAccent, width: 2),
              ),
              child: Icon(
                Icons.mic_rounded,
                size: 32,
                color: c.purpleAccent,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.trPair(
                'Listening in English & हिंदी...',
                'अंग्रेज़ी और हिंदी में सुन रहा है...',
              ),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: c.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.trPair(
                'Tap any spoken phrase below to simulate instant voice recognition:',
                'तुरंत वॉइस सर्च टेस्ट करने के लिए नीचे किसी भी वाक्य पर टैप करें:',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: c.inkMuted,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _presets.map((p) {
                return PressableScale(
                  onTap: () {
                    Navigator.of(context).pop();
                    onQuerySelected(p.query);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: c.peachTint,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: c.accentStart.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.graphic_eq_rounded,
                          size: 15,
                          color: c.accentStart,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.tr(p.label),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: c.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 8. MULTI-COUPON SELECTOR SHEET
// =============================================================================

void showCouponPickerSheet(
  BuildContext context, {
  required String? currentCode,
  required int subtotalRupees,
  required ValueChanged<CouponPromoItem?> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _CouponPickerSheet(
      currentCode: currentCode,
      subtotalRupees: subtotalRupees,
      onSelected: onSelected,
    ),
  );
}

class _CouponPickerSheet extends StatelessWidget {
  final String? currentCode;
  final int subtotalRupees;
  final ValueChanged<CouponPromoItem?> onSelected;

  const _CouponPickerSheet({
    required this.currentCode,
    required this.subtotalRupees,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.border),
          boxShadow: c.e3,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.local_offer_rounded, color: c.highlight, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.trPair(
                        'Available Coupons & Offers',
                        'उपलब्ध कूपन और ऑफर्स',
                      ),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: c.ink,
                      ),
                    ),
                  ),
                  if (currentCode != null)
                    TextButton(
                      onPressed: () {
                        onSelected(null);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        context.trPair('Remove', 'हटाएं'),
                        style: TextStyle(color: c.danger),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ...PitchDemoStore.availableCoupons.map((coupon) {
                final selected = currentCode == coupon.code;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PressableScale(
                    onTap: () {
                      onSelected(coupon);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: selected ? c.pistachio : c.base,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? c.highlight : c.border,
                          width: selected ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: c.ink,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              coupon.code,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr(coupon.title),
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: c.ink,
                                  ),
                                ),
                                Text(
                                  context.tr(coupon.subtitle),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: c.inkSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: selected ? c.highlight : c.inkMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 9. IN-APP CHAT & MASKED TELEPHONY SHEET (CUSTOMER <-> PROVIDER)
// =============================================================================

void showInAppChatSheet(
  BuildContext context, {
  required Tr partnerName,
  required String bookingId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _InAppChatSheet(
      partnerName: partnerName,
      bookingId: bookingId,
    ),
  );
}

class _InAppChatSheet extends StatefulWidget {
  final Tr partnerName;
  final String bookingId;

  const _InAppChatSheet({
    required this.partnerName,
    required this.bookingId,
  });

  @override
  State<_InAppChatSheet> createState() => _InAppChatSheetState();
}

class _InAppChatSheetState extends State<_InAppChatSheet> {
  final TextEditingController _msgController = TextEditingController();
  final List<({bool fromCustomer, Tr text, String time})> _messages = [
    (
      fromCustomer: false,
      text: const Tr(
        'Namaste! I have accepted your booking and started on my scooter.',
        'नमस्ते! मैंने आपकी बुकिंग स्वीकार कर ली है और स्कूटर से निकल चुका हूँ।',
      ),
      time: 'Just now',
    ),
    (
      fromCustomer: true,
      text: const Tr(
        'Great! Entry gate pass is approved on MyGate.',
        'बढ़िया! MyGate पर एंट्री पास अप्रूव कर दिया है।',
      ),
      time: 'Just now',
    ),
  ];

  static const List<Tr> _quickReplies = [
    Tr('Please bring spare washer', 'कृपया स्पेयर वॉशर साथ लाएं'),
    Tr('Call me at society gate', 'सोसाइटी गेट पर पहुंचकर कॉल करें'),
    Tr('Share live location', 'लाइव लोकेशन शेयर करें'),
  ];

  void _send(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _messages.add((
        fromCustomer: true,
        text: Tr(trimmed, trimmed),
        time: 'Now',
      ));
      _msgController.clear();
    });
    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      setState(() {
        _messages.add((
          fromCustomer: false,
          text: const Tr(
            'Noted! Reaching your doorstep in a few minutes with full toolkit.',
            'जी बिल्कुल! पूरे टूलकिट के साथ कुछ ही मिनटों में पहुंच रहा हूँ।',
          ),
          time: 'Now',
        ));
      });
    });
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.78,
          ),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: c.base,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: c.border),
            boxShadow: c.e3,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                color: c.ink,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: c.lilac,
                      child: Icon(
                        Icons.engineering_rounded,
                        size: 20,
                        color: c.purpleAccent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.tr(widget.partnerName)} • #${widget.bookingId}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            context.trPair(
                              'End-to-End Number Masked • Online',
                              'नंबर गोपनीय और सुरक्षित • ऑनलाइन',
                            ),
                            style: TextStyle(
                              fontSize: 11,
                              color: c.pistachio,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(14),
                  itemCount: _messages.length,
                  itemBuilder: (context, idx) {
                    final m = _messages[idx];
                    return Align(
                      alignment: m.fromCustomer
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 270),
                        decoration: BoxDecoration(
                          color: m.fromCustomer ? c.peachTint : c.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: m.fromCustomer ? c.accentStart : c.border,
                          ),
                        ),
                        child: Text(
                          context.tr(m.text),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: c.ink,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: _quickReplies.map((qr) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        backgroundColor: c.lilac,
                        label: Text(
                          context.tr(qr),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: c.purpleAccent,
                          ),
                        ),
                        onPressed: () => _send(context.tr(qr)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                color: c.surface,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        onSubmitted: _send,
                        decoration: InputDecoration(
                          hintText: context.trPair(
                            'Type message to professional...',
                            'प्रोफेशनल को संदेश लिखें...',
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: c.base,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide(color: c.border),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: c.accentStart,
                      ),
                      onPressed: () => _send(_msgController.text),
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 10. POST-JOB 5-STAR RATING & PARTNER TIP SHEET
// =============================================================================

void showPostJobRatingSheet(
  BuildContext context, {
  required BookingOrder order,
  required void Function(int stars, int tipRupees) onSubmitted,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PostJobRatingSheet(
      order: order,
      onSubmitted: onSubmitted,
    ),
  );
}

class _PostJobRatingSheet extends StatefulWidget {
  final BookingOrder order;
  final void Function(int stars, int tipRupees) onSubmitted;

  const _PostJobRatingSheet({
    required this.order,
    required this.onSubmitted,
  });

  @override
  State<_PostJobRatingSheet> createState() => _PostJobRatingSheetState();
}

class _PostJobRatingSheetState extends State<_PostJobRatingSheet> {
  int _stars = 5;
  int _tipRupees = 20;
  final Set<int> _selectedTags = {0, 1};

  static const List<Tr> _compliments = [
    Tr('14-Min Punctual', 'समय का पाबंद'),
    Tr('Sparkling Clean Work', 'शानदार और साफ काम'),
    Tr('Polite & Professional', 'विनम्र व्यवहार'),
    Tr('Fixed Tariff Followed', 'फिक्स रेट कार्ड का पालन'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.border),
          boxShadow: c.e3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: c.pistachio,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                context.trPair(
                  'ESCROW VERIFIED • JOB COMPLETED',
                  'एस्क्रो सत्यापित • काम पूरा हुआ',
                ),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  color: c.highlight,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              context.trPair(
                'Rate ${widget.order.providerName.en}',
                '${widget.order.providerName.hi} को रेटिंग दें',
              ),
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: c.ink,
              ),
            ),
            const SizedBox(height: 10),
            QStarRating(
              rating: _stars,
              onChanged: (val) => setState(() => _stars = val),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(_compliments.length, (i) {
                final active = _selectedTags.contains(i);
                return FilterChip(
                  selected: active,
                  selectedColor: c.lilac,
                  backgroundColor: c.base,
                  label: Text(
                    context.tr(_compliments[i]),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: active ? c.purpleAccent : c.inkSecondary,
                    ),
                  ),
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selectedTags.add(i);
                      } else {
                        _selectedTags.remove(i);
                      }
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              context.trPair(
                'Add 100% Direct Partner Tip (0% Platform Fee)',
                'पार्टनर के लिए टिप जोड़ें (100% सीधे पार्टनर को)',
              ),
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: c.inkSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [0, 20, 50, 100].map((amt) {
                final selected = _tipRupees == amt;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    selected: selected,
                    selectedColor: c.peachTint,
                    backgroundColor: c.base,
                    label: Text(
                      amt == 0
                          ? context.trPair('No Tip', 'कोई टिप नहीं')
                          : '+${BrandConfig.currency}$amt',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: selected ? c.accentStart : c.ink,
                      ),
                    ),
                    onSelected: (_) => setState(() => _tipRupees = amt),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: AccentGradientButton(
                label: context.trPair(
                  'Submit $_stars★ Review & Close',
                  '$_stars★ रिव्यू सबमिट करें',
                ),
                icon: Icons.verified_rounded,
                onPressed: () {
                  widget.onSubmitted(_stars, _tipRupees);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 11. PARTNER KYC & ANDROID OEM BATTERY READINESS SHEET (ARCHITECTURE.md §13.4)
// =============================================================================

void showKycAndOemHealthSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _KycAndOemHealthSheet(),
  );
}

class _KycAndOemHealthSheet extends StatelessWidget {
  const _KycAndOemHealthSheet();

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final items = [
      (
        icon: Icons.badge_rounded,
        title: const Tr('PAN & DigiLocker Identity', 'PAN और डिजीलॉकर पहचान'),
        status: const Tr('Verified • Ref #DIGI-9921', 'सत्यापित • #DIGI-9921'),
        isPurple: false,
      ),
      (
        icon: Icons.account_balance_rounded,
        title: const Tr('Bank Account Penny-Drop', 'बैंक खाता पेनी-ड्रॉप'),
        status: const Tr('HDFC Bank •••• 4821 Active', 'HDFC बैंक •••• 4821 सक्रिय'),
        isPurple: false,
      ),
      (
        icon: Icons.local_police_rounded,
        title: const Tr('Police Verification Shield', 'पुलिस वेरिफिकेशन शील्ड'),
        status: const Tr('Cleared • Valid till Nov 2027', 'सत्यापित • नवंबर 2027 तक वैध'),
        isPurple: false,
      ),
      (
        icon: Icons.battery_charging_full_rounded,
        title: const Tr('OEM Auto-Start & Battery Lock', 'OEM ऑटो-स्टार्ट और बैटरी लॉक'),
        status: const Tr('Unrestricted (Zero Missed Jobs)', 'अनरिस्ट्रिक्टेड (कोई काम मिस नहीं)'),
        isPurple: true,
      ),
      (
        icon: Icons.notifications_active_rounded,
        title: const Tr('High-Priority FCM Siren Channel', 'हाई-प्रायोरिटी FCM सायरन चैनल'),
        status: const Tr('Max Importance • 4.2s Avg Ack', 'अधिकतम प्राथमिकता • 4.2s औसत'),
        isPurple: true,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.border),
          boxShadow: c.e3,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: c.pistachio,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.verified_user_rounded,
                    color: c.highlight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.trPair(
                          'Partner KYC & Android OEM Diagnostics',
                          'पार्टनर KYC और फोन स्वास्थ्य जांच',
                        ),
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w900,
                          color: c.ink,
                        ),
                      ),
                      Text(
                        context.trPair(
                          '100% dispatch eligible • ARCHITECTURE.md §12 & §13.4',
                          '100% डिस्पैच पात्र • सभी जांच सफल',
                        ),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: c.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, color: c.ink),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: c.base,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.isPurple ? c.lilac : c.pistachio,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: item.isPurple ? c.purpleAccent : c.highlight,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(item.title),
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: c.ink,
                            ),
                          ),
                          Text(
                            context.tr(item.status),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: item.isPurple
                                  ? c.purpleAccent
                                  : c.highlight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: item.isPurple ? c.purpleAccent : c.highlight,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ),
  );
}
}

// =============================================================================
// 12. DOUBLE-ENTRY JOURNAL INSPECTOR MODAL (ARCHITECTURE.md §9.3)
// =============================================================================

void showDoubleEntryJournalSheet(
  BuildContext context, {
  required LedgerJournalItem item,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _DoubleEntryJournalSheet(item: item),
  );
}

class _DoubleEntryJournalSheet extends StatelessWidget {
  final LedgerJournalItem item;
  const _DoubleEntryJournalSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final breakdown = DummyFeeEngine.computeFees(
      plan: PitchDemoStore.instance.activePlan,
      labourRupees: item.amountRupees,
      paymentMode: item.isCredit ? PaymentMode.dummyOnline : PaymentMode.cash,
    );

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.border),
          boxShadow: c.e3,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: c.lilac,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'IMMUTABLE JOURNAL • #${item.id.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: c.purpleAccent,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded, color: c.ink),
                ),
              ],
            ),
            Text(
              context.tr(item.title),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: c.ink,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${context.tr(item.subtitle)} • ${item.timestampLabel}',
              style: TextStyle(
                fontSize: 12,
                color: c.inkMuted,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.base,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.trPair('LEDGER ACCOUNT', 'लेजर खाता'),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: c.inkMuted,
                        ),
                      ),
                      Text(
                        context.trPair('DEBIT / CREDIT', 'डेबिट / क्रेडिट'),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          color: c.inkMuted,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 16, color: c.border),
                  ...breakdown.journalLines.map((line) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${line.accountCode}\n${context.tr(line.accountLabel)}',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: c.ink,
                                height: 1.25,
                              ),
                            ),
                          ),
                          Text(
                            line.debitRupees > 0
                                ? 'DR ${BrandConfig.currency}${line.debitRupees}'
                                : 'CR ${BrandConfig.currency}${line.creditRupees}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              color: line.debitRupees > 0
                                  ? c.accentStart
                                  : c.highlight,
                              fontFamily: QFonts.display,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Divider(height: 16, color: c.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.trPair(
                          'Invariant Check: Sum(DR) == Sum(CR)',
                          'संतुलन जांच: कुल डेबिट == कुल क्रेडिट',
                        ),
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: c.highlight,
                        ),
                      ),
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: c.highlight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

// =============================================================================
// 13. CUSTOMER WALLET, SUPER-SAVER PASS, REFERRAL & 24×7 HELP CENTER SHEET
// =============================================================================

void showCustomerWalletAndPassSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CustomerWalletAndPassSheet(),
  );
}

class _CustomerWalletAndPassSheet extends StatefulWidget {
  const _CustomerWalletAndPassSheet();

  @override
  State<_CustomerWalletAndPassSheet> createState() =>
      _CustomerWalletAndPassSheetState();
}

class _CustomerWalletAndPassSheetState
    extends State<_CustomerWalletAndPassSheet> {
  int _walletCashRupees = 250;
  final int _remainingPassVisits = 2;
  bool _referralClaimed = false;

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.border),
          boxShadow: c.e3,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: c.peachTint,
                    child: Icon(
                      Icons.person_rounded,
                      color: c.accentStart,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trPair(
                            'Ananya Singhania • Gold Member',
                            'अनन्या सिंघानिया • गोल्ड सदस्य',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: c.ink,
                          ),
                        ),
                        Text(
                          context.trPair(
                            '+91 98290-XXXXX • Verified Customer',
                            '+91 98290-XXXXX • सत्यापित ग्राहक',
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: c.inkMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 1. QSeva Cash & Escrow Refund Wallet Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: c.pistachio,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.highlight.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: c.highlight,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.trPair(
                              'QSeva Wallet Balance',
                              'क्विकसेवा वॉलेट बैलेंस',
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: c.inkSecondary,
                            ),
                          ),
                          Text(
                            '${BrandConfig.currency}$_walletCashRupees',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: c.highlight,
                              fontFamily: QFonts.display,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        setState(() => _walletCashRupees += 100);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: c.highlight,
                            content: Text(
                              context.trPair(
                                'Added ₹100 Demo Promo Cash to your QSeva Wallet!',
                                'आपके वॉलेट में ₹100 डेमो कैश जोड़ा गया!',
                              ),
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: c.surface,
                        foregroundColor: c.highlight,
                      ),
                      child: Text(
                        context.trPair('+ Add ₹100', '+ ₹100 जोड़ें'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. Active Super Saver Pack (3-Visits Pass @ ₹33/visit)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: c.lilac,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: c.purpleAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: c.purpleAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            context.trPair('ACTIVE PASS', 'सक्रिय पास'),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.trPair(
                              'Super Saver 3-Visits Pack (₹33/visit)',
                              'सुपर सेवर 3-विज़िट पैक (₹33/विज़िट)',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: c.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.trPair(
                        '$_remainingPassVisits of 3 prepaid visits remaining • Valid for 26 more days',
                        '3 में से $_remainingPassVisits प्रीपेड विज़िट शेष • 26 दिनों के लिए मान्य',
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: c.purpleAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(3, (i) {
                        final used = i < (3 - _remainingPassVisits);
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: used ? c.purpleAccent : c.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: c.purpleAccent),
                            ),
                            child: Text(
                              used
                                  ? context.trPair('Visit #${i + 1} ✓', 'विज़िट #${i + 1} ✓')
                                  : context.trPair('Visit #${i + 1} Ready', 'विज़िट #${i + 1} उपलब्ध'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: used ? Colors.white : c.purpleAccent,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 3. Refer & Earn ₹100 Neighbour Reward
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: c.peachTint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: c.accentStart.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      color: c.accentStart,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.trPair(
                              'Refer a Neighbour • Get ₹100',
                              'पड़ोसी को रेफर करें • ₹100 पाएं',
                            ),
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: c.ink,
                            ),
                          ),
                          Text(
                            context.trPair(
                              'Code: ANANYA100 • Instant wallet credit on first booking',
                              'कोड: ANANYA100 • पहली बुकिंग पर ₹100 वॉलेट क्रेडिट',
                            ),
                            style: TextStyle(
                              fontSize: 11.5,
                              color: c.inkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _referralClaimed
                          ? null
                          : () {
                              setState(() {
                                _referralClaimed = true;
                                _walletCashRupees += 100;
                              });
                            },
                      child: Text(
                        _referralClaimed
                            ? context.trPair('Claimed ✓', 'मिल गया ✓')
                            : context.trPair('Simulate +₹100', '+₹100 पाएं'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: c.accentStart,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 4. 24×7 Customer Escrow & Dispute Support
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: c.base,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.support_agent_rounded,
                      color: c.ink,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.trPair(
                              '24×7 Escrow & Safety Helpdesk',
                              '24×7 एस्क्रो और सुरक्षा हेल्पडेस्क',
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: c.ink,
                            ),
                          ),
                          Text(
                            context.trPair(
                              'Instant refund if partner is >10 mins late or quality issue',
                              'पार्टनर के लेट होने या शिकायत पर तुरंत रिफंड',
                            ),
                            style: TextStyle(
                              fontSize: 11.5,
                              color: c.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
