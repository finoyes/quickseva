import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'live_tracking_screen.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  final ServiceItem service;
  final ServicePackageTier selectedPackage;
  final bool isInstant;
  final String scheduleLabel;
  final int surchargeRupees;
  final ValueChanged<BookingOrder> onBookingCreated;

  const CheckoutPaymentScreen({
    super.key,
    required this.service,
    required this.selectedPackage,
    required this.isInstant,
    required this.scheduleLabel,
    required this.surchargeRupees,
    required this.onBookingCreated,
  });

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  PaymentMode _paymentMode = PaymentMode.cash;
  bool _applyCoupon = true;
  bool _isProcessingDummyPg = false;

  int get _convenienceFee => 19;
  int get _couponDiscount => _applyCoupon ? 20 : 0;
  int get _grandTotal {
    final raw = widget.selectedPackage.priceRupees +
        widget.surchargeRupees +
        _convenienceFee -
        _couponDiscount;
    return raw < 29 ? widget.selectedPackage.priceRupees : raw;
  }

  Future<void> _confirmBooking() async {
    if (_paymentMode == PaymentMode.dummyOnline) {
      setState(() => _isProcessingDummyPg = true);
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() => _isProcessingDummyPg = false);
    }

    final order = BookingOrder(
      id: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      service: widget.service,
      selectedPackage: widget.selectedPackage,
      isInstant: widget.isInstant,
      scheduleLabel: widget.scheduleLabel,
      totalAmountRupees: _grandTotal,
      paymentMode: _paymentMode,
      status: BookingStatus.assigned,
    );

    widget.onBookingCreated(order);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      SmoothPageRoute(
        page: LiveTrackingScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pkg = widget.selectedPackage;
    final savedOnMrp =
        (pkg.originalPriceRupees - pkg.priceRupees) + _couponDiscount;

    return Scaffold(
      backgroundColor: QColors.warmIvoryBg,
      appBar: AppBar(
        title: Text(
          context.trPair('Review & Checkout', 'समीक्षा और भुगतान'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LanguageTogglePill(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  // Stitch Escrow Protection Header Banner (Layered Solid Shapes)
                  LayeredShapeCard(
                    margin: const EdgeInsets.only(bottom: 14),
                    backgroundColor: QColors.deepSlate,
                    primaryShapeColor: QColors.deepSlateSurface,
                    secondaryShapeColor: QColors.primaryGreen,
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: QColors.primaryGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.trPair(
                                  'ESCROW SHIELD • ZERO UPFRONT RISK',
                                  'एस्क्रो शील्ड • 100% सुरक्षित बुकिंग',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context.trPair(
                                  'Payout is released only after job completion & OTP check.',
                                  'काम पूरा होने और OTP सत्यापन के बाद ही भुगतान होता है।',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Savings Celebration Strip
                  if (savedOnMrp > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: QColors.softGreenTint,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: QColors.softGreenBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.celebration_rounded,
                            size: 18,
                            color: QColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.trPair(
                                'You are saving ${BrandConfig.currency}$savedOnMrp on this booking!',
                                'आप इस बुकिंग पर ${BrandConfig.currency}$savedOnMrp बचा रहे हैं!',
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: QColors.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Service & Slot Summary Card
                  LayeredShapeCard(
                    backgroundColor: QColors.cleanWhite,
                    primaryShapeColor: QColors.softGreenTint,
                    secondaryShapeColor: QColors.primaryGreen,
                    borderRadius: 16,
                    padding: const EdgeInsets.all(16),
                    border: Border.all(color: QColors.borderSubtle),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.service.imageUrl,
                                width: 58,
                                height: 58,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  width: 58,
                                  height: 58,
                                  color: QColors.warmIvorySurface,
                                  child: const Icon(
                                    Icons.cleaning_services_rounded,
                                    color: QColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr(widget.service.name),
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: QColors.inkDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.tr(pkg.title),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: QColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${BrandConfig.currency}${pkg.priceRupees}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: QColors.inkDark,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Icon(
                              widget.isInstant
                                  ? Icons.bolt_rounded
                                  : Icons.schedule_rounded,
                              size: 18,
                              color: QColors.primaryGreen,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.scheduleLabel,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: QColors.inkBody,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: QColors.inkMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${context.tr(BrandConfig.defaultAddressLabel)} • ${context.tr(BrandConfig.defaultAddressLine)}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: QColors.inkMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Coupon Toggle Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: QColors.cleanWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QColors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: QColors.softGreenTint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.discount_rounded,
                            size: 18,
                            color: QColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.trPair(
                                  'Code QUICK20 Applied',
                                  'कूपन QUICK20 लागू है',
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: QColors.inkDark,
                                ),
                              ),
                              Text(
                                context.trPair(
                                  'Extra ₹20 instant platform discount',
                                  '₹20 की अतिरिक्त छूट',
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: QColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _applyCoupon,
                          activeTrackColor: QColors.primaryGreen,
                          onChanged: (v) => setState(() => _applyCoupon = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Mode Selector (Cash vs Dummy PG)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: QColors.cleanWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trPair(
                            'Payment Method (Cash or Demo PG)',
                            'भुगतान का तरीका चुनें (नकद या डेमो PG)',
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: QColors.inkDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _PaymentOptionTile(
                          mode: PaymentMode.cash,
                          selected: _paymentMode == PaymentMode.cash,
                          icon: Icons.payments_outlined,
                          subtitle: const Tr(
                            'Pay directly to the professional after job completion',
                            'काम पूरा होने के बाद प्रोफेशनल को नकद या UPI दें',
                          ),
                          onTap: () =>
                              setState(() => _paymentMode = PaymentMode.cash),
                        ),
                        const SizedBox(height: 10),
                        _PaymentOptionTile(
                          mode: PaymentMode.dummyOnline,
                          selected: _paymentMode == PaymentMode.dummyOnline,
                          icon: Icons.qr_code_scanner_rounded,
                          subtitle: const Tr(
                            'Simulates instant gateway split settlement (No real charge)',
                            'तुरंत ऑनलाइन डेमो पेमेंट सिम्युलेटर (कोई वास्तविक शुल्क नहीं)',
                          ),
                          onTap: () => setState(
                            () => _paymentMode = PaymentMode.dummyOnline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Itemized Bill Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: QColors.cleanWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trPair('Bill Details', 'बिल विवरण'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: QColors.inkDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _BillRow(
                          label: context.trPair('Item Total', 'पैकेज शुल्क'),
                          value: '${BrandConfig.currency}${pkg.priceRupees}',
                        ),
                        if (widget.surchargeRupees > 0)
                          _BillRow(
                            label: context.trPair(
                              'Peak Slot Surcharge',
                              'पीक स्लॉट शुल्क',
                            ),
                            value:
                                '+ ${BrandConfig.currency}${widget.surchargeRupees}',
                          ),
                        _BillRow(
                          label: context.trPair(
                            'Safety & Platform Fee',
                            'सुरक्षा और प्लेटफॉर्म शुल्क',
                          ),
                          value: '${BrandConfig.currency}$_convenienceFee',
                        ),
                        if (_applyCoupon)
                          _BillRow(
                            label: context.trPair(
                              'Coupon Discount (QUICK20)',
                              'कूपन छूट (QUICK20)',
                            ),
                            value: '- ${BrandConfig.currency}$_couponDiscount',
                            isGreen: true,
                          ),
                        const Divider(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.trPair('Total Payable', 'कुल देय राशि'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: QColors.inkDark,
                              ),
                            ),
                            RollingRupeeText(
                              amountRupees: _grandTotal,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: QColors.primaryGreen,
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

            // Sticky Bottom Confirm Button with Elastic Bounce on Coupon / Payment Change
            ElasticBounceWrapper(
              triggerKey: '$_grandTotal-$_paymentMode',
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
                decoration: BoxDecoration(
                  color: QColors.cleanWhite,
                  border: const Border(
                    top: BorderSide(color: QColors.borderSubtle),
                  ),
                  boxShadow: QTheme.softShadow,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isProcessingDummyPg ? null : _confirmBooking,
                    child: _isProcessingDummyPg
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  context.trPair(
                                    'Simulating Dummy PG Approval...',
                                    'डेमो पेमेंट सत्यापित हो रहा है...',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            _paymentMode == PaymentMode.cash
                                ? context.trPair(
                                    'Confirm Booking • Pay ${BrandConfig.currency}$_grandTotal by Cash',
                                    'बुकिंग पक्की करें • ${BrandConfig.currency}$_grandTotal नकद दें',
                                  )
                                : context.trPair(
                                    'Pay ${BrandConfig.currency}$_grandTotal via Dummy PG & Book',
                                    'डेमो PG से ${BrandConfig.currency}$_grandTotal भुगतान करें',
                                  ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final PaymentMode mode;
  final bool selected;
  final IconData icon;
  final Tr subtitle;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.mode,
    required this.selected,
    required this.icon,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? QColors.softGreenTint : QColors.warmIvoryBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? QColors.primaryGreen : QColors.borderSubtle,
            width: selected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? QColors.primaryGreen : QColors.inkBody,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(mode.label),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: QColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.tr(subtitle),
                    style: const TextStyle(
                      fontSize: 12,
                      color: QColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? QColors.primaryGreen : QColors.inkLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isGreen;

  const _BillRow({
    required this.label,
    required this.value,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                color: QColors.inkMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isGreen ? QColors.primaryGreen : QColors.inkDark,
            ),
          ),
        ],
      ),
    );
  }
}
