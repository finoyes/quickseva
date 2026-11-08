import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'l10n.dart';
import 'theme.dart';
import 'widgets.dart';

/// Interactive 100%-Offline Vector & Tile Map for QuickSeva Live Tracking
/// and Partner Turn-by-Turn Navigation.
///
/// Features:
/// - Zero network calls or external API keys (renders 100% offline in main app & tests).
/// - Pan & pinch-to-zoom via [InteractiveViewer] + `+` / `−` / `Recenter` controls.
/// - Realistic offline vector map tiles: arterial roads, secondary streets,
///   roundabouts, parks (Pastel Green), water bodies, building footprints,
///   and named Jaipur/Udaipur landmarks.
/// - Toggleable PostGIS Serviceability Geofence Polygon overlay.
/// - Street-snapped multi-waypoint route with directional chevrons,
///   completed vs. remaining route, and live-interpolated Partner Scooter pin.
/// - Built-in "Auto-Drive ▶" simulator so presenters can play smooth continuous
///   movement during a live client pitch.
class QOfflineTrackingMap extends StatefulWidget {
  /// Normalized progress along the route in `[0.0, 1.0]`.
  final double routeProgress;

  /// Partner display name shown on the moving rider pin.
  final String partnerName;

  /// Destination label (e.g. "Your Home" or customer name).
  final String destinationLabel;

  /// Area / zone label shown in the telemetry bar.
  final String zoneCode;

  /// Whether the booking is completed.
  final bool isCompleted;

  /// Height of the map viewport.
  final double height;

  /// Optional callback when the user taps the "Auto-Drive" step completion.
  final VoidCallback? onStepAdvanceRequested;

  const QOfflineTrackingMap({
    super.key,
    required this.routeProgress,
    required this.partnerName,
    required this.destinationLabel,
    this.zoneCode = 'ZONE-JPR-04',
    this.isCompleted = false,
    this.height = 256,
    this.onStepAdvanceRequested,
  });

  @override
  State<QOfflineTrackingMap> createState() => _QOfflineTrackingMapState();
}

class _QOfflineTrackingMapState extends State<QOfflineTrackingMap> {
  final TransformationController _transformController =
      TransformationController();
  double _zoomLevel = 1.0;
  bool _showPostGisPolygon = true;
  bool _isAutoDriving = false;
  double? _autoDriveProgress;
  Timer? _autoDriveTimer;

  static const List<Offset> _normalizedWaypoints = [
    Offset(0.11, 0.76), // 0: Partner Hub (Queens Road Circle)
    Offset(0.24, 0.76), // 1: East along Queens Road
    Offset(0.32, 0.56), // 2: North-East turn at Amrapali Circle
    Offset(0.54, 0.56), // 3: Along Amrapali Marg
    Offset(0.62, 0.34), // 4: Turn toward Sector 3 Main Road
    Offset(0.84, 0.34), // 5: Customer Home Gate
  ];

  @override
  void didUpdateWidget(covariant QOfflineTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routeProgress != widget.routeProgress && !_isAutoDriving) {
      _autoDriveProgress = null;
    }
  }

  @override
  void dispose() {
    _autoDriveTimer?.cancel();
    _transformController.dispose();
    super.dispose();
  }

  void _toggleAutoDrive() {
    if (_isAutoDriving) {
      _autoDriveTimer?.cancel();
      setState(() => _isAutoDriving = false);
      return;
    }

    setState(() {
      _isAutoDriving = true;
      _autoDriveProgress =
          (_autoDriveProgress ?? widget.routeProgress) >= 0.96
              ? 0.05
              : (_autoDriveProgress ?? widget.routeProgress);
    });

    _autoDriveTimer?.cancel();
    _autoDriveTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final next = (_autoDriveProgress ?? 0.1) + 0.012;
      if (next >= 1.0) {
        timer.cancel();
        setState(() {
          _autoDriveProgress = 1.0;
          _isAutoDriving = false;
        });
        widget.onStepAdvanceRequested?.call();
      } else {
        setState(() {
          _autoDriveProgress = next;
        });
      }
    });
  }

  void _zoomBy(double factor) {
    final nextZoom = (_zoomLevel * factor).clamp(1.0, 2.4);
    setState(() {
      _zoomLevel = nextZoom;
      if (nextZoom == 1.0) {
        _transformController.value = Matrix4.identity();
      } else {
        _transformController.value = Matrix4.identity()
          ..translateByDouble(-60.0 * (nextZoom - 1.0), -40.0 * (nextZoom - 1.0), 0.0, 1.0)
          ..scaleByDouble(nextZoom, nextZoom, 1.0, 1.0);
      }
    });
  }

  void _resetCamera() {
    setState(() {
      _zoomLevel = 1.0;
      _transformController.value = Matrix4.identity();
    });
  }

  /// Computes position and tangent angle along the piecewise-linear street route.
  ({Offset point, double angleRad, int segmentIndex}) _sampleStreetRoute(
    Size size,
    double t,
  ) {
    final pts = _normalizedWaypoints
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();
    final lengths = <double>[];
    double totalLen = 0;
    for (int i = 0; i < pts.length - 1; i++) {
      final segLen = (pts[i + 1] - pts[i]).distance;
      lengths.add(segLen);
      totalLen += segLen;
    }
    if (totalLen <= 0) {
      return (point: pts.first, angleRad: 0.0, segmentIndex: 0);
    }

    final targetDist = t.clamp(0.0, 1.0) * totalLen;
    double acc = 0;
    for (int i = 0; i < lengths.length; i++) {
      final segLen = lengths[i];
      if (acc + segLen >= targetDist || i == lengths.length - 1) {
        final localT =
            segLen > 0 ? ((targetDist - acc) / segLen).clamp(0.0, 1.0) : 0.0;
        final p = Offset.lerp(pts[i], pts[i + 1], localT)!;
        final delta = pts[i + 1] - pts[i];
        return (
          point: p,
          angleRad: math.atan2(delta.dy, delta.dx),
          segmentIndex: i,
        );
      }
      acc += segLen;
    }
    return (
      point: pts.last,
      angleRad: 0.0,
      segmentIndex: lengths.length - 1,
    );
  }

  Tr _turnInstructionForSegment(int segmentIdx, bool isCompleted) {
    if (isCompleted) {
      return const Tr(
        'Arrived at Customer Gate • GPS Verified',
        'ग्राहक के गेट पर पहुंच गए • GPS सत्यापित',
      );
    }
    switch (segmentIdx) {
      case 0:
        return const Tr(
          'Head east on Queens Road toward Amrapali Circle (320m)',
          'क्वींस रोड से आम्रपाली सर्कल की ओर बढ़ें (320m)',
        );
      case 1:
        return const Tr(
          'Take slight left at Amrapali Circle roundabout (190m)',
          'आम्रपाली सर्कल चौराहे से बाएं मुड़ें (190m)',
        );
      case 2:
        return const Tr(
          'Continue straight on Amrapali Marg past Central Park (410m)',
          'सेंट्रल पार्क के पास आम्रपाली मार्ग पर सीधे चलें (410m)',
        );
      case 3:
        return const Tr(
          'Turn left onto Sector 3 Main Avenue (220m)',
          'सेक्टर 3 मेन एवेन्यू पर बाएं मुड़ें (220m)',
        );
      default:
        return const Tr(
          'Destination ahead on right • Prepare Start OTP',
          'मंज़िल दाईं ओर है • स्टार्ट OTP तैयार रखें',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final effectiveTarget = _autoDriveProgress ?? widget.routeProgress;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.border, width: 1.5),
        boxShadow: c.e1,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapSize = Size(constraints.maxWidth, constraints.maxHeight);

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: effectiveTarget,
              end: effectiveTarget,
            ),
            duration: Duration(milliseconds: _isAutoDriving ? 50 : 520),
            curve: Curves.easeOutCubic,
            builder: (context, animProgress, _) {
              final clamped = animProgress.clamp(0.0, 1.0);
              final sample = _sampleStreetRoute(mapSize, clamped);
              final destPt = Offset(
                _normalizedWaypoints.last.dx * mapSize.width,
                _normalizedWaypoints.last.dy * mapSize.height,
              );
              final hubPt = Offset(
                _normalizedWaypoints.first.dx * mapSize.width,
                _normalizedWaypoints.first.dy * mapSize.height,
              );
              final remainingKm =
                  ((1.0 - clamped) * 2.1).clamp(0.0, 2.1);
              final etaMins =
                  widget.isCompleted ? 0 : math.max(1, (remainingKm * 4).round());
              final turnText = _turnInstructionForSegment(
                sample.segmentIndex,
                widget.isCompleted || clamped >= 0.98,
              );

              return Stack(
                children: [
                  // 1. Interactive Pannable & Zoomable Offline Vector Map Canvas
                  Positioned.fill(
                    child: InteractiveViewer(
                      transformationController: _transformController,
                      minScale: 1.0,
                      maxScale: 2.5,
                      child: SizedBox(
                        width: mapSize.width,
                        height: mapSize.height,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _OfflineVectorTilePainter(
                                  progress: clamped,
                                  waypoints: _normalizedWaypoints,
                                  showPostGisZone: _showPostGisPolygon,
                                  accentColor: c.accentStart,
                                  highlightColor: c.highlight,
                                  pistachioColor: c.pistachio,
                                  lilacColor: c.lilac,
                                  purpleColor: c.purpleAccent,
                                  inkColor: c.ink,
                                ),
                              ),
                            ),

                            // Partner Dispatch Hub Pin
                            Positioned(
                              left: (hubPt.dx - 34).clamp(6.0, mapSize.width - 80),
                              top: (hubPt.dy + 8).clamp(6.0, mapSize.height - 28),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: c.surface.withValues(alpha: 0.94),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: c.border),
                                ),
                                child: Text(
                                  context.trPair('QuickSeva Hub', 'पार्टनर हब'),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: c.ink,
                                  ),
                                ),
                              ),
                            ),

                            // Destination Home Pin
                            Positioned(
                              left: (destPt.dx - 38).clamp(8.0, mapSize.width - 86),
                              top: (destPt.dy - 42).clamp(8.0, mapSize.height - 52),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: c.ink,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      widget.destinationLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: c.accentStart,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.home_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Moving Partner Scooter Pill along Street Route
                            Positioned(
                              left: (sample.point.dx - 56).clamp(
                                8.0,
                                math.max(8.0, mapSize.width - 136),
                              ),
                              top: (sample.point.dy - 20).clamp(
                                42.0,
                                math.max(42.0, mapSize.height - 68),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: c.surface,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: c.accentStart,
                                    width: 1.8,
                                  ),
                                  boxShadow: c.e2,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: c.peachTint,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.two_wheeler_rounded,
                                        size: 13,
                                        color: c.accentStart,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 82,
                                      ),
                                      child: Text(
                                        widget.partnerName.split(' ').first,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w900,
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
                      ),
                    ),
                  ),

                  // 2. Top Offline Map Telemetry & Auto-Drive Pitch Controls
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: c.ink,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LiveStatusDot(
                                  color: c.highlight,
                                  size: 7,
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    widget.isCompleted
                                        ? context.trPair(
                                            'OFFLINE MAP • ARRIVED',
                                            'ऑफलाइन मैप • पहुंच गए',
                                          )
                                        : context.trPair(
                                            'OFFLINE GPS • ${remainingKm.toStringAsFixed(1)} km ($etaMins min)',
                                            'ऑफलाइन GPS • ${remainingKm.toStringAsFixed(1)} किमी ($etaMins मि.)',
                                          ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Interactive Auto-Drive Pitch Simulator Toggle
                        GestureDetector(
                          onTap: _toggleAutoDrive,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _isAutoDriving ? c.highlight : c.peachTint,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: _isAutoDriving
                                    ? c.highlight
                                    : c.accentStart,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isAutoDriving
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 13,
                                  color: _isAutoDriving
                                      ? Colors.white
                                      : c.accentStart,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  _isAutoDriving
                                      ? context.trPair('Simulating', 'चल रहा है')
                                      : context.trPair('Drive ▶', 'ड्राइव ▶'),
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    color: _isAutoDriving
                                        ? Colors.white
                                        : c.accentStart,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. Right-Side Offline Map Zoom & PostGIS Layer Controls
                  Positioned(
                    right: 10,
                    top: 46,
                    child: Column(
                      children: [
                        _MapControlIconBtn(
                          icon: Icons.add_rounded,
                          tooltip: 'Zoom in',
                          onTap: () => _zoomBy(1.25),
                        ),
                        const SizedBox(height: 4),
                        _MapControlIconBtn(
                          icon: Icons.remove_rounded,
                          tooltip: 'Zoom out',
                          onTap: () => _zoomBy(0.8),
                        ),
                        const SizedBox(height: 4),
                        _MapControlIconBtn(
                          icon: Icons.my_location_rounded,
                          tooltip: 'Recenter',
                          onTap: _resetCamera,
                        ),
                        const SizedBox(height: 4),
                        _MapControlIconBtn(
                          icon: Icons.hexagon_outlined,
                          active: _showPostGisPolygon,
                          tooltip: 'PostGIS Geofence',
                          onTap: () => setState(
                            () => _showPostGisPolygon = !_showPostGisPolygon,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 4. Bottom Turn-by-Turn Street Banner + Offline Tile Badge
                  Positioned(
                    left: 10,
                    right: 10,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: c.surface.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: c.pistachio,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.turn_right_rounded,
                              size: 14,
                              color: c.highlight,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              context.tr(turnText),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: c.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: c.lilac,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(clamped * 100).round()}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: c.purpleAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _MapControlIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool active;
  final VoidCallback onTap;

  const _MapControlIconBtn({
    required this.icon,
    required this.tooltip,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? c.lilac : c.surface.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? c.purpleAccent : c.border,
          ),
        ),
        child: Icon(
          icon,
          size: 15,
          color: active ? c.purpleAccent : c.ink,
        ),
      ),
    );
  }
}

/// Opens a full-screen / modal bottom sheet with the Offline Turn-by-Turn
/// Navigation Map for the Provider App's "Navigate" button.
void showOfflineNavigationSheet(
  BuildContext context, {
  required String customerName,
  required String addressText,
  required double progress,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final c = QSevaColors.of(ctx);
      return SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
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
                      color: c.pistachio,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.navigation_rounded,
                      size: 18,
                      color: c.highlight,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ctx.trPair(
                            'Offline Turn-by-Turn Navigation',
                            'ऑफलाइन टर्न-बाय-टर्न नेविगेशन',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w900,
                            color: c.ink,
                          ),
                        ),
                        Text(
                          addressText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              QOfflineTrackingMap(
                routeProgress: progress,
                partnerName: 'You',
                destinationLabel: customerName,
                height: 290,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.offline_bolt_rounded,
                    size: 16,
                    color: c.highlight,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      ctx.trPair(
                        'Cached offline vector tiles active • Works in zero-network basements',
                        'ऑफलाइन वेक्टर मैप सक्रिय • बिना इंटरनेट के भी काम करता है',
                      ),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: c.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _OfflineVectorTilePainter extends CustomPainter {
  final double progress;
  final List<Offset> waypoints;
  final bool showPostGisZone;
  final Color accentColor;
  final Color highlightColor;
  final Color pistachioColor;
  final Color lilacColor;
  final Color purpleColor;
  final Color inkColor;

  _OfflineVectorTilePainter({
    required this.progress,
    required this.waypoints,
    required this.showPostGisZone,
    required this.accentColor,
    required this.highlightColor,
    required this.pistachioColor,
    required this.lilacColor,
    required this.purpleColor,
    required this.inkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Offline Tile Grid (64x64px vector tiles)
    final tileGridPaint = Paint()
      ..color = inkColor.withValues(alpha: 0.045)
      ..strokeWidth = 1.0;
    for (double x = 0; x < w; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), tileGridPaint);
    }
    for (double y = 0; y < h; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(w, y), tileGridPaint);
    }

    // 2. Pastel Green Parks & Green Belts
    final parkPaint = Paint()
      ..color = pistachioColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.36, h * 0.16, w * 0.20, h * 0.24),
        const Radius.circular(12),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.64, h * 0.62, w * 0.24, h * 0.20),
        const Radius.circular(10),
      ),
      parkPaint,
    );

    // 3. Lilac Civic / Commercial Blocks & Building Footprints
    final blockPaint = Paint()
      ..color = inkColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    final blocks = [
      Rect.fromLTWH(w * 0.06, h * 0.18, w * 0.22, h * 0.22),
      Rect.fromLTWH(w * 0.08, h * 0.46, w * 0.18, h * 0.20),
      Rect.fromLTWH(w * 0.36, h * 0.64, w * 0.22, h * 0.18),
      Rect.fromLTWH(w * 0.64, h * 0.12, w * 0.26, h * 0.16),
    ];
    for (final rect in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(7)),
        blockPaint,
      );
    }

    // 4. Optional PostGIS Serviceability Geofence Hex/Polygon Overlay
    if (showPostGisZone) {
      final zonePath = Path()
        ..moveTo(w * 0.05, h * 0.86)
        ..lineTo(w * 0.08, h * 0.22)
        ..lineTo(w * 0.56, h * 0.10)
        ..lineTo(w * 0.94, h * 0.22)
        ..lineTo(w * 0.92, h * 0.82)
        ..close();
      canvas.drawPath(
        zonePath,
        Paint()
          ..color = lilacColor.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        zonePath,
        Paint()
          ..color = purpleColor.withValues(alpha: 0.32)
          ..strokeWidth = 1.4
          ..style = PaintingStyle.stroke,
      );
    }

    // 5. Arterial & Secondary Road Network (White Casing + Soft Border)
    final roadBorderPaint = Paint()
      ..color = inkColor.withValues(alpha: 0.12)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final roadFillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..strokeWidth = 9.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final networkPath = Path()
      // Horizontal arterials
      ..moveTo(0, h * 0.76)
      ..lineTo(w, h * 0.76)
      ..moveTo(0, h * 0.56)
      ..lineTo(w, h * 0.56)
      ..moveTo(w * 0.25, h * 0.34)
      ..lineTo(w, h * 0.34)
      // Connecting avenues
      ..moveTo(w * 0.24, h)
      ..lineTo(w * 0.36, 0)
      ..moveTo(w * 0.54, h)
      ..lineTo(w * 0.66, 0);

    canvas.drawPath(networkPath, roadBorderPaint);
    canvas.drawPath(networkPath, roadFillPaint);

    // Roundabout at Amrapali Circle (waypoint 1 -> 2)
    final circlePt = Offset(w * 0.28, h * 0.66);
    canvas.drawCircle(circlePt, 10, roadBorderPaint);
    canvas.drawCircle(circlePt, 8, Paint()..color = pistachioColor);

    // 6. Active Navigation Route Polyline
    final pts =
        waypoints.map((p) => Offset(p.dx * w, p.dy * h)).toList();
    final routePath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      routePath.lineTo(pts[i].dx, pts[i].dy);
    }

    // Full route background track
    canvas.drawPath(
      routePath,
      Paint()
        ..color = accentColor.withValues(alpha: 0.25)
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    // Completed / active route segment traced up to `progress`
    for (final metric in routePath.computeMetrics()) {
      final activeLen = metric.length * progress.clamp(0.0, 1.0);
      final activeSegment = metric.extractPath(0, activeLen);
      canvas.drawPath(
        activeSegment,
        Paint()
          ..color = accentColor
          ..strokeWidth = 6.0
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      );
    }

    // 7. Radar Rings around Destination ("Your Home")
    final homeDest = pts.last;
    final pulsePhase = (progress * 3.0) % 1.0;
    final outerRadarRadius = 16.0 + (pulsePhase * 20.0);
    canvas.drawCircle(
      homeDest,
      outerRadarRadius,
      Paint()
        ..color = accentColor.withValues(
          alpha: (0.22 * (1.0 - pulsePhase)).clamp(0.04, 0.22),
        )
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      homeDest,
      22,
      Paint()
        ..color = accentColor.withValues(alpha: 0.28)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );

    // 8. Start Hub Node & Intermediate Waypoint Dots
    for (int i = 0; i < pts.length - 1; i++) {
      canvas.drawCircle(
        pts[i],
        i == 0 ? 6.0 : 3.5,
        Paint()..color = i == 0 ? inkColor : accentColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OfflineVectorTilePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.showPostGisZone != showPostGisZone ||
      oldDelegate.accentColor != accentColor ||
      oldDelegate.inkColor != inkColor;
}
