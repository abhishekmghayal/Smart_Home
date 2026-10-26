import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedAqiMeter extends StatefulWidget {
  final double aqiValue;
  final double maxAqi;
  final Color meterColor;

  const AnimatedAqiMeter({
    super.key,
    required this.aqiValue,
    required this.meterColor,
    this.maxAqi = 150, 
  });

  @override
  State<AnimatedAqiMeter> createState() => _AnimatedAqiMeterState();
}

class _AnimatedAqiMeterState extends State<AnimatedAqiMeter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 0, end: widget.aqiValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedAqiMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.aqiValue != widget.aqiValue) {
      _animation = Tween<double>(begin: _animation.value, end: widget.aqiValue).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(120, 120),
          painter: _AqiPainter(
            currentAqi: _animation.value,
            maxAqi: widget.maxAqi,
            progressColor: widget.meterColor,
          ),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _animation.value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    height: 1.1,
                  ),
                ),
                const Text(
                  'AQI',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AqiPainter extends CustomPainter {
  final double currentAqi;
  final double maxAqi;
  final Color progressColor;

  _AqiPainter({
    required this.currentAqi,
    required this.maxAqi,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 10.0;

    final basePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const startAngle = pi * 0.75; // Starts bottom left
    const sweepAngle = pi * 1.5; // Goes around to bottom right

    // Draw background track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      basePaint,
    );

    // Draw progress track
    double progress = (currentAqi / maxAqi).clamp(0.0, 1.0);
    final progressSweepAngle = progress * sweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressSweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AqiPainter oldDelegate) {
    return oldDelegate.currentAqi != currentAqi;
  }
}
