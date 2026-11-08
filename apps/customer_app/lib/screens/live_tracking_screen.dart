import 'dart:math' as math;
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

  /// Evaluates a point on the quadratic Bezier route for normalized `t` in [0, 1].
  Offset _pointOnBezierRoute(Size mapSize, double t) {
    final p0 = Offset(42, mapSize.height * 0.62);
    final p1 = Offset(mapSize.width * 0.46, mapSize.height * 0.16);
    final p2 = Offset(mapSize.width - 46, mapSize.height - 44);

    final oneMinusT = 1.0 - t;
    final x = (oneMinusT * oneMinusT * p0.dx) +
        (2 * oneMinusT * t * p1.dx) +
        (t * t * p2.dx);
    final y = (oneMinusT * oneMinusT * p0.dy) +
        (2 * oneMinusT * t * p1.dy) +
        (t * t * p2.dy);
    return Offset(x, y);
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
            // 1. ANIMATED VECTOR ROUTE MAP + MOVING RIDER + RADAR RINGS
            // =================================================================
            Container(
              height: 224,
              decoration: BoxDecoration(
                color: QSevaColors.of(context).surfaceSunken,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: QSevaColors.of(context).border, width: 1.5),
                boxShadow: QSevaColors.of(context).e1,
              ),
              clipBehavior: Clip.antiAlias,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final mapSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.15,
                      end: targetProgress,
                    ),
                    duration: Duration(milliseconds: 560),
                    curve: Curves.easeOutBack,
                    builder: (context, animProgress, _) {
                      final clampedProgress = animProgress.clamp(0.0, 1.0);
                      final riderPos = _pointOnBezierRoute(
                        mapSize,
                        clampedProgress * 0.86,
                      );
                      final remainingKm =
                          ((1.0 - clampedProgress) * 1.8).clamp(0.0, 1.8);

                      return Stack(
                        children: [
                          // Custom-painted solid city blocks, route path & radar waves
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _SimulatedMapPainter(progress: clampedProgress, accentColor: QSevaColors.of(context).accentStart, inkColor: QSevaColors.of(context).ink),
                            ),
                          ),

                          // Top Live Telemetry Pill
                          Positioned(
                            top: 12,
                            left: 12,
                            right: 12,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: QSevaColors.of(context).ink,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        LiveStatusDot(
                                          color: QSevaColors.of(context).highlight,
                                          size: 7,
                                        ),
                                        SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            status == BookingStatus.completed
                                                ? context.trPair(
                                                    'JOB COMPLETED',
                                                    'कार्य पूर्ण',
                                                  )
                                                : context.trPair(
                                                    'LIVE GPS • ${remainingKm.toStringAsFixed(1)} KM',
                                                    'लाइव GPS • ${remainingKm.toStringAsFixed(1)} किमी',
                                                  ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: QSevaColors.of(context).surface,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: QSevaColors.of(context).border,
                                    ),
                                  ),
                                  child: Text(
                                    '${(clampedProgress * 100).round()}%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: QSevaColors.of(context).accentStart,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Customer Home Pin with Radar Rings painted underneath
                          Positioned(
                            right: 18,
                            bottom: 18,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: QSevaColors.of(context).ink,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    context.trPair('Your Home', 'आपका घर'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: QSevaColors.of(context).accentStart,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.home_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Moving Partner Scooter Pill gliding along the Bezier route
                          Positioned(
                            left: (riderPos.dx - 54).clamp(
                              10.0,
                              math.max(10.0, mapSize.width - 148),
                            ),
                            top: (riderPos.dy - 22).clamp(
                              44.0,
                              math.max(44.0, mapSize.height - 54),
                            ),
                            child: Transform.rotate(
                              angle: (0.45 - clampedProgress) * 0.14,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: QSevaColors.of(context).surface,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: QSevaColors.of(context).accentStart,
                                    width: 2,
                                  ),
                                  boxShadow: QSevaColors.of(context).e1,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: QSevaColors.of(context).pistachio,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.two_wheeler_rounded,
                                        size: 15,
                                        color: QSevaColors.of(context).accentStart,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 88,
                                      ),
                                      child: Text(
                                        context.tr(o.providerName),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: QSevaColors.of(context).ink,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
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
                  else
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
                    icon: Icon(Icons.call_rounded),
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

class _SimulatedMapPainter extends CustomPainter {
  final double progress;
  final Color accentColor;
  final Color inkColor;
  _SimulatedMapPainter({required this.progress, required this.accentColor, required this.inkColor});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Solid architectural city blocks (zero gradients)
    final blockPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(16, 42, size.width * 0.28, 46),
        Radius.circular(8),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.52, 28, size.width * 0.34, 52),
        Radius.circular(8),
      ),
      blockPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(28, size.height - 62, size.width * 0.36, 44),
        Radius.circular(8),
      ),
      blockPaint,
    );

    // 2. Street grid lines
    final gridPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.08)
      ..strokeWidth = 1.2;

    for (double x = 0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final startHub = Offset(42, size.height * 0.62);
    final controlPt = Offset(size.width * 0.46, size.height * 0.16);
    final homeDest = Offset(size.width - 46, size.height - 44);

    // 3. Concentric solid radar rings around destination ("Your Home")
    final radarCenter = homeDest;
    final pulsePhase = (progress * 3.0) % 1.0;
    final outerRadarRadius = 18.0 + (pulsePhase * 22.0);
    canvas.drawCircle(
      radarCenter,
      outerRadarRadius,
      Paint()
        ..color = accentColor.withValues(
          alpha: (0.22 * (1.0 - pulsePhase)).clamp(0.04, 0.22),
        )
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      radarCenter,
      26,
      Paint()
        ..color = accentColor.withValues(alpha: 0.26)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      radarCenter,
      15,
      Paint()
        ..color = accentColor.withValues(alpha: 0.16)
        ..style = PaintingStyle.fill,
    );

    // 4. Full route track (muted solid line)
    final fullRoutePath = Path()
      ..moveTo(startHub.dx, startHub.dy)
      ..quadraticBezierTo(
        controlPt.dx,
        controlPt.dy,
        homeDest.dx,
        homeDest.dy,
      );

    canvas.drawPath(
      fullRoutePath,
      Paint()
        ..color = accentColor.withValues(alpha: 0.22)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // 5. Animated active route segment traced up to `progress`
    for (final metric in fullRoutePath.computeMetrics()) {
      final activeSegment = metric.extractPath(
        0,
        metric.length * progress.clamp(0.0, 1.0),
      );
      canvas.drawPath(
        activeSegment,
        Paint()
          ..color = accentColor
          ..strokeWidth = 5.5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
    }

    // 6. Start Hub Node
    canvas.drawCircle(
      startHub,
      9,
      Paint()..color = inkColor.withValues(alpha: 0.2),
    );
    canvas.drawCircle(startHub, 5, Paint()..color = inkColor);
  }

  @override
  bool shouldRepaint(covariant _SimulatedMapPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
