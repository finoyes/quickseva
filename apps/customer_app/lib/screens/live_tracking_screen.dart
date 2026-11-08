import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class LiveTrackingScreen extends StatefulWidget {
  final BookingOrder order;

  const LiveTrackingScreen({super.key, required this.order});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final List<BookingStatus> _steps = const [
    BookingStatus.assigned,
    BookingStatus.enRoute,
    BookingStatus.arrived,
    BookingStatus.inProgress,
    BookingStatus.completed,
  ];

  int get _currentStepIndex =>
      _steps.indexOf(widget.order.status).clamp(0, _steps.length - 1);

  void _advanceStatus() {
    final nextIdx = _currentStepIndex + 1;
    if (nextIdx < _steps.length) {
      setState(() {
        widget.order.status = _steps[nextIdx];
      });
    }
  }

  Tr _statusTitle(BookingStatus s) {
    switch (s) {
      case BookingStatus.searching:
        return Tr(
          'Searching nearby partner...',
          'नज़दीकी पार्टनर खोज रहे हैं...',
        );
      case BookingStatus.assigned:
        return Tr(
          'Partner Assigned & Preparing',
          'पार्टनर असाइन हो गया है',
        );
      case BookingStatus.enRoute:
        return Tr(
          'Partner is on the way (6 mins away)',
          'पार्टनर रास्ते में है (6 मिनट दूर)',
        );
      case BookingStatus.arrived:
        return Tr(
          'Partner has arrived! Share Start OTP',
          'पार्टनर पहुंच गया है! स्टार्ट OTP बताएं',
        );
      case BookingStatus.inProgress:
        return Tr(
          'Service is in progress',
          'सर्विस चल रही है',
        );
      case BookingStatus.completed:
        return Tr(
          'Service Completed Successfully!',
          'सर्विस सफलतापूर्वक पूरी हुई!',
        );
    }
  }

  Tr _stepShortLabel(BookingStatus s) {
    switch (s) {
      case BookingStatus.assigned:
        return Tr('Assigned', 'असाइन');
      case BookingStatus.enRoute:
        return Tr('En Route', 'रास्ते में');
      case BookingStatus.arrived:
        return Tr('Arrived', 'पहुंच गए');
      case BookingStatus.inProgress:
        return Tr('Working', 'काम जारी');
      case BookingStatus.completed:
        return Tr('Done', 'पूरा हुआ');
      default:
        return Tr('Live', 'लाइव');
    }
  }

  IconData _stepNodeIcon(BookingStatus s) {
    switch (s) {
      case BookingStatus.assigned:
        return Icons.how_to_reg_rounded;
      case BookingStatus.enRoute:
        return Icons.two_wheeler_rounded;
      case BookingStatus.arrived:
        return Icons.pin_rounded;
      case BookingStatus.inProgress:
        return Icons.handyman_rounded;
      case BookingStatus.completed:
        return Icons.verified_rounded;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final status = o.status;
    final otpDigits = o.startOtp.split('');
    final targetProgress = (_currentStepIndex + 1) / _steps.length;

    return Scaffold(
      backgroundColor: QSevaColors.of(context).base,
      appBar: AppBar(
        title: Text(
          '${context.trPair('Booking', 'बुकिंग')} #${o.id}',
          style: TextStyle(
            fontSize: 16.5,
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
        child: ListView(
          padding: EdgeInsets.all(18),
          children: [
            // =================================================================
            // 1. INTERACTIVE OFFLINE VECTOR & TILE MAP (PAN, ZOOM, AUTO-DRIVE)
            // =================================================================
            QOfflineTrackingMap(
              routeProgress: targetProgress,
              partnerName: context.tr(o.providerName),
              destinationLabel: context.trPair('Your Home', 'आपका घर'),
              isCompleted: status == BookingStatus.completed,
              height: 252,
              onStepAdvanceRequested: _advanceStatus,
            ),
            SizedBox(height: 16),

            // =================================================================
            // 2. STATUS, KINETIC 4-DIGIT OTP BOXES & ANIMATED STEP TIMELINE
            // =================================================================
            LayeredShapeCard(
              backgroundColor: QSevaColors.of(context).surface,
              primaryShapeColor: QSevaColors.of(context).pistachio,
              secondaryShapeColor: QSevaColors.of(context).accentStart,
              borderRadius: 20,
              padding: EdgeInsets.all(18),
              border: Border.all(color: QSevaColors.of(context).border),
              boxShadow: QSevaColors.of(context).e1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 240),
                    child: Column(
                      key: ValueKey(status),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr(_statusTitle(status)),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: QSevaColors.of(context).ink,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          o.scheduleLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: QSevaColors.of(context).inkMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Kinetic 4-Digit Start OTP Box Strip
                  ElasticBounceWrapper(
                    triggerKey: status,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: status == BookingStatus.arrived
                            ? QSevaColors.of(context).peachTint
                            : QSevaColors.of(context).base,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: status == BookingStatus.arrived
                              ? QSevaColors.of(context).warning
                              : QSevaColors.of(context).border,
                          width: status == BookingStatus.arrived ? 1.6 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.trPair(
                                    'START OTP PIN',
                                    'स्टार्ट OTP पिन',
                                  ),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: QSevaColors.of(context).accentStart,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  context.trPair(
                                    'Share with professional at doorstep',
                                    'प्रोफेशनल के आने पर यह कोड बताएं',
                                  ),
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: QSevaColors.of(context).inkMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(otpDigits.length, (idx) {
                              final digit = otpDigits[idx];
                              final highlight = status == BookingStatus.arrived;
                              return TweenAnimationBuilder<double>(
                                key: ValueKey('otp_box_${idx}_$status'),
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: Duration(
                                  milliseconds: 240 + (idx * 75),
                                ),
                                curve: Curves.easeOutBack,
                                builder: (context, val, child) {
                                  return Transform.translate(
                                    offset: Offset(0, (1.0 - val) * -10),
                                    child: Transform.scale(
                                      scale: 0.82 + (0.18 * val),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 31,
                                  height: 38,
                                  margin: EdgeInsets.only(left: 4),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: highlight
                                        ? QSevaColors.of(context).highlight
                                        : QSevaColors.of(context).surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: QSevaColors.of(context).accentStart,
                                      width: 1.6,
                                    ),
                                  ),
                                  child: Text(
                                    digit,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w900,
                                      color: highlight
                                          ? Colors.white
                                          : QSevaColors.of(context).ink,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18),

                  // Animated 5-Step Progress Timeline Nodes + Flowing Bars
                  Row(
                    children: List.generate(_steps.length, (idx) {
                      final step = _steps[idx];
                      final done = idx <= _currentStepIndex;
                      final isCurrent = idx == _currentStepIndex;
                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 280),
                                    height: 3,
                                    color: idx == 0
                                        ? Colors.transparent
                                        : (done
                                            ? QSevaColors.of(context).accentStart
                                            : QSevaColors.of(context).surfaceSunken),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 280),
                                  curve: Curves.easeOutBack,
                                  width: isCurrent ? 30 : 24,
                                  height: isCurrent ? 30 : 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: done
                                        ? QSevaColors.of(context).accentStart
                                        : QSevaColors.of(context).surfaceSunken,
                                    border: Border.all(
                                      color: isCurrent
                                          ? QSevaColors.of(context).warning
                                          : (done
                                              ? QSevaColors.of(context).accentStart
                                              : QSevaColors.of(context).border),
                                      width: isCurrent ? 2.2 : 1.2,
                                    ),
                                  ),
                                  child: Icon(
                                    _stepNodeIcon(step),
                                    size: isCurrent ? 15 : 12,
                                    color: done ? Colors.white : QSevaColors.of(context).inkMuted,
                                  ),
                                ),
                                Expanded(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 280),
                                    height: 3,
                                    color: idx == _steps.length - 1
                                        ? Colors.transparent
                                        : (idx < _currentStepIndex
                                            ? QSevaColors.of(context).accentStart
                                            : QSevaColors.of(context).surfaceSunken),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  context.tr(_stepShortLabel(step)),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isCurrent
                                        ? FontWeight.w900
                                        : FontWeight.w600,
                                    color: done
                                        ? QSevaColors.of(context).ink
                                        : QSevaColors.of(context).inkMuted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16),

                  // Mid-Job Fixed-Tariff Spare Part / Material Approval Card
                  if (status == BookingStatus.inProgress) ...[
                    Container(
                      margin: EdgeInsets.only(bottom: 14),
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: QSevaColors.of(context).lilac,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: QSevaColors.of(context)
                              .purpleAccent
                              .withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.build_circle_rounded,
                                size: 18,
                                color: QSevaColors.of(context).purpleAccent,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  context.trPair(
                                    'Mid-Job Spare Part / Material Approval (0% Commission)',
                                    'स्पेयर पार्ट / सामग्री मंजूरी (0% कमीशन)',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w900,
                                    color: QSevaColors.of(context).ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            context.trPair(
                              'Tap to approve fixed-rate material if requested by partner (100% goes to partner):',
                              'यदि प्रोफेशनल को सामग्री चाहिए तो फिक्स-रेट मंजूर करें:',
                            ),
                            style: TextStyle(
                              fontSize: 11.5,
                              color: QSevaColors.of(context).inkSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: PitchDemoStore.standardSpareParts
                                .map((part) {
                              final selected =
                                  o.extraSparePartsRupees == part.priceRupees;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    o.extraSparePartsRupees = selected
                                        ? 0
                                        : part.priceRupees;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? QSevaColors.of(context).purpleAccent
                                        : QSevaColors.of(context).surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          QSevaColors.of(context).purpleAccent,
                                    ),
                                  ),
                                  child: Text(
                                    '${context.tr(part.name)} (+₹${part.priceRupees})',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: selected
                                          ? Colors.white
                                          : QSevaColors.of(context).ink,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Interactive Simulator Button to test state transitions
                  if (status != BookingStatus.completed)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _advanceStatus,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fast_forward_rounded, size: 18),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                context.trPair(
                                  'Demo: Advance to Next Live Status Step',
                                  'डेमो: अगले लाइव स्टेटस स्टेप पर जाएं',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    GeometricCelebrationBurst(
                      title: context.trPair(
                        'Job Completed & Escrow Verified!',
                        'काम पूरा और एस्क्रो सत्यापित!',
                      ),
                      subtitle: context.trPair(
                        'Thank you for choosing ${BrandConfig.brandName}. 7-day warranty active.',
                        '${BrandConfig.brandNameHindi} चुनने के लिए धन्यवाद। 7-दिन वारंटी सक्रिय।',
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showPostJobRatingSheet(
                            context,
                            order: o,
                            onSubmitted: (stars, tip) {
                              setState(() {
                                o.ratingStars = stars;
                                o.tipRupees = tip;
                              });
                            },
                          );
                        },
                        icon: Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: QSevaColors.of(context).accentStart,
                        ),
                        label: Text(
                          o.ratingStars != null
                              ? context.trPair(
                                  'Rated ${o.ratingStars}★ ${o.tipRupees > 0 ? "• +₹${o.tipRupees} Tip Added" : "• Edit Review"}',
                                  '${o.ratingStars}★ रेटिंग दी गई',
                                )
                              : context.trPair(
                                  'Rate Professional & Add 100% Partner Tip',
                                  'प्रोफेशनल को रेट करें और टिप जोड़ें',
                                ),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: QSevaColors.of(context).accentStart,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (status == BookingStatus.assigned) ...[
                    SizedBox(height: 12),
                    GeometricCelebrationBurst(
                      title: context.trPair(
                        'Booking Confirmed • Escrow Shield Active',
                        'बुकिंग कन्फर्म • एस्क्रो शील्ड सक्रिय',
                      ),
                      subtitle: context.trPair(
                        'Your verified professional is preparing to depart.',
                        'आपके वेरिफाइड प्रोफेशनल निकलने की तैयारी कर रहे हैं।',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),

            // Partner Details & Masked Call Card
            GlassSurface(
              borderRadius: 18,
              boxShadow: QSevaColors.of(context).e1,
              child: LayeredShapeCard(
              backgroundColor: QSevaColors.of(context).surface,
              primaryShapeColor: QSevaColors.of(context).lilac,
              secondaryShapeColor: QSevaColors.of(context).purpleAccent,
              padding: EdgeInsets.all(16),
              borderRadius: 18,
              border: Border.all(color: QSevaColors.of(context).border),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: QSevaColors.of(context).lilac,
                    child: Icon(
                      Icons.engineering_rounded,
                      color: QSevaColors.of(context).purpleAccent,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                context.tr(o.providerName),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800,
                                  color: QSevaColors.of(context).ink,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: QSevaColors.of(context).highlight,
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Text(
                          '${o.providerRating} • KYC & Police Verified',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: QSevaColors.of(context).inkMuted,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          o.providerPhoneMasked,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: QSevaColors.of(context).purpleAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: QSevaColors.of(context).peachTint,
                      foregroundColor: QSevaColors.of(context).accentStart,
                    ),
                    onPressed: () => showInAppChatSheet(
                      context,
                      partnerName: o.providerName,
                      bookingId: o.id,
                    ),
                    icon: Icon(Icons.chat_bubble_outline_rounded, size: 20),
                  ),
                  SizedBox(width: 6),
                  IconButton.filledTonal(
                    style: IconButton.styleFrom(
                      backgroundColor: QSevaColors.of(context).pistachio,
                      foregroundColor: QSevaColors.of(context).highlight,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.trPair(
                              'Connecting Masked Call via Exotel/Knowlarity bridge...',
                              'मास्क्ड कॉल कनेक्ट हो रही है (नंबर गोपनीय है)...',
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.call_rounded, size: 20),
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
