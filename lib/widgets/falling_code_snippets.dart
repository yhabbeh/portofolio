import 'dart:math';
import 'package:flutter/material.dart';

class FallingCodeSnippets extends StatefulWidget {
  const FallingCodeSnippets({super.key});

  @override
  State<FallingCodeSnippets> createState() => _FallingCodeSnippetsState();
}

class _FallingCodeSnippetsState extends State<FallingCodeSnippets>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_CodeSnippetParticle> _particles = [];
  final Random _random = Random();
  double _width = 1000;
  double _height = 800;

  static const List<String> _symbols = [
    '</>', '{}', '[]', '#', 'JS', 'const', '=>', 'import', '&&', '||', 'Dart', 'BLoC'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(_updatePhysics);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < 20; i++) {
      _particles.add(_createParticle(initial: true));
    }
  }

  _CodeSnippetParticle _createParticle({bool initial = false}) {
    final symbol = _symbols[_random.nextInt(_symbols.length)];
    final speed = _random.nextDouble() * 50.0 + 35.0; // 35 to 85 px/s
    final scale = _random.nextDouble() * 0.4 + 0.7; // 0.7 to 1.1 scale
    final opacity = _random.nextDouble() * 0.35 + 0.15; // 0.15 to 0.5 opacity
    
    final x = _random.nextDouble() * _width;
    final y = initial 
        ? _random.nextDouble() * _height 
        : -50.0 - _random.nextDouble() * 150.0;

    return _CodeSnippetParticle(
      x: x,
      y: y,
      symbol: symbol,
      speed: speed,
      scale: scale,
      opacity: opacity,
      rotAngle: _random.nextDouble() * pi * 2,
      rotSpeed: _random.nextDouble() * 1.5 + 0.5, // 0.5 to 2.0 rad/s
      rx: _random.nextDouble(),
      ry: _random.nextDouble(),
      rz: _random.nextDouble(),
    );
  }

  void _resetParticle(_CodeSnippetParticle p) {
    p.y = -50.0 - _random.nextDouble() * 100.0;
    p.x = _random.nextDouble() * _width;
    p.rotAngle = _random.nextDouble() * pi * 2;
  }

  void _updatePhysics() {
    if (!mounted) return;
    const double dt = 0.016;

    setState(() {
      for (final p in _particles) {
        p.y += p.speed * dt;
        p.rotAngle += p.rotSpeed * dt;

        if (p.y > _height + 50) {
          _resetParticle(p);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color textColor = isDark 
        ? theme.colorScheme.primary.withAlpha(90)
        : theme.colorScheme.primary.withAlpha(60);

    return LayoutBuilder(
      builder: (context, constraints) {
        // If dimensions change, re-initialize particles
        if (_particles.isEmpty || _width != constraints.maxWidth || _height != constraints.maxHeight) {
          _width = constraints.maxWidth;
          _height = constraints.maxHeight;
          _initParticles();
        }

        return CustomPaint(
          painter: _SnippetsPainter(
            particles: _particles,
            textColor: textColor,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _CodeSnippetParticle {
  double x;
  double y;
  final String symbol;
  final double speed;
  final double scale;
  final double opacity;
  double rotAngle;
  final double rotSpeed;
  final double rx, ry, rz; // 3D rotation axes

  _CodeSnippetParticle({
    required this.x,
    required this.y,
    required this.symbol,
    required this.speed,
    required this.scale,
    required this.opacity,
    required this.rotAngle,
    required this.rotSpeed,
    required this.rx,
    required this.ry,
    required this.rz,
  });
}

class _SnippetsPainter extends CustomPainter {
  final List<_CodeSnippetParticle> particles;
  final Color textColor;

  _SnippetsPainter({required this.particles, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.save();
      
      // Translate to particle center
      canvas.translate(p.x, p.y);
      
      // Perform 3D-like rotation on the canvas!
      final matrix = Matrix4.identity()
        ..rotateX(p.rx * p.rotAngle)
        ..rotateY(p.ry * p.rotAngle)
        ..rotateZ(p.rz * p.rotAngle);
      canvas.transform(matrix.storage);

      // Scale the paint
      canvas.scale(p.scale);

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: p.symbol,
          style: TextStyle(
            color: textColor.withAlpha((p.opacity * 255).round()),
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_SnippetsPainter old) => true;
}
