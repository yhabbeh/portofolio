import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RoamingLottieCharacter extends StatefulWidget {
  const RoamingLottieCharacter({super.key});

  @override
  State<RoamingLottieCharacter> createState() => _RoamingLottieCharacterState();
}

class _RoamingLottieCharacterState extends State<RoamingLottieCharacter>
    with TickerProviderStateMixin {
  late final AnimationController _walkController;
  late final AnimationController _jumpController;
  late final AnimationController _spinController;

  double _x = -60.0;
  bool _faceLeft = false;
  double _screenWidth = 1000.0;
  static const double _speed = 55.0; // pixels per second

  @override
  void initState() {
    super.initState();
    
    // 1. Walking loop ticker
    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updatePhysics);
    _walkController.repeat();

    // 2. Transient Jump Controller
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // 3. Transient Spin Controller
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _walkController.dispose();
    _jumpController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _updatePhysics() {
    if (!mounted) return;
    const double dt = 0.016; // approx 1/60s

    setState(() {
      if (_faceLeft) {
        _x -= _speed * dt;
        if (_x < -80.0) {
          _x = -80.0;
          _faceLeft = false;
        }
      } else {
        _x += _speed * dt;
        if (_x > _screenWidth + 80.0) {
          _x = _screenWidth + 80.0;
          _faceLeft = true;
        }
      }
    });
  }

  void _triggerJump() {
    if (!_jumpController.isAnimating) {
      _jumpController.forward(from: 0.0);
    }
  }

  void _triggerSpin() {
    if (!_spinController.isAnimating) {
      _spinController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _screenWidth = constraints.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_jumpController, _spinController]),
              builder: (context, child) {
                // Jump translation curve
                final double jumpVal = _jumpController.value;
                final double jumpY = -sin(jumpVal * pi) * 45.0;

                // Spin rotation
                final double spinVal = _spinController.value;
                final double spinAngle = spinVal * pi * 2;

                Widget movingWidget = Transform.translate(
                  offset: Offset(_x, jumpY),
                  child: Transform.rotate(
                    angle: spinAngle,
                    child: child,
                  ),
                );

                // Flip Lottie animation direction
                if (_faceLeft) {
                  movingWidget = Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: movingWidget,
                  );
                }

                return movingWidget;
              },
              child: MouseRegion(
                onEnter: (_) => _triggerJump(),
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _triggerSpin(),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Lottie.network(
                      'https://assets5.lottiefiles.com/packages/lf20_yznclv8k.json',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Return a fallback emoji visual if Lottie fails
                        return const Center(
                          child: Text(
                            '👾',
                            style: TextStyle(fontSize: 36.0),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
