import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double radius;
  double speed;
  double opacity;
  double drift;

  Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.drift,
  });
}

class ParticleBackground extends StatefulWidget {
  final Color particleColor;
  final int count;

  const ParticleBackground({
    super.key,
    required this.particleColor,
    this.count = 40,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        _updateParticles();
      });
    _controller.repeat();
  }

  void _initParticles(Size size) {
    if (_initialized) return;
    for (int i = 0; i < widget.count; i++) {
      _particles.add(Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        radius: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 0.5 + 0.2, // Slow upward flow
        opacity: _random.nextDouble() * 0.4 + 0.1,
        drift: _random.nextDouble() * 2 - 1, // Slight horizontal sway
      ));
    }
    _initialized = true;
  }

  void _updateParticles() {
    if (!_initialized) return;
    for (var particle in _particles) {
      particle.y -= particle.speed;
      particle.x += sin(particle.y * 0.01) * particle.drift * 0.5;

      if (particle.y < -10) {
        particle.y = MediaQuery.of(context).size.height + 10;
        particle.x = _random.nextDouble() * MediaQuery.of(context).size.width;
      }
    }
    // Optimization: Just call setState without deep payload if the painter already checks changes.
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size);
        return CustomPaint(
          size: size,
          painter: _ParticlePainter(_particles, widget.particleColor),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color baseColor;

  _ParticlePainter(this.particles, this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = baseColor.withValues(alpha: particle.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0); // Soft glowing orbs

      canvas.drawCircle(Offset(particle.x, particle.y), particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true; // Constantly animating
}
