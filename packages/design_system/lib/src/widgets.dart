import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'brand_config.dart';
import 'l10n.dart';
import 'models.dart';
import 'motion.dart';
import 'theme.dart';
import 'tokens.dart';

/// Smooth Page Route Transition (Fade + Gentle Slide + Micro-Scale)
/// Safe with `pumpAndSettle` in widget tests while giving fluid motion in-app.
class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SmoothPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 280),
          reverseTransitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.04, 0.02),
                  end: Offset.zero,
                ).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.985, end: 1.0).animate(curved),
                  child: child,
                ),
              ),
            );
          },
        );
}

/// Tactile Spring Press Wrapper for Cards, Bento Tiles & Action Chips.
/// Scales down smoothly on touch/press and springs back on release.
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.965,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value && mounted) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: _pressed ? Curves.easeInOut : Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}

/// Architectural Layered-Shape Card (Flat Solid Geometric Cutouts, Zero Gradients)
/// Inspired by Stitch "Karmic Motion".
///
/// * Dark backgrounds get the full 5-layer scroll-driven parallax composition
///   (disc, ring, stepped pill, angled pill, diamond).
/// * Light backgrounds get a single subtle corner disc + ring that drifts on
///   scroll, so decoration never competes with content.
///
/// Only the decoration layer rebuilds on scroll; the child is cached.
class LayeredShapeCard extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final Color primaryShapeColor;
  final Color secondaryShapeColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final double depthMultiplier;
  final bool? subtleShapes;

  const LayeredShapeCard({
    super.key,
    required this.child,
    this.backgroundColor = QColors.deepSlate,
    this.primaryShapeColor = QColors.deepSlateSurface,
    this.secondaryShapeColor = QColors.primaryGreen,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.border,
    this.boxShadow,
    this.onTap,
    this.depthMultiplier = 1.0,
    this.subtleShapes,
  });

  @override
  State<LayeredShapeCard> createState() => _LayeredShapeCardState();
}

class _LayeredShapeCardState extends State<LayeredShapeCard> {
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition = Scrollable.maybeOf(context)?.position;
  }

  double get _pixels {
    final pos = _scrollPosition;
    return (pos != null && pos.hasPixels) ? pos.pixels : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final subtle = widget.subtleShapes ??
        (widget.backgroundColor.computeLuminance() > 0.5);
    final reduced = QMotion.reduced(context);

    Widget shapes(double phase) {
      final dx = math.sin(phase);
      final dy = math.cos(phase * 0.85);
      return subtle ? _subtleShapes(dx, dy) : _fullShapes(dx, dy);
    }

    // Only animate parallax if explicitly enabled or on dark hero cards with multiplier > 0,
    // avoiding rebuilding dozens of cards on every single scroll tick.
    final shouldAnimateScroll = !reduced &&
        widget.depthMultiplier > 0 &&
        !subtle &&
        _scrollPosition != null;

    final decoration = !shouldAnimateScroll
        ? RepaintBoundary(child: shapes(0))
        : AnimatedBuilder(
            animation: _scrollPosition!,
            builder: (context, _) => RepaintBoundary(
              child: shapes(_pixels * 0.011 * widget.depthMultiplier),
            ),
          );

    final card = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.border,
        boxShadow: widget.boxShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(child: decoration),
          ),
          Padding(
            padding: widget.padding,
            child: widget.child,
          ),
        ],
      ),
    );

    if (widget.onTap == null) return card;
    return PressableScale(onTap: widget.onTap, child: card);
  }

  Widget _subtleShapes(double dx, double dy) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          right: -46 + (dx * 6),
          top: -52 + (dy * 6),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.primaryShapeColor.withValues(alpha: 0.55),
            ),
          ),
        ),
        Positioned(
          right: 10 - (dx * 8),
          top: -18 + (dy * 4),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.secondaryShapeColor.withValues(alpha: 0.16),
                width: 2.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fullShapes(double dx, double dy) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          right: -34 + (dx * 10),
          top: -38 + (dy * 12),
          child: Container(
            width: 144,
            height: 144,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.primaryShapeColor,
            ),
          ),
        ),
        Positioned(
          right: 16 - (dx * 14),
          top: -16 + (dy * -10),
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.secondaryShapeColor.withValues(alpha: 0.18),
              border: Border.all(
                color: widget.secondaryShapeColor.withValues(alpha: 0.34),
                width: 3.5,
              ),
            ),
          ),
        ),
        Positioned(
          right: -12 + (dy * 8),
          bottom: 18 - (dx * 12),
          child: Transform.rotate(
            angle: dx * 0.14,
            child: Container(
              width: 48,
              height: 18,
              decoration: BoxDecoration(
                color: widget.secondaryShapeColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        Positioned(
          left: -26 - (dx * 11),
          bottom: -28 + (dy * 9),
          child: Transform.rotate(
            angle: (-18 + (dx * 7)) * math.pi / 180,
            child: Container(
              width: 100,
              height: 54,
              decoration: BoxDecoration(
                color: widget.primaryShapeColor.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        Positioned(
          left: 28 + (dy * 10),
          top: -10 + (dx * 6),
          child: Transform.rotate(
            angle: (45 + (dx * 12)) * math.pi / 180,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: widget.secondaryShapeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Scroll-Linked Depth & Entrance Motion Wrapper for Cards and Bento Sections.
/// Uses a GPU-cached [RepaintBoundary] and smooth one-shot entrance without
/// per-frame 3D perspective Matrix4 rasterization stalls during scroll.
class ScrollDepthCard extends StatelessWidget {
  final Widget child;
  final int index;
  final double parallaxStrength;

  const ScrollDepthCard({
    super.key,
    required this.child,
    this.index = 0,
    this.parallaxStrength = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: StaggeredEntrance(
        index: index % 6,
        offsetY: 14,
        child: child,
      ),
    );
  }
}

/// Smooth Rolling Numeric Counter for Rupee Prices & Earnings Totals.
class RollingRupeeText extends StatefulWidget {
  final int amountRupees;
  final TextStyle style;
  final String prefix;
  final String suffix;

  const RollingRupeeText({
    super.key,
    required this.amountRupees,
    required this.style,
    this.prefix = BrandConfig.currency,
    this.suffix = '',
  });

  @override
  State<RollingRupeeText> createState() => _RollingRupeeTextState();
}

class _RollingRupeeTextState extends State<RollingRupeeText> {
  late int _previousAmount;

  @override
  void initState() {
    super.initState();
    _previousAmount = widget.amountRupees;
  }

  @override
  void didUpdateWidget(covariant RollingRupeeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amountRupees != widget.amountRupees) {
      _previousAmount = oldWidget.amountRupees;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: _previousAmount.toDouble(),
        end: widget.amountRupees.toDouble(),
      ),
      duration: QMotion.of(context, const Duration(milliseconds: 340)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text(
          '${widget.prefix}${value.round()}${widget.suffix}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: widget.style.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}

/// Elastic Spring Bounce Wrapper when `triggerKey` changes (e.g., Cart item / package change).
class ElasticBounceWrapper extends StatefulWidget {
  final Object triggerKey;
  final Widget child;

  const ElasticBounceWrapper({
    super.key,
    required this.triggerKey,
    required this.child,
  });

  @override
  State<ElasticBounceWrapper> createState() => _ElasticBounceWrapperState();
}

class _ElasticBounceWrapperState extends State<ElasticBounceWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.045)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.045, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 55,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ElasticBounceWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.triggerKey != widget.triggerKey) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: widget.child,
    );
  }
}

/// Solid Vector Sonar Radar Graphic (Zero Gradients)
/// Draws concentric solid sonar rings, crosshair axes, sweeping vector arm, and blips.
class SonarRadarGraphic extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color accentColor;
  final double sweepAngleRadians;
  final Widget? centerChild;

  const SonarRadarGraphic({
    super.key,
    this.size = 92,
    this.primaryColor = QColors.primaryGreen,
    this.accentColor = QColors.karmicOrange,
    this.sweepAngleRadians = -0.65,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _SonarRadarPainter(
                primaryColor: primaryColor,
                accentColor: accentColor,
                sweepAngleRadians: sweepAngleRadians,
              ),
            ),
          ),
          ?centerChild,
        ],
      ),
    );
  }
}

class _SonarRadarPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final double sweepAngleRadians;

  _SonarRadarPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.sweepAngleRadians,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width / 2;

    // 3 Concentric solid fill + stroke sonar rings
    final outerFill = Paint()
      ..color = primaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxR, outerFill);

    final midFill = Paint()
      ..color = primaryColor.withValues(alpha: 0.13)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxR * 0.68, midFill);

    final innerFill = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxR * 0.38, innerFill);

    final ringStroke = Paint()
      ..color = primaryColor.withValues(alpha: 0.32)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, maxR - 1, ringStroke);
    canvas.drawCircle(center, maxR * 0.68, ringStroke);
    canvas.drawCircle(center, maxR * 0.38, ringStroke);

    // Crosshair lines
    final axisPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.22)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(center.dx - maxR + 4, center.dy),
      Offset(center.dx + maxR - 4, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxR + 4),
      Offset(center.dx, center.dy + maxR - 4),
      axisPaint,
    );

    // Solid radar sector wedge (flat solid alpha, zero gradient)
    final sectorPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxR - 2),
      sweepAngleRadians - 0.55,
      0.55,
      true,
      sectorPaint,
    );

    // Sweeping vector arm
    final armEnd = Offset(
      center.dx + math.cos(sweepAngleRadians) * (maxR - 3),
      center.dy + math.sin(sweepAngleRadians) * (maxR - 3),
    );
    final armPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, armEnd, armPaint);

    // Nearby job blips (solid circles)
    final blip1 = Offset(
      center.dx + math.cos(sweepAngleRadians - 0.25) * (maxR * 0.62),
      center.dy + math.sin(sweepAngleRadians - 0.25) * (maxR * 0.62),
    );
    final blip2 = Offset(
      center.dx + math.cos(sweepAngleRadians + 2.1) * (maxR * 0.48),
      center.dy + math.sin(sweepAngleRadians + 2.1) * (maxR * 0.48),
    );
    canvas.drawCircle(
      blip1,
      5.5,
      Paint()..color = accentColor.withValues(alpha: 0.28),
    );
    canvas.drawCircle(blip1, 3.2, Paint()..color = accentColor);
    canvas.drawCircle(blip2, 3.0, Paint()..color = primaryColor);
  }

  @override
  bool shouldRepaint(covariant _SonarRadarPainter oldDelegate) =>
      oldDelegate.sweepAngleRadians != sweepAngleRadians ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.accentColor != accentColor;
}

/// Circular Countdown Progress Ring Badge (for 15s Incoming Job Offer Modal)
class CircularCountdownBadge extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final Color activeColor;

  const CircularCountdownBadge({
    super.key,
    required this.remainingSeconds,
    this.totalSeconds = 15,
    this.activeColor = QColors.amberGold,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: progress, end: progress),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, animProgress, _) {
        return CustomPaint(
          painter: _CircularCountdownPainter(
            progress: animProgress,
            activeColor: activeColor,
          ),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Text(
              '${remainingSeconds}s',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircularCountdownPainter extends CustomPainter {
  final double progress;
  final Color activeColor;

  _CircularCountdownPainter({
    required this.progress,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 3;

    // Background disc
    canvas.drawCircle(
      center,
      size.width / 2,
      Paint()..color = Colors.white.withValues(alpha: 0.14),
    );

    // Track ring
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Active progress arc
    final arcPaint = Paint()
      ..color = activeColor
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularCountdownPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeColor != activeColor;
}

/// Concentric Live Status Dot (Flat Solid Layers)
class LiveStatusDot extends StatelessWidget {
  final Color color;
  final double size;

  const LiveStatusDot({
    super.key,
    this.color = QColors.vibrantMint,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 6,
      height: size + 6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.24),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

/// 1-Tap Bilingual Switcher Pill (EN <-> हिं)
class LanguageTogglePill extends StatelessWidget {
  final bool darkSurface;
  const LanguageTogglePill({super.key, this.darkSurface = false});

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final controller = LanguageScope.of(context);
    final isHindi = controller.isHindi;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: controller.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: darkSurface
              ? Colors.white.withValues(alpha: 0.14)
              : c.surfaceSunken,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: darkSurface
                ? Colors.white.withValues(alpha: 0.25)
                : c.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate_rounded,
              size: 14,
              color: darkSurface ? Colors.white : c.accentStart,
            ),
            const SizedBox(width: 5),
            Text(
              isHindi ? 'हिंदी • EN' : 'EN • हिंदी',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: darkSurface ? Colors.white : c.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Matches UC Screenshot #1: Segmented Toggle ("⚡ In 14 mins" vs "Later")
class InstantLaterSegmentedControl extends StatelessWidget {
  final bool isInstant;
  final int instantMinutes;
  final ValueChanged<bool> onChanged;

  const InstantLaterSegmentedControl({
    super.key,
    required this.isInstant,
    this.instantMinutes = BrandConfig.instantPromiseMinutes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: isInstant ? c.ink : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isInstant ? c.e1 : null,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DispatchClockGraphic(
                      size: 18,
                      color: isInstant ? c.accentEnd : c.highlight,
                      active: isInstant,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        context.trPair(
                          'In $instantMinutes mins',
                          '$instantMinutes मिनट में',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isInstant ? Colors.white : c.inkMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: !isInstant ? c.ink : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !isInstant ? c.e1 : null,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: !isInstant ? c.accentEnd : c.inkMuted,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        context.trPair('Later', 'बाद के लिए'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: !isInstant ? Colors.white : c.inkMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches UC Screenshot #1: Horizontal Duration / Package Card
/// ("45 mins", "₹49 ~~₹225~~", "🏷 78% OFF", "Bestseller" ribbon, "Book" button)
/// Enhanced with multi-layered geometric corner shapes and spring press physics.
class PackageDurationCard extends StatelessWidget {
  final ServicePackageTier tier;
  final bool isSelected;
  final VoidCallback onBookTap;

  const PackageDurationCard({
    super.key,
    required this.tier,
    this.isSelected = false,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    final discount = tier.discountPercent;

    return PressableScale(
      onTap: onBookTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 154,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: isSelected ? c.peachTint : c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? c.accentStart : c.border,
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: c.e1,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Single subtle corner accent (no inner radio-like dot)
                Positioned(
                  right: -28,
                  top: -28,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? c.accentStart.withValues(alpha: 0.14)
                          : c.peachTint.withValues(alpha: 0.65),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr(tier.title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: c.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RollingRupeeText(
                            amountRupees: tier.priceRupees,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: c.ink,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (tier.originalPriceRupees > tier.priceRupees)
                            Text(
                              '${BrandConfig.currency}${tier.originalPriceRupees}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: c.inkMuted,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (discount > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.local_offer_rounded,
                              size: 13,
                              color: c.highlight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              context.trPair('$discount% OFF', '$discount% छूट'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: c.highlight,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton(
                          onPressed: onBookTap,
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                isSelected ? c.ink : c.surface,
                            foregroundColor:
                                isSelected ? Colors.white : c.ink,
                            side: BorderSide(
                              color: isSelected ? c.ink : c.border,
                            ),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSelected) ...[
                                const Icon(
                                  Icons.check_rounded,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Flexible(
                                child: Text(
                                  isSelected
                                      ? context.trPair('Selected', 'चुन लिया')
                                      : context.trPair('Book', 'बुक करें'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
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
              ],
            ),
          ),
          if (tier.isBestseller)
            Positioned(
              top: 0,
              left: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: c.ink,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  context.trPair('Bestseller', 'बेस्टसेलर'),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Matches UC Screenshot #1: Super Saver Pack Banner with Tilted 3D Text & Layered Shapes
class SuperSaverPackBanner extends StatelessWidget {
  final SuperSaverPack pack;
  final VoidCallback onBookTap;

  const SuperSaverPackBanner({
    super.key,
    required this.pack,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return LayeredShapeCard(
      backgroundColor: c.ink,
      primaryShapeColor: c.accentStart,
      secondaryShapeColor: c.accentEnd,
      borderRadius: 18,
      padding: const EdgeInsets.all(18),
      boxShadow: c.e2,
      onTap: onBookTap,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: c.accentEnd,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    context.tr(pack.badgeText),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: c.onAccent,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(text: '${context.tr(pack.headline)} '),
                      TextSpan(
                        text:
                            '${BrandConfig.currency}${pack.originalPriceRupees}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.white.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '\n${context.tr(pack.pricePerVisitText)}',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: c.accentEnd,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.tr(pack.validityText),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: onBookTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.surface,
                    foregroundColor: c.ink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    minimumSize: const Size(92, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    context.trPair('Book', 'बुक करें'),
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Transform.rotate(
              angle: -10 * math.pi / 180,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.trPair(
                        'SUPER\nSAVER\nPACK',
                        'सुपर\nसेवर\nपैक',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        height: 0.96,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            offset: const Offset(3, 5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches UC Screenshot #2: Masonry Discovery Card ("Home Cleaning", "Beauty Services", etc.)
/// Optimized with static [RepaintBoundary] caching (zero scroll-listener setState jank),
/// spring press physics, Hero tag, and Peach Pop footer styling.
class MasonryDiscoveryCard extends StatelessWidget {
  final DiscoveryCardItem item;
  final double imageHeight;
  final VoidCallback onTap;
  final String? heroTag;

  const MasonryDiscoveryCard({
    super.key,
    required this.item,
    required this.imageHeight,
    required this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);

    final imageWidget = SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: QNetworkImage(
        url: item.imageUrl,
        fit: BoxFit.cover,
      ),
    );

    return RepaintBoundary(
      child: PressableScale(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.border),
            boxShadow: c.e1,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (heroTag != null)
                    Hero(tag: heroTag!, child: imageWidget)
                  else
                    imageWidget,
                  if (item.badge != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: c.ink,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.badge!.en.contains('min')
                                  ? Icons.bolt_rounded
                                  : (item.badge!.en.contains('Bestseller')
                                      ? Icons.workspace_premium_rounded
                                      : Icons.local_offer_rounded),
                              size: 12,
                              color: c.accentEnd,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              context.tr(item.badge!),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -22,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.peachTint.withValues(alpha: 0.72),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.tr(item.title),
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: c.ink,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: c.peachTint,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.accentStart.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_outward_rounded,
                            size: 14,
                            color: c.ink,
                          ),
                        ),
                      ],
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

/// Matches UC Screenshot #3: Date Selector Card ("Wed 01", "Thu 02", "Fri 03" with trend badge)
class DateSlotCard extends StatelessWidget {
  final DateSlotItem slot;
  final bool isSelected;
  final VoidCallback onTap;

  const DateSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return ElasticBounceWrapper(
      triggerKey: isSelected,
      child: PressableScale(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 68,
              height: 76,
              decoration: BoxDecoration(
                color: isSelected ? c.peachTint : c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? c.accentStart : c.border,
                  width: isSelected ? 1.8 : 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr(slot.dayShort),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? c.ink : c.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slot.dateNumber,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? c.ink : c.ink,
                    ),
                  ),
                ],
              ),
            ),
            if (slot.trend != DemandTrend.none)
              Positioned(
                top: -5,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: slot.trend == DemandTrend.lowDown
                        ? c.peachTint
                        : c.surfaceSunken,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: c.border),
                  ),
                  child: Icon(
                    slot.trend == DemandTrend.lowDown
                        ? Icons.trending_down_rounded
                        : Icons.trending_up_rounded,
                    size: 12,
                    color: slot.trend == DemandTrend.lowDown
                        ? c.warning
                        : c.inkMuted,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Matches UC Screenshot #3: Time Slot Cell ("9:30 AM", "11:30 AM" with "+ ₹20" badge)
class TimeSlotCell extends StatelessWidget {
  final TimeSlotItem slot;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotCell({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return ElasticBounceWrapper(
      triggerKey: isSelected,
      child: PressableScale(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? c.peachTint : c.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? c.accentStart : c.border,
                  width: isSelected ? 1.8 : 1.0,
                ),
              ),
              child: Text(
                slot.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: c.ink,
                ),
              ),
            ),
            if (slot.peakSurchargeRupees > 0)
              Positioned(
                top: -8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: c.peachTint,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: c.warning.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    '+ ${BrandConfig.currency}${slot.peakSurchargeRupees}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: c.warning,
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

/// Custom-Painted Animated 14-Min Dispatch Clock / Stopwatch Graphic (Zero Gradients)
class DispatchClockGraphic extends StatelessWidget {
  final double size;
  final Color color;
  final bool active;

  const DispatchClockGraphic({
    super.key,
    this.size = 18,
    this.color = QColors.primaryGreen,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('clock_$active'),
      tween: Tween<double>(begin: 0.0, end: active ? 1.0 : 0.35),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, progress, _) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DispatchClockPainter(
              color: color,
              progress: progress.clamp(0.0, 1.0),
            ),
          ),
        );
      },
    );
  }
}

class _DispatchClockPainter extends CustomPainter {
  final Color color;
  final double progress;

  _DispatchClockPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, (size.height / 2) + 1);
    final radius = (size.width / 2) - 2.2;

    // Top stopwatch crown
    final crownPaint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - 2.2, 0.8),
      Offset(center.dx + 2.2, 0.8),
      crownPaint,
    );

    // Outer clock ring
    final ringPaint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, ringPaint);

    // 14-minute solid sector wedge
    final sectorPaint = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1),
      -math.pi / 2,
      (math.pi * 0.72) * progress,
      true,
      sectorPaint,
    );

    // Sweeping hand
    final handAngle = (-math.pi / 2) + ((math.pi * 0.72) * progress);
    final handEnd = Offset(
      center.dx + math.cos(handAngle) * (radius - 2),
      center.dy + math.sin(handAngle) * (radius - 2),
    );
    canvas.drawLine(
      center,
      handEnd,
      Paint()
        ..color = color
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _DispatchClockPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// Interactive Before / After Service Comparison Slider Card (Zero Gradients)
/// Allows dragging or tapping presets to compare "Before" vs "After QuickSeva".
class BeforeAfterComparisonCard extends StatefulWidget {
  final Tr serviceTitle;

  const BeforeAfterComparisonCard({
    super.key,
    required this.serviceTitle,
  });

  @override
  State<BeforeAfterComparisonCard> createState() =>
      _BeforeAfterComparisonCardState();
}

class _BeforeAfterComparisonCardState extends State<BeforeAfterComparisonCard> {
  double _splitFraction = 0.56; // 56% After shown by default

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return LayeredShapeCard(
      backgroundColor: c.surface,
      primaryShapeColor: c.peachTint,
      secondaryShapeColor: c.highlight,
      borderRadius: 18,
      padding: const EdgeInsets.all(14),
      border: Border.all(color: c.border),
      boxShadow: c.e1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: c.ink,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  context.trPair('BEFORE vs AFTER', 'पहले बनाम बाद में'),
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
                    'Drag slider to inspect quality',
                    'क्वालिटी देखने के लिए स्लाइडर खींचें',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: c.inkMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Interactive Split Canvas
          LayoutBuilder(
            builder: (context, constraints) {
              final totalW = constraints.maxWidth;
              final splitX = (totalW * _splitFraction).clamp(32.0, totalW - 32.0);

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _splitFraction =
                        (details.localPosition.dx / totalW).clamp(0.15, 0.88);
                  });
                },
                onTapDown: (details) {
                  setState(() {
                    _splitFraction =
                        (details.localPosition.dx / totalW).clamp(0.15, 0.88);
                  });
                },
                child: Container(
                  height: 116,
                  decoration: BoxDecoration(
                    color: c.surfaceSunken,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      // RIGHT / FULL LAYER: "BEFORE" (Dull / Untreated State)
                      Positioned.fill(
                        child: Container(
                          color: c.surfaceSunken,
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: c.inkMuted,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        context.trPair('BEFORE', 'पहले'),
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: c.warning,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      context.trPair(
                                        'Scaling, Dust & Wear',
                                        'धूल, दाग और रुकावट',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: c.inkMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // LEFT CLIPPED LAYER: "AFTER QUICKSEVA" (Sparkling Clean State)
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: splitX,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: c.pistachio.withValues(alpha: 0.45),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: -16,
                                bottom: -16,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: c.highlight.withValues(alpha: 0.14),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: c.highlight,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      context.trPair(
                                        'AFTER ${BrandConfig.brandName.toUpperCase()}',
                                        '${BrandConfig.brandNameHindi} के बाद',
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    color: c.highlight,
                                    size: 26,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.trPair(
                                      '100% Sanitized & Restored',
                                      '100% चकाचक और सुरक्षित',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: c.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Vertical Divider Line + Tactile Drag Handle
                      Positioned(
                        left: splitX - 16,
                        top: 0,
                        bottom: 0,
                        width: 32,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 3,
                              color: c.ink,
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: c.ink,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.compare_arrows_rounded,
                                size: 16,
                                color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}

/// Celebratory Solid Geometric Confetti & Expanding Shield Checkmark Burst (Zero Gradients)
class GeometricCelebrationBurst extends StatelessWidget {
  final String title;
  final String subtitle;

  const GeometricCelebrationBurst({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = QSevaColors.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutBack,
      builder: (context, progress, _) {
        final clamped = progress.clamp(0.0, 1.2);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: c.pistachio.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.highlight, width: 1.5),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CustomPaint(
                  painter: _GeometricBurstPainter(
                    progress: clamped,
                    primaryColor: c.highlight,
                    palette: [
                      c.highlight,
                      c.accentStart,
                      c.accentEnd,
                      c.sky,
                    ],
                  ),
                  child: Center(
                    child: AnimatedCheckmark(size: 34, color: c.highlight),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: c.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GeometricBurstPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final List<Color> palette;

  _GeometricBurstPainter({
    required this.progress,
    required this.primaryColor,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Expanding outer ring
    canvas.drawCircle(
      center,
      (maxRadius * 0.85 * progress).clamp(4.0, maxRadius),
      Paint()
        ..color = primaryColor.withValues(alpha: 0.22)
        ..strokeWidth = 1.6
        ..style = PaintingStyle.stroke,
    );

    // 8 radiating solid geometric particles (diamonds & circles)
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (progress * 0.35);
      final dist = (10.0 + (15.0 * progress)).clamp(6.0, maxRadius - 2);
      final pt = Offset(
        center.dx + math.cos(angle) * dist,
        center.dy + math.sin(angle) * dist,
      );
      final paint = Paint()
        ..color = palette[i % palette.length]
        ..style = PaintingStyle.fill;

      if (i.isEven) {
        canvas.drawCircle(pt, 2.8, paint);
      } else {
        canvas.save();
        canvas.translate(pt.dx, pt.dy);
        canvas.rotate(math.pi / 4);
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: 4.8, height: 4.8),
          paint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GeometricBurstPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.primaryColor != primaryColor;
}


// =============================================================================
// PEACH POP WIDGETS (customer app)
// =============================================================================

// ---------------------------------------------------------------------------
// ACCENT GRADIENT BUTTON
// ---------------------------------------------------------------------------

/// Primary CTA button with the accent gradient (135°), accent glow shadow,
/// press-scale feedback, and light haptic.
///
/// Spec: 56 dp height, pill shape, gradient fill, [QText.labelL] in onAccent,
/// [QElevation.lightAccentGlow] shadow, 0.97 press scale, light haptic.
class AccentGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AccentGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final seva = Theme.of(context).extension<QSevaColors>();
    final gradient = seva?.accentGradient ??
        const LinearGradient(colors: [Color(0xFFFF9E80), Color(0xFFFFC857)]);
    final onAccent = seva?.onAccent ?? const Color(0xFF33201C);
    final glow = seva?.accentGlow ?? QElevation.lightAccentGlow;
    final disabled = onPressed == null && !isLoading;

    return PressableScale(
      onTap: disabled ? null : onPressed,
      pressedScale: QMotion.pressScale,
      child: AnimatedOpacity(
        opacity: disabled ? 0.5 : 1.0,
        duration: QMotion.fast,
        child: Container(
          height: 56,
          constraints: const BoxConstraints(minWidth: 120),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(QRadius.pill),
            boxShadow: disabled ? null : glow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: onAccent,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: onAccent, size: 20),
                      const SizedBox(width: QSpace.xs),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: QText.labelL.copyWith(color: onAccent),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SECONDARY BUTTON
// ---------------------------------------------------------------------------

/// Secondary button: pill, surface fill, ink label, border, e1 shadow.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final seva = Theme.of(context).extension<QSevaColors>();
    final surface = seva?.surface ?? Colors.white;
    final ink = seva?.ink ?? const Color(0xFF33201C);
    final border = seva?.border ?? Colors.grey.shade300;
    final e1 = seva?.e1 ?? QElevation.lightE1;
    final disabled = onPressed == null;

    return PressableScale(
      onTap: disabled ? null : onPressed,
      pressedScale: QMotion.pressScale,
      child: AnimatedOpacity(
        opacity: disabled ? 0.5 : 1.0,
        duration: QMotion.fast,
        child: Container(
          height: 52,
          constraints: const BoxConstraints(minWidth: 100),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(QRadius.pill),
            border: Border.all(color: border),
            boxShadow: disabled ? null : e1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: ink, size: 18),
                const SizedBox(width: QSpace.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: QText.labelL.copyWith(color: ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GHOST BUTTON
// ---------------------------------------------------------------------------

/// Ghost button: pill, transparent fill, ink label, no shadow.
class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final seva = Theme.of(context).extension<QSevaColors>();
    final ink = seva?.ink ?? const Color(0xFF33201C);
    final disabled = onPressed == null;

    return PressableScale(
      onTap: disabled ? null : onPressed,
      pressedScale: QMotion.pressScale,
      child: AnimatedOpacity(
        opacity: disabled ? 0.5 : 1.0,
        duration: QMotion.fast,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: ink, size: 18),
                const SizedBox(width: QSpace.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: QText.label.copyWith(color: ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CATEGORY TILE (Peach Pop home grid)
// ---------------------------------------------------------------------------

/// Category tile with pastel support background, icon, label, and e2 shadow.
///
/// Rotate [backgroundColor] through [QSevaColors.supportColor] so the home
/// grid is colourful, not just peach.
class QCategoryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const QCategoryTile({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final seva = Theme.of(context).extension<QSevaColors>();
    final ink = seva?.ink ?? const Color(0xFF33201C);
    final e2 = seva?.e2 ?? QElevation.lightE2;

    return PressableScale(
      onTap: onTap,
      pressedScale: QMotion.pressScale,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(QRadius.tile),
          boxShadow: e2,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: ink.withValues(alpha: 0.7)),
            const SizedBox(height: QSpace.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: QText.label.copyWith(color: ink),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// GLASS SEARCH BAR (Peach Pop home)
// ---------------------------------------------------------------------------

/// Tappable search bar with glassmorphism (or opaque fallback).
class QGlassSearchBar extends StatelessWidget {
  final String hintPrefix;
  final List<String> hints;
  final VoidCallback? onTap;

  const QGlassSearchBar({
    super.key,
    this.hintPrefix = 'Search for ',
    this.hints = const ['AC repair', 'cleaning', 'electrician', 'plumber'],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final seva = Theme.of(context).extension<QSevaColors>();
    final inkMuted = seva?.inkMuted ?? const Color(0xFFB39B92);

    return PressableScale(
      onTap: onTap,
      pressedScale: QMotion.pressScale,
      child: GlassSurface(
        borderRadius: QRadius.pill,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        boxShadow: seva?.e1,
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: inkMuted, size: 22),
            const SizedBox(width: QSpace.sm),
            Expanded(
              child: RotatingHintText(
                prefix: hintPrefix,
                hints: hints,
                style: QText.body.copyWith(color: inkMuted),
                highlightStyle: QText.body.copyWith(
                  color: seva?.inkSecondary ?? inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// STAR RATING (Peach Pop rating screen)
// ---------------------------------------------------------------------------

/// Interactive star rating with bouncy spring animation and haptic feedback.
class QStarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onChanged;
  final double starSize;

  const QStarRating({
    super.key,
    required this.rating,
    this.onChanged,
    this.starSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final seva = Theme.of(context).extension<QSevaColors>();
    final fillColor = seva?.accentStart ?? const Color(0xFFFF9E80);
    final emptyColor = seva?.border ?? Colors.grey.shade300;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return GestureDetector(
          onTap: onChanged != null
              ? () {
                  HapticFeedback.lightImpact();
                  onChanged!(i + 1);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TweenAnimationBuilder<double>(
              key: ValueKey('star_${i}_$filled'),
              tween: Tween(begin: filled ? 0.5 : 1.0, end: 1.0),
              duration: QMotion.of(context, QMotion.base),
              curve: QMotion.spring,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Icon(
                filled ? Icons.star_rounded : Icons.star_outline_rounded,
                color: filled ? fillColor : emptyColor,
                size: starSize,
                semanticLabel: 'Rate ${i + 1} of 5 stars',
              ),
            ),
          ),
        );
      }),
    );
  }
}
