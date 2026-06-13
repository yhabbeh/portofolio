import 'dart:math';
import 'package:flutter/material.dart';

class ParticleOverlay extends StatefulWidget {
  final int particleCount;

  const ParticleOverlay({super.key, this.particleCount = 12});

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final ValueNotifier<Offset?> _mousePos = ValueNotifier<Offset?>(null);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
    _initParticles();
  }

  void _initParticles() {
    final random = Random();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3.0 + 1.2,
        speed: random.nextDouble() * 0.15 + 0.05,
        opacity: random.nextDouble() * 0.22 + 0.06,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _mousePos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: MouseRegion(
        onHover: (event) => _mousePos.value = event.localPosition,
        onEnter: (event) => _mousePos.value = event.localPosition,
        onExit: (_) => _mousePos.value = null,
        child: IgnorePointer(
          ignoring: true,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                progress: _controller.value,
                color: const Color(0xFF1B3A8B),
                mousePosNotifier: _mousePos,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;
  final ValueNotifier<Offset?> mousePosNotifier;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
    required this.mousePosNotifier,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    
    final mousePos = mousePosNotifier.value;
    final List<Offset> particlePositions = [];

    // Calculate positions, applying cursor repulsion
    for (final p in particles) {
      final xRaw = p.x * size.width;
      final yRaw = ((p.y - progress * p.speed) % 1.0) * size.height;

      double px = xRaw;
      double py = yRaw;

      if (mousePos != null) {
        final dx = px - mousePos.dx;
        final dy = py - mousePos.dy;
        final dist = sqrt(dx * dx + dy * dy);
        const maxDist = 130.0;

        if (dist < maxDist) {
          final force = (maxDist - dist) / maxDist;
          final angle = atan2(dy, dx);
          final pushX = cos(angle) * force * 20;
          final pushY = sin(angle) * force * 20;
          px += pushX;
          py += pushY;

          // Connection to cursor
          linePaint.color = color.withValues(alpha: force * 0.12);
          canvas.drawLine(Offset(px, py), mousePos, linePaint);
        }
      }

      particlePositions.add(Offset(px, py));
    }

    // Connect nearby particles
    for (int i = 0; i < particlePositions.length; i++) {
      final pi = particlePositions[i];
      for (int j = i + 1; j < particlePositions.length; j++) {
        final pj = particlePositions[j];
        final dx = pi.dx - pj.dx;
        final dy = pi.dy - pj.dy;
        final dist = sqrt(dx * dx + dy * dy);
        const maxConnectDist = 110.0;

        if (dist < maxConnectDist) {
          final opacityFactor = (1.0 - dist / maxConnectDist) * 0.07;
          linePaint.color = color.withValues(alpha: opacityFactor);
          canvas.drawLine(pi, pj, linePaint);
        }
      }
    }

    // Draw particles
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final pos = particlePositions[i];
      paint.color = color.withValues(alpha: p.opacity);
      canvas.drawCircle(pos, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}
