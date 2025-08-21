import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';

class AppLogoBounce extends StatefulWidget {
  const AppLogoBounce({super.key});

  @override
  State<AppLogoBounce> createState() => _AppLogoBounceState();
}

class _AppLogoBounceState extends State<AppLogoBounce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(); // infinite
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        // Vertical bounce path using sine (smooth up/down)
        final dy = -32 * math.sin(math.pi * t); // 0 bottom, peak at mid
        // Squash/stretch near bottom & subtle stretch near top
        var sx = 1.0;
        var sy = 1.0;
        const edgeThreshold = 0.08;
        if (t < edgeThreshold || t > 1 - edgeThreshold) {
          // Impact at bottom
          sx = 1.06;
          sy = 0.92;
        } else if ((t - 0.5).abs() < edgeThreshold) {
          // Light stretch at apex
          sx = 0.97;
          sy = 1.03;
        }
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, dy)
            ..scale(sx, sy),
          child: const AppLogoIcon(size: 72),
        );
      },
    );
  }
}
