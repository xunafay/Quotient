import 'package:flutter/material.dart';

import 'lava_painter.dart';

/// Lava clock.
class LavaAnimation extends StatefulWidget {
  const LavaAnimation({
    super.key,
    required this.child,
    this.color,
  });
  final Widget child;
  final Color? color;

  @override
  LavaAnimationState createState() => LavaAnimationState();
}

class LavaAnimationState extends State<LavaAnimation>
    with TickerProviderStateMixin {
  Lava lava = Lava(7);
  late final AnimationController _animation =
      AnimationController(duration: const Duration(minutes: 10), vsync: this)
        ..repeat();

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, _) => CustomPaint(
          size: const Size(100, 100),
          painter: LavaPainter(
            lava,
            color: widget.color ?? Theme.of(context).colorScheme.primary,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}