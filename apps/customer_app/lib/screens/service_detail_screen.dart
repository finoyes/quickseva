import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'checkout_payment_screen.dart';
import 'schedule_slot_screen.dart';

/// Matches UC Screenshot #1 + Stitch Layered Visual Depth + Shared-Element Hero:
/// - "House help by QuickSeva, cleaning & more"
/// - Segmented toggle: "⚡ In 14 mins" (Green) vs "Later"
/// - Horizontal duration/package tier cards (45 mins ₹49, 1 hour ₹59, 1.5 hours ₹89 Bestseller)
/// - Super Saver Pack card ("3-visits pack at ₹225 -> ₹33/visit • SUPER SAVER PACK")
/// - "One help who can do it all" capabilities grid + dynamic SDUI form fields
class ServiceDetailScreen extends StatefulWidget {
  final ServiceItem service;
  final ValueChanged<BookingOrder> onBookingCreated;
  final String? heroTag;

  const ServiceDetailScreen({
    super.key,
    required this.service,
    required this.onBookingCreated,
    this.heroTag,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late bool _isInstant;
  late ServicePackageTier _selectedPackage;
  final Map<String, dynamic> _formValues = {};

  @override
  void initState() {
    super.initState();
    _isInstant = widget.service.supportsInstant;
    _selectedPackage = widget.service.packages.firstWhere(
      (p) => p.isBestseller,
      orElse: () => widget.service.packages.first,
    );
    for (final field in widget.service.formFields) {
      if (field.type == FormFieldType.select && field.options.isNotEmpty) {
        _formValues[field.key] = field.options.first.value;
      } else if (field.type == FormFieldType.stepper) {
        _formValues[field.key] = field.defaultValue;
      }
    }
  }

  void _proceedWithPackage(ServicePackageTier tier) {
    setState(() => _selectedPackage = tier);
    if (_isInstant) {
      Navigator.of(context).push(
        SmoothPageRoute(
          page: CheckoutPaymentScreen(
            service: widget.service,
            selectedPackage: tier,
            isInstant: true,
            scheduleLabel: context.trPair(
              'Instant • Arrives in ${widget.service.instantEtaMinutes} mins',
              'तुरंत • ${widget.service.instantEtaMinutes} मिनट में आगमन',
            ),
            surchargeRupees: 0,
            onBookingCreated: widget.onBookingCreated,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        SmoothPageRoute(
          page: ScheduleSlotScreen(
            service: widget.service,
            selectedPackage: tier,
            onBookingCreated: widget.onBookingCreated,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final brand = BrandConfig.name(context.lang);

    final thumbImage = QNetworkImage(
      url: s.imageUrl,
      width: 68,
      height: 68,
      radius: 14,
    );

    return Scaffold(
      backgroundColor: QSevaColors.of(context).surface,
      appBar: AppBar(
        backgroundColor: QSevaColors.of(context).surface,
        leadingWidth: 64,
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: QSevaColors.of(context).surface,
                  border: Border.all(color: QSevaColors.of(context).border),
                ),
                child: Icon(Icons.arrow_back_rounded, size: 20),
              ),
            ),
          ),
        ),
        title: Text(
          s.id == 'svc_house_help'
              ? context.trPair(
                  'House help by $brand',
                  '$brand द्वारा हाउस हेल्प',
                )
              : context.tr(s.name),
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: QSevaColors.of(context).ink,
            letterSpacing: -0.3,
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
                padding: EdgeInsets.fromLTRB(18, 10, 18, 28),
                children: [
                  // Headline Banner inside a Layered Shape Header Card + Shared-Element Hero Thumbnail
                  LayeredShapeCard(
                    backgroundColor: QSevaColors.of(context).base,
                    primaryShapeColor: QSevaColors.of(context).rose,
                    secondaryShapeColor: QSevaColors.of(context).accentStart,
                    borderRadius: 20,
                    padding: EdgeInsets.all(16),
                    border: Border.all(color: QSevaColors.of(context).border),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.id == 'svc_house_help'
                                    ? context.trPair(
                                        'House help by $brand,\ncleaning & more',
                                        '$brand हाउस हेल्प,\nसफाई और घर के काम',
                                      )
                                    : context.tr(s.name),
                                style: QText.displayM.copyWith(
                                  color: QSevaColors.of(context).ink,
                                  height: 1.18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: QSevaColors.of(context).pistachio,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          size: 15,
                                          color: QSevaColors.of(context).accentStart,
                                        ),
                                        SizedBox(width: 3),
                                        Text(
                                          '${s.rating} (${s.bookingsCountLabel})',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: QSevaColors.of(context).accentStart,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: QSevaColors.of(context).ink,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      context.trPair(
                                        'Escrow Verified',
                                        'एस्क्रो सुरक्षित',
                                      ),
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              Text(
                                context.tr(s.tagline),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: QSevaColors.of(context).inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        if (widget.heroTag != null)
                          Hero(tag: widget.heroTag!, child: thumbImage)
                        else
                          thumbImage,
                      ],
                    ),
                  ),
                  SizedBox(height: 18),

                  // Instant ("⚡ In 14 mins") vs "Later" Toggle (Matches UC Screenshot #1)
                  InstantLaterSegmentedControl(
                    isInstant: _isInstant,
                    instantMinutes: s.instantEtaMinutes,
                    onChanged: (val) => setState(() => _isInstant = val),
                  ),
                  SizedBox(height: 18),

                  // Horizontal Package / Duration Cards (Matches UC Screenshot #1)
                  SizedBox(
                    height: 186,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: s.packages.length,
                      separatorBuilder: (_, _) => SizedBox(width: 12),
                      itemBuilder: (context, idx) {
                        final pkg = s.packages[idx];
                        return PackageDurationCard(
                          tier: pkg,
                          isSelected: _selectedPackage.id == pkg.id,
                          onBookTap: () => _proceedWithPackage(pkg),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Super Saver Pack Banner (Matches UC Screenshot #1)
                  if (s.superSaverPack != null) ...[
                    SuperSaverPackBanner(
                      pack: s.superSaverPack!,
                      onBookTap: () {
                        final pack = s.superSaverPack!;
                        final packTier = ServicePackageTier(
                          id: pack.id,
                          title: Tr(
                            '3-Visits Super Saver Pack',
                            '3-विज़िट सुपर सेवर पैक',
                          ),
                          subtitle: pack.validityText,
                          priceRupees: pack.packPriceRupees,
                          originalPriceRupees: pack.originalPriceRupees,
                          durationMinutes: 60,
                        );
                        _proceedWithPackage(packTier);
                      },
                    ),
                    SizedBox(height: 20),
                  ],

                  // Interactive Before vs After Service Comparison Slider
                  BeforeAfterComparisonCard(serviceTitle: s.name),
                  SizedBox(height: 20),

                  // "One help who can do it all" Section (Matches UC Screenshot #1)
                  if (s.capabilities.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: QSevaColors.of(context).base,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: QSevaColors.of(context).border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.id == 'svc_house_help'
                                ? context.trPair(
                                    'One help who can do it all',
                                    'एक हेल्पर जो सभी काम निपटाए',
                                  )
                                : context.trPair(
                                    'What is included in this service',
                                    'इस सर्विस में क्या शामिल है',
                                  ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: QSevaColors.of(context).ink,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: s.capabilities.map((cap) {
                              return Container(
                                width:
                                    (MediaQuery.of(context).size.width - 86) /
                                        2,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: QSevaColors.of(context).surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: QSevaColors.of(context).border),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: QSevaColors.of(context).pistachio,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        size: 16,
                                        color: QSevaColors.of(context).accentStart,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        context.tr(cap),
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: QSevaColors.of(context).inkSecondary,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],

                  // Dynamic Server-Driven Service Form Schema (Section 10 of ARCHITECTURE.md)
                  if (s.formFields.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: QSevaColors.of(context).surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: QSevaColors.of(context).border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 18,
                                color: QSevaColors.of(context).accentStart,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  context.trPair(
                                    'Customize your service preferences',
                                    'अपनी सर्विस प्राथमिकताएं चुनें',
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    color: QSevaColors.of(context).ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14),
                          ...s.formFields.map((field) {
                            if (field.type == FormFieldType.select) {
                              final selectedVal = _formValues[field.key];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr(field.label),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: QSevaColors.of(context).inkMuted,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: field.options.map((opt) {
                                        final active =
                                            selectedVal == opt.value;
                                        return ChoiceChip(
                                          label: Text(context.tr(opt.label)),
                                          selected: active,
                                          selectedColor: QSevaColors.of(context).pistachio,
                                          backgroundColor:
                                              QSevaColors.of(context).base,
                                          labelStyle: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: active
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            color: active
                                                ? QSevaColors.of(context).accentStart
                                                : QSevaColors.of(context).inkSecondary,
                                          ),
                                          side: BorderSide(
                                            color: active
                                                ? QSevaColors.of(context).accentStart
                                                : QSevaColors.of(context).border,
                                          ),
                                          onSelected: (_) {
                                            setState(() {
                                              _formValues[field.key] =
                                                  opt.value;
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              final count =
                                  (_formValues[field.key] as int?) ??
                                      field.defaultValue;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      context.tr(field.label),
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: QSevaColors.of(context).inkSecondary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: QSevaColors.of(context).surfaceSunken,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: QSevaColors.of(context).border,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_rounded,
                                            size: 18,
                                          ),
                                          onPressed: count > field.min
                                              ? () => setState(() =>
                                                  _formValues[field.key] =
                                                      count - 1)
                                              : null,
                                        ),
                                        Text(
                                          '$count',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.add_rounded,
                                            size: 18,
                                          ),
                                          onPressed: count < field.max
                                              ? () => setState(() =>
                                                  _formValues[field.key] =
                                                      count + 1)
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Sticky Bottom Bar with Glass Surface + Elastic Bounce
            GlassSurface(
              borderRadius: 0,
              boxShadow: QSevaColors.of(context).e2,
              child: ElasticBounceWrapper(
              triggerKey: '${_selectedPackage.id}_$_isInstant',
              child: Padding(
                padding: EdgeInsets.fromLTRB(18, 12, 18, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.tr(_selectedPackage.title),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: QSevaColors.of(context).inkMuted,
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              RollingRupeeText(
                                amountRupees: _selectedPackage.priceRupees,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: QSevaColors.of(context).ink,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                '${BrandConfig.currency}${_selectedPackage.originalPriceRupees}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: QSevaColors.of(context).inkMuted,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: AccentGradientButton(
                        label: _isInstant
                            ? context.trPair(
                                'Book Instant (${s.instantEtaMinutes}m)',
                                'तुरंत बुक (${s.instantEtaMinutes}m)',
                              )
                            : context.trPair(
                                'Select Time Slot',
                                'समय स्लॉट चुनें',
                              ),
                        icon: _isInstant
                            ? Icons.bolt_rounded
                            : Icons.calendar_month_rounded,
                        onPressed: () =>
                            _proceedWithPackage(_selectedPackage),
                      ),
                    ),
                  ],
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
