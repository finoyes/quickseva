import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'theme.dart';
import 'tokens.dart';

/// ============================================================================
/// QUICKSEVA MOTION LIBRARY
/// Micro-interaction patterns inspired by Dribbble / Jitter / 60fps.design
/// shots, rebuilt natively with flat solid colours (zero gradients).
/// Every widget here honours the OS "reduce motion" setting via [QMotion].
/// ============================================================================

// -----------------------------------------------------------------------------
// 1. FLOATING MORPHING NAV BAR
// -----------------------------------------------------------------------------

class QNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badgeCount;

  const QNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
  });
}

/// Floating bottom navigation with a sliding pill indicator that stretches
/// toward the target tab, a springy icon bounce, and an expanding label.
class QFloatingNavBar extends StatelessWidget {
  final List<QNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color backgroundColor;
  final Color indicatorColor;
  final Color activeColor;
  final Color inactiveColor;

  const QFloatingNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.backgroundColor = QColors.deepSlate,
    this.indicatorColor = QColors.primaryGreen,
    this.activeColor = Colors.white,
    this.inactiveColor = const Color(0xFF94A3B8),
  });

  @override
  Widget build(BuildContext context) {
    final duration = QMotion.of(context, QMotion.slow);
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(QRadius.xl),
            boxShadow: QTheme.darkSlateShadow,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const selectedFlex = 1.7;
              final total = (items.length - 1) + selectedFlex;
              final unit = constraints.maxWidth / total;
              final selectedWidth = unit * selectedFlex;
              final left = unit * selectedIndex;

              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: duration,
                    curve: QMotion.standard,
                    left: left,
                    top: 0,
                    bottom: 0,
                    width: selectedWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        borderRadius: BorderRadius.circular(QRadius.lg),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(items.length, (i) {
                      final selected = i == selectedIndex;
                      return AnimatedContainer(
                        duration: duration,
                        curve: QMotion.standard,
                        width: selected ? selectedWidth : unit,
                        child: _NavButton(
                          item: items[i],
                          selected: selected,
                          activeColor: activeColor,
                          inactiveColor: inactiveColor,
                          onTap: () => onSelected(i),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final QNavItem item;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? activeColor : inactiveColor;
    final duration = QMotion.of(context, QMotion.base);
    final icon = TweenAnimationBuilder<double>(
      key: ValueKey(selected),
      tween: Tween(begin: selected ? 0.6 : 1.0, end: 1.0),
      duration: QMotion.of(context, QMotion.slow),
      curve: Curves.elasticOut,
      builder: (context, s, child) => Transform.scale(scale: s, child: child),
      child: Icon(
        selected ? item.selectedIcon : item.icon,
        color: color,
        size: 22,
      ),
    );

    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        radius: 36,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: item.badgeCount > 0,
                label: Text('${item.badgeCount}'),
                backgroundColor: QColors.karmicOrange,
                child: icon,
              ),
              Flexible(
                child: ClipRect(
                  child: AnimatedAlign(
                    alignment: Alignment.centerLeft,
                    widthFactor: selected ? 1.0 : 0.0,
                    duration: duration,
                    curve: QMotion.standard,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          color: color,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

// -----------------------------------------------------------------------------
// 2. SKELETON LOADERS + FADING NETWORK IMAGE
// -----------------------------------------------------------------------------

/// Flat skeleton block that breathes between two solid tints
/// (a gradient-free alternative to shimmer).
class PulseSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double radius;
  final Color baseColor;
  final Color highlightColor;

  const PulseSkeleton({
    super.key,
    this.width,
    this.height,
    this.radius = QRadius.md,
    this.baseColor = QColors.warmIvorySurface,
    this.highlightColor = QColors.warmIvoryHighlight,
  });

  @override
  State<PulseSkeleton> createState() => _PulseSkeletonState();
}

class _PulseSkeletonState extends State<PulseSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (QMotion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color.lerp(
            widget.baseColor,
            widget.highlightColor,
            Curves.easeInOut.transform(_c.value),
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// Network image with a pulsing skeleton placeholder, a soft fade + scale-in
/// once decoded, and an icon fallback on error.
class QNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;

  const QNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.borderRadius,
    this.fallbackIcon = Icons.home_repair_service_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final reduced = QMotion.reduced(context);
    final effectiveRadius =
        borderRadius ?? (radius > 0 ? BorderRadius.circular(radius) : null);
    final skeletonRadius =
        radius > 0 ? radius : (borderRadius?.topLeft.x ?? 0);
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSyncLoaded) {
        if (wasSyncLoaded || reduced) return child;
        final loaded = frame != null;
        return Stack(
          fit: StackFit.passthrough,
          children: [
            if (!loaded)
              Positioned.fill(child: PulseSkeleton(radius: skeletonRadius)),
            AnimatedOpacity(
              opacity: loaded ? 1 : 0,
              duration: QMotion.slow,
              curve: QMotion.standard,
              child: AnimatedScale(
                scale: loaded ? 1 : 1.06,
                duration: QMotion.emphasized,
                curve: QMotion.enter,
                child: child,
              ),
            ),
          ],
        );
      },
      errorBuilder: (_, _, _) => Container(
        width: width,
        height: height,
        color: QColors.warmIvorySurface,
        alignment: Alignment.center,
        child: Icon(fallbackIcon, color: QColors.primaryGreen),
      ),
    );
    if (effectiveRadius == null) return image;
    return ClipRRect(
      borderRadius: effectiveRadius,
      child: image,
    );
  }
}

// -----------------------------------------------------------------------------
// 3. ROTATING SEARCH HINT
// -----------------------------------------------------------------------------

/// Cycles through [hints] with a vertical slide + fade, like the animated
/// search placeholders in Swiggy / Blinkit / Urban Company.
class RotatingHintText extends StatefulWidget {
  final String prefix;
  final List<String> hints;
  final TextStyle style;
  final TextStyle? highlightStyle;
  final Duration interval;

  const RotatingHintText({
    super.key,
    required this.prefix,
    required this.hints,
    required this.style,
    this.highlightStyle,
    this.interval = const Duration(milliseconds: 2400),
  });

  @override
  State<RotatingHintText> createState() => _RotatingHintTextState();
}

class _RotatingHintTextState extends State<RotatingHintText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cycle = AnimationController(
    vsync: this,
    duration: widget.interval,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          mounted &&
          widget.hints.isNotEmpty) {
        setState(() => _index = (_index + 1) % widget.hints.length);
        if (!QMotion.reduced(context)) {
          _cycle.forward(from: 0);
        }
      }
    });
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (QMotion.reduced(context)) {
      _cycle.stop();
    } else if (!_cycle.isAnimating) {
      _cycle.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _cycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hint = widget.hints.isEmpty ? '' : widget.hints[_index];
    return Row(
      children: [
        Text(widget.prefix, style: widget.style),
        Expanded(
          child: ClipRect(
            child: AnimatedSwitcher(
              duration: QMotion.of(context, QMotion.slow),
              switchInCurve: QMotion.enter,
              switchOutCurve: QMotion.exit,
              transitionBuilder: (child, anim) {
                final incoming = child.key == ValueKey(hint);
                final offset = Tween<Offset>(
                  begin: Offset(0, incoming ? 0.9 : -0.9),
                  end: Offset.zero,
                ).animate(anim);
                return FadeTransition(
                  opacity: anim,
                  child: SlideTransition(position: offset, child: child),
                );
              },
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.centerLeft,
                children: [...previous, ?current],
              ),
              child: Text(
                hint,
                key: ValueKey(hint),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: widget.highlightStyle ?? widget.style,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. AUTO-ADVANCING PROMO CAROUSEL
// -----------------------------------------------------------------------------

/// Auto-advancing PageView with depth scaling on neighbouring slides and a
/// morphing "expanding pill" indicator that fills as the timer runs.
class PromoCarousel extends StatefulWidget {
  final List<Widget> slides;
  final double height;
  final Duration interval;
  final Color activeColor;
  final Color inactiveColor;

  const PromoCarousel({
    super.key,
    required this.slides,
    this.height = 176,
    this.interval = const Duration(seconds: 4),
    this.activeColor = QColors.primaryGreen,
    this.inactiveColor = QColors.borderStrong,
  });

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel>
    with SingleTickerProviderStateMixin {
  final PageController _page = PageController(viewportFraction: 0.9);
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: widget.interval,
  )..addStatusListener(_onProgressStatus);
  int _index = 0;

  void _onProgressStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    if (!_page.hasClients) return;
    final next = (_index + 1) % widget.slides.length;
    _page.animateToPage(
      next,
      duration: QMotion.emphasized,
      curve: QMotion.standard,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (QMotion.reduced(context)) {
      _progress.stop();
    } else if (!_progress.isAnimating) {
      _progress.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollStartNotification && n.dragDetails != null) {
                _progress.stop();
              } else if (n is ScrollEndNotification &&
                  !QMotion.reduced(context)) {
                _progress.forward(from: 0);
              }
              return false;
            },
            child: PageView.builder(
              controller: _page,
              itemCount: widget.slides.length,
              onPageChanged: (i) {
                setState(() => _index = i);
                if (!QMotion.reduced(context)) {
                  _progress.forward(from: 0);
                }
              },
              itemBuilder: (context, i) {
                return AnimatedBuilder(
                  animation: _page,
                  builder: (context, child) {
                    double delta = 0;
                    if (_page.hasClients && _page.position.haveDimensions) {
                      delta = ((_page.page ?? 0) - i).clamp(-1.0, 1.0);
                    } else {
                      delta = (i - _index).toDouble().clamp(-1.0, 1.0);
                    }
                    final scale = 1 - (delta.abs() * 0.06);
                    return Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: 1 - (delta.abs() * 0.35),
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: widget.slides[i],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: QSpace.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.slides.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: QMotion.of(context, QMotion.base),
              curve: QMotion.standard,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 26 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: widget.inactiveColor,
                borderRadius: BorderRadius.circular(QRadius.pill),
              ),
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.centerLeft,
              child: active
                  ? AnimatedBuilder(
                      animation: _progress,
                      builder: (context, _) => FractionallySizedBox(
                        widthFactor: QMotion.reduced(context)
                            ? 1
                            : math.max(0.18, _progress.value),
                        heightFactor: 1,
                        child: ColoredBox(color: widget.activeColor),
                      ),
                    )
                  : null,
            );
          }),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 5. STAGGERED ENTRANCE
// -----------------------------------------------------------------------------

/// Fades and slides its child up once on first build, delayed by [index].
class StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration stagger;
  final double offsetY;

  const StaggeredEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.stagger = const Duration(milliseconds: 60),
    this.offsetY = 18,
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final int _delayMs =
      widget.stagger.inMilliseconds * math.min(widget.index, 8).toInt();
  late final int _totalMs = _delayMs + QMotion.emphasized.inMilliseconds;
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _totalMs),
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Interval(
      (_delayMs / _totalMs).clamp(0.0, 0.75),
      1.0,
      curve: QMotion.enter,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (QMotion.reduced(context)) {
      _c.value = 1;
      return;
    }
    if (_c.isDismissed) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) => Opacity(
        opacity: _t.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _t.value) * widget.offsetY),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

// -----------------------------------------------------------------------------
// 6. DRAW-ON SUCCESS CHECKMARK
// -----------------------------------------------------------------------------

/// Circle stroke draws on, fills, then the tick strokes in with a pop.
class AnimatedCheckmark extends StatefulWidget {
  final double size;
  final Color color;
  final Color tickColor;

  const AnimatedCheckmark({
    super.key,
    this.size = 72,
    this.color = QColors.primaryGreen,
    this.tickColor = Colors.white,
  });

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (QMotion.reduced(context)) {
      _c.value = 1;
    } else if (_c.isDismissed) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final pop = TweenSequence<double>([
          TweenSequenceItem(tween: ConstantTween(1.0), weight: 55),
          TweenSequenceItem(
            tween: Tween(begin: 1.0, end: 1.12)
                .chain(CurveTween(curve: Curves.easeOut)),
            weight: 20,
          ),
          TweenSequenceItem(
            tween: Tween(begin: 1.12, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutBack)),
            weight: 25,
          ),
        ]).transform(_c.value);
        return Transform.scale(
          scale: pop,
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _CheckPainter(
              t: _c.value,
              color: widget.color,
              tickColor: widget.tickColor,
            ),
          ),
        );
      },
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double t;
  final Color color;
  final Color tickColor;

  _CheckPainter({
    required this.t,
    required this.color,
    required this.tickColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 3;

    final ring = (t / 0.45).clamp(0.0, 1.0);
    final fill = ((t - 0.35) / 0.25).clamp(0.0, 1.0);
    final tick = ((t - 0.55) / 0.4).clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * Curves.easeOut.transform(ring),
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    if (fill > 0) {
      canvas.drawCircle(
        c,
        r * Curves.easeOutBack.transform(fill),
        Paint()..color = color,
      );
    }
    if (tick > 0) {
      final path = Path()
        ..moveTo(size.width * 0.29, size.height * 0.52)
        ..lineTo(size.width * 0.44, size.height * 0.66)
        ..lineTo(size.width * 0.72, size.height * 0.37);
      final metric = path.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(
          0,
          metric.length * Curves.easeOutCubic.transform(tick),
        ),
        Paint()
          ..color = tickColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.085
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) =>
      old.t != t || old.color != color || old.tickColor != tickColor;
}

// -----------------------------------------------------------------------------
// 7. SECTION HEADER
// -----------------------------------------------------------------------------

/// Consistent section title with an optional subtitle and trailing action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Key? actionKey;
  final TextStyle? titleStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.actionKey,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titleStyle ?? QText.section,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: QText.caption.copyWith(fontSize: 13),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(width: QSpace.xs),
          _SectionAction(
            key: actionKey,
            label: actionLabel!,
            icon: actionIcon ?? Icons.arrow_forward_rounded,
            onTap: onAction!,
          ),
        ],
      ],
    );
  }
}

class _SectionAction extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SectionAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SectionAction> createState() => _SectionActionState();
}

class _SectionActionState extends State<_SectionAction> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: QColors.primaryGreen,
                ),
              ),
              AnimatedSlide(
                duration: QMotion.of(context, QMotion.fast),
                offset: Offset(_hover ? 0.25 : 0, 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Icon(
                    widget.icon,
                    size: 15,
                    color: QColors.primaryGreen,
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

// -----------------------------------------------------------------------------
// 8. INFINITE MARQUEE (trust strip)
// -----------------------------------------------------------------------------

/// Continuously scrolling horizontal strip (pauses under reduce-motion).
class QMarquee extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final double pixelsPerSecond;
  final double gap;

  const QMarquee({
    super.key,
    required this.children,
    this.height = 34,
    this.pixelsPerSecond = 28,
    this.gap = 10,
  });

  @override
  State<QMarquee> createState() => _QMarqueeState();
}

class _QMarqueeState extends State<QMarquee>
    with SingleTickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();
  late final Ticker _ticker = createTicker(_tick);
  Duration _last = Duration.zero;

  void _tick(Duration now) {
    final dt = math.max(0, (now - _last).inMicroseconds) / 1e6;
    _last = now;
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    if (max <= 0) return;
    var next = _scroll.offset + widget.pixelsPerSecond * dt;
    final half = (max + _scroll.position.viewportDimension + widget.gap) / 2;
    if (next >= half) next -= half;
    _scroll.jumpTo(next.clamp(0.0, max));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (QMotion.reduced(context)) {
      if (_ticker.isActive) _ticker.stop();
    } else if (!_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [...widget.children, ...widget.children];
    return SizedBox(
      height: widget.height,
      child: ListView.separated(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: widget.gap),
        itemBuilder: (_, i) => Center(child: items[i]),
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// 9. MOTION POLICY (Peach Pop)
// ---------------------------------------------------------------------------

/// Central motion policy provider. Wraps the app to provide reduced-motion
/// and low-end device detection from a single [InheritedWidget].
///
/// Usage: `MotionPolicy.shouldAnimate(context)`.
class MotionPolicy extends InheritedWidget {
  /// True when the OS requests reduced motion.
  final bool isReduced;

  /// True on low-end devices where blur/heavy animation should be avoided.
  final bool isLowEnd;

  const MotionPolicy({
    super.key,
    required this.isReduced,
    this.isLowEnd = false,
    required super.child,
  });

  /// Wraps the app, reading the OS reduced-motion flag automatically.
  static Widget wrap({required Widget child}) {
    return _MotionPolicyAuto(child: child);
  }

  static MotionPolicy? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MotionPolicy>();

  static MotionPolicy of(BuildContext context) {
    final policy = maybeOf(context);
    assert(policy != null, 'No MotionPolicy found in context');
    return policy!;
  }

  /// Whether animations should play.
  static bool shouldAnimate(BuildContext context) {
    final policy = maybeOf(context);
    if (policy != null) return !policy.isReduced;
    return !QMotion.reduced(context); // fallback
  }

  /// Whether the device can handle blur/glass.
  /// Set to false to prioritize solid 60/120fps UI performance without GPU fillrate stalls.
  static bool canBlur(BuildContext context) {
    return false;
  }

  /// Returns [d] or a 120 ms fade when reduced motion is active.
  static Duration duration(BuildContext context, Duration d) {
    return shouldAnimate(context) ? d : const Duration(milliseconds: 120);
  }

  @override
  bool updateShouldNotify(MotionPolicy oldWidget) =>
      isReduced != oldWidget.isReduced || isLowEnd != oldWidget.isLowEnd;
}

class _MotionPolicyAuto extends StatelessWidget {
  final Widget child;
  const _MotionPolicyAuto({required this.child});

  @override
  Widget build(BuildContext context) {
    final reduced = QMotion.reduced(context);
    // Heuristic: low-end if device pixel ratio <= 2 and short dimension < 360
    final mq = MediaQuery.maybeOf(context);
    final lowEnd = mq != null &&
        mq.devicePixelRatio <= 2.0 &&
        mq.size.shortestSide < 360;
    return MotionPolicy(
      isReduced: reduced,
      isLowEnd: lowEnd,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// 10. GLASS SURFACE (Peach Pop)
// ---------------------------------------------------------------------------

/// Glassmorphism surface with automatic opaque fallback on low-end devices.
///
/// Uses [QGlass] tokens for blur, fill, border, and hairline.
/// Falls back to opaque surface with border when [MotionPolicy.canBlur] is
/// false or when no [MotionPolicy] ancestor exists and reduced motion is on.
class GlassSurface extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;

  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = QRadius.lg,
    this.padding,
    this.margin,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glass = isDark ? QGlass.dark : QGlass.light;
    final canBlur = MotionPolicy.canBlur(context);
    final seva = Theme.of(context).extension<QSevaColors>();
    final opaqueColor = seva?.surface ?? Colors.white;

    final br = BorderRadius.circular(borderRadius);

    final innerChild = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: canBlur
            ? glass.fill
            : (isDark
                ? (seva?.surface ?? const Color(0xFF1E1E24)).withValues(alpha: 0.88)
                : Colors.white.withValues(alpha: 0.92)),
        borderRadius: br,
        border: Border.all(
          color: canBlur
              ? glass.border
              : (isDark
                  ? Colors.white.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.85)),
          width: glass.borderWidth,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top highlight line for specular rim light
          Container(
            height: 0.5,
            margin: EdgeInsets.symmetric(horizontal: borderRadius * 0.3),
            decoration: BoxDecoration(
              color: glass.topHighlight,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          Flexible(child: child),
        ],
      ),
    );

    Widget result;
    if (canBlur) {
      result = ClipRRect(
        borderRadius: br,
        child: RepaintBoundary(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: glass.blurSigma,
              sigmaY: glass.blurSigma,
            ),
            child: innerChild,
          ),
        ),
      );
    } else {
      result = ClipRRect(borderRadius: br, child: innerChild);
    }

    if (margin != null || boxShadow != null) {
      result = Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: br,
          boxShadow: boxShadow,
        ),
        child: result,
      );
    }

    return result;
  }
}

// ---------------------------------------------------------------------------
// 11. PASTEL BACKDROP (Peach Pop)
// ---------------------------------------------------------------------------

/// Static pre-blurred pastel blob background.
///
/// Paints the four backdrop blobs from `design_tokens.json` once using a
/// [CustomPainter] with [MaskFilter.blur]. Never uses live
/// [BackdropFilter], so it is GPU-cheap.
class PastelBackdrop extends StatelessWidget {
  const PastelBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final seva = Theme.of(context).extension<QSevaColors>();
    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _PastelBlobPainter(
              isDark: isDark,
              rose: seva?.rose ?? const Color(0xFFFFD6E4),
              lilac: seva?.lilac ?? const Color(0xFFE6D9FF),
              sky: seva?.sky ?? const Color(0xFFCFE6FF),
              peachTint: seva?.peachTint ?? const Color(0xFFFFE3D6),
            ),
          ),
        ),
      ),
    );
  }
}

class _PastelBlobPainter extends CustomPainter {
  final bool isDark;
  final Color rose;
  final Color lilac;
  final Color sky;
  final Color peachTint;

  const _PastelBlobPainter({
    required this.isDark,
    required this.rose,
    required this.lilac,
    required this.sky,
    required this.peachTint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final blobs = [
      _Blob(rose,    0.05, 0.02, 0.55, 90, isDark ? 0.30 : 0.75),
      _Blob(lilac,   0.95, 0.12, 0.50, 90, isDark ? 0.28 : 0.70),
      _Blob(sky,     0.50, 0.45, 0.45, 100, isDark ? 0.22 : 0.55),
      _Blob(peachTint, 0.15, 0.85, 0.50, 100, isDark ? 0.25 : 0.80),
    ];

    for (final b in blobs) {
      final center = Offset(size.width * b.x, size.height * b.y);
      final radius = size.width * b.radiusFrac;
      final paint = Paint()
        ..color = b.color.withValues(alpha: b.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, b.blurPx);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PastelBlobPainter old) =>
      isDark != old.isDark;
}

class _Blob {
  final Color color;
  final double x;
  final double y;
  final double radiusFrac;
  final double blurPx;
  final double opacity;
  const _Blob(this.color, this.x, this.y, this.radiusFrac, this.blurPx,
      this.opacity);
}

// ---------------------------------------------------------------------------
// 12. FLOATING ASSET (Peach Pop – 3D icon float loop)
// ---------------------------------------------------------------------------

/// Animates a child widget (typically a 3D WebP icon) in a gentle vertical
/// float loop with a scaling shadow ellipse underneath.
///
/// Respects reduced motion: freezes at midpoint. Pauses when not visible via
/// [TickerMode].
class FloatingAsset extends StatefulWidget {
  final Widget child;
  final double size;

  const FloatingAsset({
    super.key,
    required this.child,
    this.size = 64,
  });

  @override
  State<FloatingAsset> createState() => _FloatingAssetState();
}

class _FloatingAssetState extends State<FloatingAsset>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: QMotion.floatPeriod,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (QMotion.reduced(context)) {
      _c.value = 0.25; // midpoint
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size + QMotion.floatAmplitude + 8,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) {
          final t = math.sin(_c.value * 2 * math.pi);
          final dy = t * QMotion.floatAmplitude;
          final shadowScale = QMotion.floatShadowMin +
              (QMotion.floatShadowMax - QMotion.floatShadowMin) *
                  ((1 - t) / 2); // inverse: shadow shrinks when icon rises
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: Offset(0, dy),
                child: child!,
              ),
              const SizedBox(height: 4),
              Transform.scale(
                scaleX: shadowScale,
                child: Container(
                  width: widget.size * 0.5,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(QRadius.pill),
                  ),
                ),
              ),
            ],
          );
        },
        child: SizedBox.square(
          dimension: widget.size,
          child: widget.child,
        ),
      ),
    );
  }
}
