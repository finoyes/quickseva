import 'dart:async';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SimpleDutyScreen extends StatefulWidget {
  final bool isOnline;
  final ValueChanged<bool> onOnlineChanged;
  final int todayEarningsRupees;
  final int jobsCompletedToday;
  final int cashDuesRupees;
  final ValueChanged<ProviderJobOffer> onJobCompleted;
  final VoidCallback onSwitchToAnalyticsTab;

  const SimpleDutyScreen({
    super.key,
    required this.isOnline,
    required this.onOnlineChanged,
    required this.todayEarningsRupees,
    required this.jobsCompletedToday,
    required this.cashDuesRupees,
    required this.onJobCompleted,
    required this.onSwitchToAnalyticsTab,
  });

  @override
  State<SimpleDutyScreen> createState() => _SimpleDutyScreenState();
}

class _SimpleDutyScreenState extends State<SimpleDutyScreen> {
  static const int _dailyBonusTarget = 6;
  static const List<BookingStatus> _jobSteps = [
    BookingStatus.assigned,
    BookingStatus.enRoute,
    BookingStatus.arrived,
    BookingStatus.inProgress,
  ];

  ProviderJobOffer? _activeJob;
  BookingStatus _jobStep = BookingStatus.assigned;
  int _offerSampleIdx = 0;
  int? _lastCompletedPayoutRupees;

  void _triggerIncomingOfferModal() {
    final offer =
        CatalogData.sampleProviderOffers[_offerSampleIdx %
            CatalogData.sampleProviderOffers.length];
    _offerSampleIdx++;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _IncomingOfferModal(
        offer: offer,
        onAccept: () {
          Navigator.of(context).pop();
          setState(() {
            _activeJob = offer;
            _jobStep = BookingStatus.assigned;
          });
        },
      ),
    );
  }

  void _openOtpKeypadModal(ProviderJobOffer job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OtpKeypadModal(
        expectedOtp: job.startOtp,
        netPayoutRupees: job.netPayoutRupees,
        onVerified: () {
          Navigator.of(context).pop();
          if (_jobStep == BookingStatus.arrived) {
            _advanceActiveJobStep();
          }
        },
      ),
    );
  }

  void _advanceActiveJobStep() {
    final job = _activeJob;
    if (job == null) return;

    final idx = _jobSteps.indexOf(_jobStep);
    if (idx < _jobSteps.length - 1) {
      setState(() => _jobStep = _jobSteps[idx + 1]);
      return;
    }

    // Final step: job completed.
    widget.onJobCompleted(job);
    setState(() {
      _activeJob = null;
      _lastCompletedPayoutRupees = job.netPayoutRupees;
    });
    final c = QSevaColors.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: c.highlight,
        content: Text(
          context.trPair(
            'Job completed! +${BrandConfig.currency}${job.netPayoutRupees} added to your earnings.',
            'काम पूरा हुआ! +${BrandConfig.currency}${job.netPayoutRupees} आपकी कमाई में जुड़ गए।',
          ),
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget jobSection;
    if (_activeJob != null) {
      jobSection = _buildActiveJobCard(context, _activeJob!);
    } else if (widget.isOnline) {
      jobSection = _buildWaitingForJobCard(context);
    } else {
      jobSection = _buildOfflineCard(context);
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 14),
            _buildDutyToggleCard(context),
            const SizedBox(height: 14),
            _buildTodaySnapshotCard(context),
            const SizedBox(height: 14),
            jobSection,
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER: partner identity + Stitch Voice Guide + SOS + EN / हिं switcher
  // ===========================================================================
  Widget _buildHeader(BuildContext context) {
    final c = QSevaColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.peachTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.engineering_rounded,
                color: c.accentStart,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(BrandConfig.partnerAppTitle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: c.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    context.trPair(
                      'Rameshwar Sharma • ID #QS-409',
                      'रमेश्वर शर्मा • आईडी #QS-409',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: c.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const LanguageTogglePill(),
          ],
        ),
        const SizedBox(height: 10),
        // Stitch Quick Utility Strip: Voice Guide + Emergency SOS + Instant Bank Settlement Tag
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: c.lilac,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: c.purpleAccent.withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.volume_up_rounded,
                    size: 14,
                    color: c.purpleAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.trPair('Voice Guide ON', 'आवाज़ गाइड चालू'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: c.ink,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: c.rose.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: c.danger.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sos_rounded,
                    size: 14,
                    color: c.danger,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.trPair('24×7 SOS', 'आपातकालीन SOS'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: c.danger,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // 1. GIANT ONLINE / OFFLINE DUTY TOGGLE (Layered solid shapes, no gradient)
  // ===========================================================================
  Widget _buildDutyToggleCard(BuildContext context) {
    final c = QSevaColors.of(context);
    final online = widget.isOnline;

    return LayeredShapeCard(
      backgroundColor: online ? c.ink : c.surfaceSunken,
      primaryShapeColor: online ? c.accentStart.withValues(alpha: 0.35) : c.border,
      secondaryShapeColor: online ? c.highlight : c.inkMuted,
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      onTap: () => widget.onOnlineChanged(!online),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: online
                  ? c.highlight.withValues(alpha: 0.2)
                  : c.border.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: online ? c.highlight : c.border,
                width: 2,
              ),
            ),
            child: Icon(
              online ? Icons.sensors_rounded : Icons.power_settings_new_rounded,
              color: online ? c.highlight : c.inkMuted,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  online
                      ? context.trPair('YOU ARE ONLINE', 'आप ऑनलाइन हैं')
                      : context.trPair('YOU ARE OFFLINE', 'आप ऑफलाइन हैं'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: online ? Colors.white : c.ink,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  online
                      ? context.trPair(
                          'Receiving jobs within 5 km',
                          '5 किमी के भीतर नई बुकिंग मिल रही हैं',
                        )
                      : context.trPair(
                          'Tap to go online and receive jobs',
                          'नई बुकिंग पाने के लिए ऑनलाइन करें',
                        ),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: online ? Colors.white.withValues(alpha: 0.88) : c.inkMuted,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: online,
            activeTrackColor: c.highlight,
            activeThumbColor: Colors.white,
            inactiveTrackColor: c.border,
            inactiveThumbColor: c.inkMuted,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            onChanged: widget.onOnlineChanged,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. TODAY'S SNAPSHOT: 3 big numbers + daily bonus progress
  // ===========================================================================
  Widget _buildTodaySnapshotCard(BuildContext context) {
    final c = QSevaColors.of(context);
    final jobs = widget.jobsCompletedToday;
    final bonusProgress = (jobs / _dailyBonusTarget).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 6),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border),
        boxShadow: c.e1,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _BigMetricTile(
                  label: context.trPair("Today's pay", 'आज की कमाई'),
                  value: '${BrandConfig.currency}${widget.todayEarningsRupees}',
                  valueColor: c.highlight,
                ),
              ),
              const _MetricDivider(),
              Expanded(
                child: _BigMetricTile(
                  label: context.trPair('Jobs done', 'पूरे काम'),
                  value: '$jobs',
                  valueColor: c.ink,
                ),
              ),
              const _MetricDivider(),
              Expanded(
                child: _BigMetricTile(
                  label: context.trPair('Rating', 'रेटिंग'),
                  value: '4.9 ★',
                  valueColor: c.warning,
                ),
              ),
            ],
          ),
          Divider(height: 26, color: c.border),
          Row(
            children: [
              Icon(
                Icons.emoji_events_rounded,
                size: 18,
                color: c.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.trPair(
                    'Daily bonus: finish $_dailyBonusTarget jobs, get +${BrandConfig.currency}250',
                    'डेली बोनस: $_dailyBonusTarget काम पूरे करें, +${BrandConfig.currency}250 पाएं',
                  ),
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: c.ink,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$jobs/$_dailyBonusTarget',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: c.ink,
                  fontFamily: QFonts.display,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: bonusProgress,
              minHeight: 7,
              backgroundColor: c.surfaceSunken,
              color: c.highlight,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: widget.onSwitchToAnalyticsTab,
              iconAlignment: IconAlignment.end,
              icon: Icon(Icons.arrow_forward_rounded, size: 16, color: c.accentStart),
              label: Text(
                context.trPair('View detailed earnings', 'पूरा हिसाब देखें'),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: c.accentStart,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 3a. WAITING FOR JOBS (online, no active job) + LIVE SONAR RADAR GRAPHIC
  // ===========================================================================
  Widget _buildWaitingForJobCard(BuildContext context) {
    final c = QSevaColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_lastCompletedPayoutRupees != null) ...[
          GeometricCelebrationBurst(
            title: context.trPair(
              'Job Completed! +${BrandConfig.currency}$_lastCompletedPayoutRupees Earned',
              'काम पूरा हुआ! +${BrandConfig.currency}$_lastCompletedPayoutRupees की कमाई जुड़ी',
            ),
            subtitle: context.trPair(
              'Added to your partner wallet • Ready for next dispatch',
              'आपके पार्टनर वॉलेट में जुड़ गए • अगली बुकिंग के लिए तैयार',
            ),
          ),
          const SizedBox(height: 12),
        ],
        _StatusCard(
          key: const ValueKey('waiting-card'),
          icon: Icons.notifications_active_rounded,
          iconColor: c.highlight,
          iconBackground: c.pistachio,
          showSonarRadar: true,
          title: context.trPair(
            'Ready for new bookings',
            'नई बुकिंग के लिए तैयार',
          ),
          message: context.trPair(
            'Live sonar scanning 3.0 km radius • Test 25s job offer with one tap:',
            '3.0 किमी में लाइव सोनार स्कैन चालू • एक टैप में 25s जॉब ऑफर देखें:',
          ),
          action: _BigActionButton(
            key: const ValueKey('simulate-offer'),
            icon: Icons.ring_volume_rounded,
            label: context.trPair(
              'Simulate incoming job offer',
              'नई जॉब ऑफर सिम्युलेट करें',
            ),
            onPressed: _triggerIncomingOfferModal,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 3b. OFFLINE (no offers until the partner goes online)
  // ===========================================================================
  Widget _buildOfflineCard(BuildContext context) {
    final c = QSevaColors.of(context);
    return _StatusCard(
      key: const ValueKey('offline-card'),
      icon: Icons.power_settings_new_rounded,
      iconColor: c.inkMuted,
      iconBackground: c.surfaceSunken,
      title: context.trPair('You are offline', 'आप ऑफलाइन हैं'),
      message: context.trPair(
        'Go online to start receiving nearby jobs.',
        'नज़दीकी काम पाने के लिए ऑनलाइन जाएं।',
      ),
      action: _BigActionButton(
        icon: Icons.power_settings_new_rounded,
        label: context.trPair('Go online', 'ऑनलाइन जाएं'),
        onPressed: () => widget.onOnlineChanged(true),
      ),
    );
  }

  // ===========================================================================
  // 3c. ACTIVE JOB: Stitch Minimal Active Job + 4-Digit OTP Box Display
  // ===========================================================================
  Widget _buildActiveJobCard(BuildContext context, ProviderJobOffer job) {
    final c = QSevaColors.of(context);
    final stepIdx = _jobSteps.indexOf(_jobStep);
    final otpDigits = job.startOtp.split('');

    return Container(
      key: const ValueKey('active-job-card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.highlight, width: 2),
        boxShadow: c.e2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stitch Dark Slate Header Pill ("Go to Customer Home / ग्राहक के घर जाएं")
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: c.ink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(
                  '${context.trPair('ACTIVE JOB', 'चालू काम')} • #${job.bookingId}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${context.trPair('You earn', 'आपकी आय')} ${BrandConfig.currency}${job.netPayoutRupees}',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: c.accentEnd,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            context.tr(job.serviceName),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: c.ink,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.tr(job.packageName),
            style: TextStyle(
              fontSize: 13.5,
              color: c.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(height: 24, color: c.border),

          // Customer & address
          Row(
            children: [
              Icon(
                Icons.person_pin_circle_rounded,
                color: c.accentStart,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(job.customerName),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.tr(job.fullAddress),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: c.inkMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stitch Side-by-Side Quick Action Buttons: Google Maps + Call Customer
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: c.lilac,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: c.purpleAccent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_rounded,
                        size: 16,
                        color: c.purpleAccent,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          context.trPair('Google Maps', 'गूगल मैप्स'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: c.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: c.peachTint,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: c.accentStart.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call_rounded,
                        size: 16,
                        color: c.accentStart,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          context.trPair('Call Customer', 'ग्राहक को कॉल'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: c.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Step progress (Step x of 4)
          _StepProgress(current: stepIdx, total: _jobSteps.length),
          const SizedBox(height: 14),

          // Stitch 4-Digit OTP Box Display when arrived (Tap to open Interactive Keypad)
          if (_jobStep == BookingStatus.arrived) ...[
            PressableScale(
              key: const ValueKey('open-otp-keypad'),
              onTap: () => _openOtpKeypadModal(job),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: c.peachTint,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.accentStart),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.dialpad_rounded,
                      color: c.accentStart,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.trPair(
                          'Tap to enter Start OTP:',
                          'OTP कीपैड खोलने के लिए टैप करें:',
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: c.ink,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: otpDigits.map((digit) {
                        return Container(
                          width: 26,
                          height: 30,
                          margin: const EdgeInsets.only(left: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: c.accentStart,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            digit,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: c.ink,
                              fontFamily: QFonts.display,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Task checklist
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.surfaceSunken,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: job.taskChecklist.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 16,
                          color: c.highlight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.tr(item),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: c.ink,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Primary step action
          _BigActionButton(
            key: const ValueKey('job-step-action'),
            icon: _stepIcon(_jobStep),
            label: _stepButtonLabel(context, _jobStep, job),
            onPressed: _advanceActiveJobStep,
          ),
        ],
      ),
    );
  }

  IconData _stepIcon(BookingStatus step) {
    switch (step) {
      case BookingStatus.assigned:
        return Icons.navigation_rounded;
      case BookingStatus.enRoute:
        return Icons.where_to_vote_rounded;
      case BookingStatus.arrived:
        return Icons.pin_rounded;
      case BookingStatus.inProgress:
        return Icons.task_alt_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }

  String _stepButtonLabel(
    BuildContext context,
    BookingStatus step,
    ProviderJobOffer job,
  ) {
    switch (step) {
      case BookingStatus.assigned:
        return context.trPair(
          'Start trip & navigate (${job.distanceKm} km)',
          'यात्रा शुरू करें (${job.distanceKm} किमी)',
        );
      case BookingStatus.enRoute:
        return context.trPair('I have arrived', 'मैं पहुंच गया हूं');
      case BookingStatus.arrived:
        return context.trPair(
          'Verify OTP & start work',
          'OTP सत्यापित करें, काम शुरू करें',
        );
      case BookingStatus.inProgress:
        return job.paymentMode == PaymentMode.cash
            ? context.trPair(
                'Collect ${BrandConfig.currency}${job.grossAmountRupees} cash & complete',
                '${BrandConfig.currency}${job.grossAmountRupees} नकद लें, काम पूरा करें',
              )
            : context.trPair(
                'Complete job (paid online)',
                'काम पूरा करें (ऑनलाइन भुगतान)',
              );
      default:
        return context.trPair('Complete', 'पूरा करें');
    }
  }
}

// =============================================================================
// SMALL BUILDING BLOCKS
// =============================================================================

/// Full-width primary button that grows to two lines instead of overflowing.
class _BigActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _BigActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: c.ink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: c.accentEnd),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackground;
  final String title;
  final String message;
  final Widget action;
  final bool showSonarRadar;

  const _StatusCard({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBackground,
    required this.title,
    required this.message,
    required this.action,
    this.showSonarRadar = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final iColor = iconColor ?? c.highlight;
    final iBg = iconBackground ?? c.peachTint;

    return LayeredShapeCard(
      backgroundColor: c.surface,
      primaryShapeColor: iBg,
      secondaryShapeColor: iColor,
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      border: Border.all(color: c.border),
      boxShadow: c.e1,
      child: Column(
        children: [
          if (showSonarRadar)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: -2.2, end: -0.45),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutBack,
              builder: (context, angle, _) {
                return SonarRadarGraphic(
                  size: 94,
                  primaryColor: iColor,
                  accentColor: c.accentStart,
                  sweepAngleRadians: angle,
                  centerChild: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: iColor, width: 2),
                    ),
                    child: Icon(icon, size: 22, color: iColor),
                  ),
                );
              },
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: iColor),
            ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: c.inkMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          action,
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  final int current;
  final int total;

  const _StepProgress({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.trPair(
            'Step ${current + 1} of $total',
            'स्टेप ${current + 1} / $total',
          ),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: c.inkMuted,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(total, (i) {
            return Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
                decoration: BoxDecoration(
                  color: i <= current
                      ? c.highlight
                      : c.surfaceSunken,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return Container(
      width: 1,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: c.border,
    );
  }
}

class _BigMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _BigMetricTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: valueColor,
              letterSpacing: -0.4,
              fontFamily: QFonts.display,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: c.inkMuted,
          ),
        ),
      ],
    );
  }
}

/// Incoming job offer sheet with a 25-second countdown + Stitch Voice Note Pill.
class _IncomingOfferModal extends StatefulWidget {
  final ProviderJobOffer offer;
  final VoidCallback onAccept;

  const _IncomingOfferModal({required this.offer, required this.onAccept});

  @override
  State<_IncomingOfferModal> createState() => _IncomingOfferModalState();
}

class _IncomingOfferModalState extends State<_IncomingOfferModal> {
  static const int _ttlSeconds = 25;
  int _secondsLeft = _ttlSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        if (mounted) Navigator.of(context).pop();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final o = widget.offer;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.highlight, width: 2.5),
          boxShadow: c.e3,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header pill + countdown ring
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: c.peachTint,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              color: c.accentStart,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                context.trPair(
                                  'NEW INSTANT JOB',
                                  'नई तत्काल बुकिंग',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: c.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: _secondsLeft / _ttlSeconds,
                            strokeWidth: 4.5,
                            backgroundColor: c.surfaceSunken,
                            color: c.highlight,
                          ),
                        ),
                        Text(
                          '${_secondsLeft}s',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: c.ink,
                            fontFamily: QFonts.display,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Net earnings box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.surfaceSunken,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.border),
                ),
                child: Column(
                  children: [
                    Text(
                      context.trPair(
                        'YOU EARN FROM THIS JOB',
                        'इस काम से आपकी कमाई',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: c.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${BrandConfig.currency}${o.netPayoutRupees}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: c.highlight,
                          letterSpacing: -1,
                          fontFamily: QFonts.display,
                        ),
                      ),
                    ),
                    Text(
                      '${context.tr(o.paymentMode.label)} (${BrandConfig.currency}${o.grossAmountRupees})',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: c.ink,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: c.peachTint,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 12,
                            color: c.accentStart,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              context.trPair(
                                'Direct to Bank / Instant Settlement',
                                'सीधा बैंक खाते में / तुरंत भुगतान',
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: c.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Service & distance
              Text(
                context.tr(o.serviceName),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: c.ink,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.tr(o.packageName),
                style: TextStyle(
                  fontSize: 13.5,
                  color: c.inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.near_me_rounded,
                    size: 18,
                    color: c.accentStart,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      context.trPair(
                        '${o.distanceKm} km • ${o.etaMinutes} mins away • ${o.addressArea.en}',
                        '${o.distanceKm} किमी • ${o.etaMinutes} मिनट दूर • ${o.addressArea.hi}',
                      ),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: c.ink,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stitch Customer Voice Note Preview Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: c.lilac,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: c.purpleAccent.withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      size: 20,
                      color: c.purpleAccent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.trPair(
                          'Customer Voice Note (0:10s) • Tap to listen',
                          'ग्राहक का वॉइस नोट (0:10s) • सुनने के लिए टैप करें',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: c.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Skip vs Accept
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        foregroundColor: c.danger,
                        side: BorderSide(color: c.danger),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          context.trPair('Skip', 'छोड़ें'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 7,
                    child: ElevatedButton(
                      key: const ValueKey('offer-accept'),
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: c.highlight,
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 22),
                          const SizedBox(width: 8),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                context.trPair('ACCEPT JOB', 'स्वीकार करें'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// STITCH INTERACTIVE 4-DIGIT OTP KEYPAD MODAL ("Minimal OTP & Instant Payout")
/// ============================================================================
class _OtpKeypadModal extends StatefulWidget {
  final String expectedOtp;
  final int netPayoutRupees;
  final VoidCallback onVerified;

  const _OtpKeypadModal({
    required this.expectedOtp,
    required this.netPayoutRupees,
    required this.onVerified,
  });

  @override
  State<_OtpKeypadModal> createState() => _OtpKeypadModalState();
}

class _OtpKeypadModalState extends State<_OtpKeypadModal> {
  String _entered = '';

  void _onDigitTap(String digit) {
    if (_entered.length >= 4) return;
    setState(() => _entered = '$_entered$digit');
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  void _onClear() {
    setState(() => _entered = '');
  }

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final canVerify = _entered.length == 4;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c.highlight, width: 2),
          boxShadow: c.e3,
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stitch Compact Header Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: c.ink,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.pin_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.trPair(
                          'ENTER 4-DIGIT OTP (Demo: ${widget.expectedOtp})',
                          '4-अंकों का OTP दर्ज करें (डेमो: ${widget.expectedOtp})',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      key: const ValueKey('otp-autofill'),
                      onTap: () =>
                          setState(() => _entered = widget.expectedOtp),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          context.trPair('Auto-Fill', 'ऑटो-फिल'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: c.accentEnd,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 4-Digit Display Boxes ("8 4 2 •")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (idx) {
                  final hasChar = idx < _entered.length;
                  final char = hasChar ? _entered[idx] : '•';
                  final isCurrent = idx == _entered.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    width: 46,
                    height: 44,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hasChar
                          ? c.peachTint
                          : c.surfaceSunken,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: hasChar || isCurrent
                            ? c.accentStart
                            : c.border,
                        width: hasChar || isCurrent ? 2.0 : 1.2,
                      ),
                    ),
                    child: Text(
                      char,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: hasChar ? c.ink : c.inkMuted,
                        fontFamily: QFonts.display,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),

              // 3x4 Tactile Numeric Keypad
              for (final row in const [
                ['1', '2', '3'],
                ['4', '5', '6'],
                ['7', '8', '9'],
                ['C', '0', '⌫'],
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: row.map((keyLabel) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SizedBox(
                            height: 38,
                            child: OutlinedButton(
                              key: ValueKey('otp-key-$keyLabel'),
                              onPressed: () {
                                if (keyLabel == 'C') {
                                  _onClear();
                                } else if (keyLabel == '⌫') {
                                  _onBackspace();
                                } else {
                                  _onDigitTap(keyLabel);
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: c.surfaceSunken,
                                foregroundColor: c.ink,
                                side: BorderSide(color: c.border),
                                padding: EdgeInsets.zero,
                                minimumSize: const Size.fromHeight(38),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                keyLabel,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: QFonts.display,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 6),

              // Verify & Start Work Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const ValueKey('otp-verify-submit'),
                  onPressed: () {
                    if (!canVerify) {
                      setState(() => _entered = widget.expectedOtp);
                    }
                    widget.onVerified();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: c.highlight,
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 19),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          context.trPair(
                            'Verify OTP & Start Job',
                            'OTP सत्यापित करें, काम शुरू करें',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
