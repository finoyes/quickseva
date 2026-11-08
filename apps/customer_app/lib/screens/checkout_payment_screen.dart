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
      await Future.delayed(Duration(milliseconds: 900));
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
      backgroundColor: QSevaColors.of(context).base,
      appBar: AppBar(
        title: Text(
          context.trPair('Review & Checkout', 'समीक्षा और भुगतान'),
          style: TextStyle(
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
                padding: EdgeInsets.all(18),
                children: [
                  // Stitch Escrow Protection Header Banner (Layered Solid Shapes)
                  LayeredShapeCard(
                    margin: EdgeInsets.only(bottom: 14),
                    backgroundColor: QSevaColors.of(context).ink,
                    primaryShapeColor: QSevaColors.of(context).ink,
                    secondaryShapeColor: QSevaColors.of(context).accentStart,
                    borderRadius: 16,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: QSevaColors.of(context).accentStart,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.shield_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
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
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(height: 2),
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
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: QSevaColors.of(context).pistachio,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: QSevaColors.of(context).border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.celebration_rounded,
                            size: 18,
                            color: QSevaColors.of(context).accentStart,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.trPair(
                                'You are saving ${BrandConfig.currency}$savedOnMrp on this booking!',
                                'आप इस बुकिंग पर ${BrandConfig.currency}$savedOnMrp बचा रहे हैं!',
                              ),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: QSevaColors.of(context).accentStart,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Service & Slot Summary Card
                  LayeredShapeCard(
                    backgroundColor: QSevaColors.of(context).surface,
                    primaryShapeColor: QSevaColors.of(context).pistachio,
                    secondaryShapeColor: QSevaColors.of(context).accentStart,
                    borderRadius: 16,
                    padding: EdgeInsets.all(16),
                    border: Border.all(color: QSevaColors.of(context).border),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            QNetworkImage(
                              url: widget.service.imageUrl,
                              width: 58,
                              height: 58,
                              borderRadius: BorderRadius.circular(10),
                              fallbackIcon: Icons.cleaning_services_rounded,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr(widget.service.name),
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: QSevaColors.of(context).ink,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    context.tr(pkg.title),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: QSevaColors.of(context).accentStart,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${BrandConfig.currency}${pkg.priceRupees}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: QSevaColors.of(context).ink,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 24),
                        Row(
                          children: [
                            Icon(
                              widget.isInstant
                                  ? Icons.bolt_rounded
                                  : Icons.schedule_rounded,
                              size: 18,
                              color: QSevaColors.of(context).accentStart,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.scheduleLabel,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: QSevaColors.of(context).inkSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: QSevaColors.of(context).inkMuted,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${context.tr(BrandConfig.defaultAddressLabel)} • ${context.tr(BrandConfig.defaultAddressLine)}',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: QSevaColors.of(context).inkMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Coupon Toggle Card
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: QSevaColors.of(context).surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QSevaColors.of(context).border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: QSevaColors.of(context).pistachio,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.discount_rounded,
                            size: 18,
                            color: QSevaColors.of(context).highlight,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.trPair(
                                  'Code QUICK20 Applied',
                                  'कूपन QUICK20 लागू है',
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: QSevaColors.of(context).ink,
                                ),
                              ),
                              Text(
                                context.trPair(
                                  'Extra ₹20 instant platform discount',
                                  '₹20 की अतिरिक्त छूट',
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: QSevaColors.of(context).inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _applyCoupon,
                          activeTrackColor: QSevaColors.of(context).accentStart,
                          onChanged: (v) => setState(() => _applyCoupon = v),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Payment Mode Selector (Cash vs Dummy PG)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: QSevaColors.of(context).surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QSevaColors.of(context).border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trPair(
                            'Payment Method (Cash or Demo PG)',
                            'भुगतान का तरीका चुनें (नकद या डेमो PG)',
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: QSevaColors.of(context).ink,
                          ),
                        ),
                        SizedBox(height: 12),
                        _PaymentOptionTile(
                          mode: PaymentMode.cash,
                          selected: _paymentMode == PaymentMode.cash,
                          icon: Icons.payments_outlined,
                          subtitle: Tr(
                            'Pay directly to the professional after job completion',
                            'काम पूरा होने के बाद प्रोफेशनल को नकद या UPI दें',
                          ),
                          onTap: () =>
                              setState(() => _paymentMode = PaymentMode.cash),
                        ),
                        SizedBox(height: 10),
                        _PaymentOptionTile(
                          mode: PaymentMode.dummyOnline,
                          selected: _paymentMode == PaymentMode.dummyOnline,
                          icon: Icons.qr_code_scanner_rounded,
                          subtitle: Tr(
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
                  SizedBox(height: 16),

                  // Itemized Bill Summary
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: QSevaColors.of(context).surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QSevaColors.of(context).border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.trPair('Bill Details', 'बिल विवरण'),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: QSevaColors.of(context).ink,
                          ),
                        ),
                        SizedBox(height: 12),
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
                        Divider(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.trPair('Total Payable', 'कुल देय राशि'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: QSevaColors.of(context).ink,
                              ),
                            ),
                            RollingRupeeText(
                              amountRupees: _grandTotal,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: QSevaColors.of(context).accentStart,
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

            // Sticky Bottom Confirm Button with Glass Surface
            GlassSurface(
              borderRadius: 0,
              boxShadow: QSevaColors.of(context).e2,
              child: ElasticBounceWrapper(
              triggerKey: '$_grandTotal-$_paymentMode',
              child: Padding(
                padding: EdgeInsets.fromLTRB(18, 12, 18, 16),
                child: AccentGradientButton(
                  label: _paymentMode == PaymentMode.cash
                      ? context.trPair(
                          'Confirm • ${BrandConfig.currency}$_grandTotal Cash',
                          'बुकिंग • ${BrandConfig.currency}$_grandTotal नकद',
                        )
                      : context.trPair(
                          'Pay ${BrandConfig.currency}$_grandTotal & Book',
                          '${BrandConfig.currency}$_grandTotal भुगतान करें',
                        ),
                  icon: Icons.check_circle_rounded,
                  isLoading: _isProcessingDummyPg,
                  onPressed: _isProcessingDummyPg ? null : _confirmBooking,
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
        duration: Duration(milliseconds: 180),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? QSevaColors.of(context).peachTint : QSevaColors.of(context).base,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? QSevaColors.of(context).accentStart : QSevaColors.of(context).border,
            width: selected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? QSevaColors.of(context).accentStart : QSevaColors.of(context).inkSecondary,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(mode.label),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: QSevaColors.of(context).ink,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    context.tr(subtitle),
                    style: TextStyle(
                      fontSize: 12,
                      color: QSevaColors.of(context).inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? QSevaColors.of(context).accentStart : QSevaColors.of(context).inkMuted,
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
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                color: QSevaColors.of(context).inkMuted,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isGreen ? QSevaColors.of(context).highlight : QSevaColors.of(context).ink,
            ),
          ),
        ],
      ),
    );
  }
}
