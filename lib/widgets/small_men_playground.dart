import 'dart:math';
import 'package:flutter/material.dart';

class SmallMenPlayground extends StatefulWidget {
  const SmallMenPlayground({super.key});

  @override
  State<SmallMenPlayground> createState() => _SmallMenPlaygroundState();
}

class _SmallMenPlaygroundState extends State<SmallMenPlayground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ToyCharacter> _characters = [];
  _SoccerBall? _ball;
  final Random _random = Random();
  double _width = 1000; // Updated by LayoutBuilder

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updatePhysics);
    _controller.repeat();

    _initPlayground();
  }

  void _initPlayground() {
    // We add 3 characters playing soccer
    // 1. Striker (Fast, eager)
    _characters.add(_ToyCharacter(
      id: 0,
      x: 150,
      y: 0,
      vx: 80,
      vy: 0,
      baseSpeed: 95,
      state: _ToyState.walking,
    ));

    // 2. Midfielder (Balanced)
    _characters.add(_ToyCharacter(
      id: 1,
      x: 450,
      y: 0,
      vx: 60,
      vy: 0,
      baseSpeed: 75,
      state: _ToyState.walking,
    ));

    // 3. Defender (Slower, keeps distance unless ball is close)
    _characters.add(_ToyCharacter(
      id: 2,
      x: 750,
      y: 0,
      vx: 50,
      vy: 0,
      baseSpeed: 60,
      state: _ToyState.walking,
    ));

    // Bouncing Soccer Ball
    _ball = _SoccerBall(x: 400, y: 150, vx: 100, vy: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePhysics() {
    if (!mounted) return;
    const double dt = 0.016; // 1/60s frame step
    const double gravity = -420.0;
    const double groundY = 0.0;

    setState(() {
      // 1. Update Ball Physics
      if (_ball != null) {
        _ball!.vy += gravity * dt;
        _ball!.x += _ball!.vx * dt;
        _ball!.y += _ball!.vy * dt;

        // Bounce ball on ground
        if (_ball!.y <= groundY) {
          _ball!.y = groundY;
          _ball!.vy = -_ball!.vy * 0.72; // bounce damping
          _ball!.vx *= 0.96; // rolling resistance
          
          // Tiny random nudge if ball stops moving
          if (_ball!.vx.abs() < 12 && _ball!.vy.abs() < 12) {
            _ball!.vx = (_random.nextDouble() - 0.5) * 140;
            _ball!.vy = _random.nextDouble() * 180 + 100;
          }
        }

        // Bounce ball on walls
        if (_ball!.x <= 20) {
          _ball!.x = 20;
          _ball!.vx = -_ball!.vx * 0.8;
        } else if (_ball!.x >= _width - 20) {
          _ball!.x = _width - 20;
          _ball!.vx = -_ball!.vx * 0.8;
        }
      }

      // 2. Update Characters (Procedural AI & Animation state)
      for (int i = 0; i < _characters.length; i++) {
        final c = _characters[i];
        
        // Decrement behavior action timers
        c.actionTimer -= dt;

        // Handle active kick animation phase
        if (c.state == _ToyState.kicking) {
          c.kickTimer += dt * 8; // speed of kicking motion
          if (c.kickTimer >= pi) {
            c.state = _ToyState.walking;
            c.kickTimer = 0.0;
          }
        }

        // Decide behavior state if timer expires
        if (c.actionTimer <= 0 && c.state != _ToyState.kicking) {
          c.actionTimer = _random.nextDouble() * 2.5 + 1.5;
          final r = _random.nextDouble();
          
          if (r < 0.15 && !c.isJumping) {
            c.state = _ToyState.idle;
            c.vx = 0;
          } else {
            c.state = _ToyState.walking;
          }
        }

        // Soccer AI Play Mechanics
        if (_ball != null && c.state != _ToyState.kicking) {
          final double distToBall = _ball!.x - c.x;
          final double distY = _ball!.y - c.y;

          // Determine who is closest to chase the ball
          bool isChaser = true;
          for (final other in _characters) {
            if (other.id != c.id) {
              final double otherDist = (other.x - _ball!.x).abs();
              if (otherDist < distToBall.abs() && (other.x - c.x).abs() > 30) {
                isChaser = false;
              }
            }
          }

          if (isChaser) {
            // Chase the ball
            c.state = _ToyState.running;
            c.vx = distToBall.sign * c.baseSpeed * 1.35;
            
            // Handle Face direction
            if (c.vx > 5) c.faceLeft = false;
            if (c.vx < -5) c.faceLeft = true;

            // Reach ball interaction zone
            if (distToBall.abs() < 24 && distY < 24) {
              // 1. Kick/Pass ball to another player!
              c.state = _ToyState.kicking;
              c.kickTimer = 0.0;

              // Find target player to pass to
              _ToyCharacter? target;
              double minTargetDist = double.maxFinite;
              for (final t in _characters) {
                if (t.id != c.id) {
                  final d = (t.x - c.x).abs();
                  if (d < minTargetDist) {
                    minTargetDist = d;
                    target = t;
                  }
                }
              }

              // Apply kick impulse toward target or forward
              if (target != null) {
                final double passDir = (target.x - c.x).sign;
                _ball!.vx = passDir * (180.0 + _random.nextDouble() * 60.0);
                _ball!.vy = _random.nextDouble() * 130.0 + 80.0; // soft loft pass
              } else {
                _ball!.vx = (c.faceLeft ? -1.0 : 1.0) * (200.0 + _random.nextDouble() * 50.0);
                _ball!.vy = _random.nextDouble() * 150.0 + 90.0;
              }
            } else if (distToBall.abs() < 32 && _ball!.y > 22 && _ball!.y < 65 && !c.isJumping) {
              // 2. Head the ball! (Jump to reach high ball)
              c.isJumping = true;
              c.vy = 240.0;
              c.vx = distToBall.sign * 40;
            }
          } else {
            // Support player positioning (spread out on field)
            final double targetX = c.id == 0 
                ? _width * 0.25 
                : (c.id == 1 ? _width * 0.5 : _width * 0.75);
            final double distToTarget = targetX - c.x;

            if (distToTarget.abs() > 40) {
              c.state = _ToyState.walking;
              c.vx = distToTarget.sign * c.baseSpeed * 0.75;
            } else {
              c.state = _ToyState.idle;
              c.vx = 0;
            }

            if (c.vx > 5) c.faceLeft = false;
            if (c.vx < -5) c.faceLeft = true;
          }
        }

        // Apply physics to jumping / gravity
        if (c.isJumping) {
          c.vy += gravity * dt;
          c.y += c.vy * dt;

          if (c.y <= groundY) {
            c.y = groundY;
            c.vy = 0;
            c.isJumping = false;
          }
        }

        // Move horizontally
        c.x += c.vx * dt;

        // Animate walk/run cycles based on horizontal speed
        if (c.state == _ToyState.running || c.state == _ToyState.walking) {
          final double speedFactor = c.state == _ToyState.running ? 16.0 : 9.0;
          c.runTime += dt * (c.vx.abs() / c.baseSpeed) * speedFactor;
        } else {
          // Slowly decay joint animation to idle state
          c.runTime += dt * 2.0;
        }

        // Screen boundary collisions (bounce back)
        if (c.x <= 15) {
          c.x = 15;
          c.vx = -c.vx;
          c.faceLeft = false;
        } else if (c.x >= _width - 15) {
          c.x = _width - 15;
          c.vx = -c.vx;
          c.faceLeft = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color figureColor = isDark
        ? theme.colorScheme.primary.withAlpha(210)
        : theme.colorScheme.primary.withAlpha(230);
    
    final Color ballColor = isDark ? Colors.white.withAlpha(230) : Colors.black.withAlpha(200);

    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return SizedBox(
          height: 80,
          child: CustomPaint(
            painter: _PlaygroundPainter(
              characters: _characters,
              ball: _ball,
              figureColor: figureColor,
              ballColor: ballColor,
              groundColor: theme.colorScheme.primary.withAlpha(120),
            ),
            child: Container(),
          ),
        );
      },
    );
  }
}

enum _ToyState { idle, walking, running, jumping, kicking }

class _ToyCharacter {
  final int id;
  double x;
  double y;
  double vx;
  double vy;
  double baseSpeed;
  double runTime = 0.0;
  bool faceLeft = false;
  bool isJumping = false;
  _ToyState state;
  double actionTimer = 0.0;
  double kickTimer = 0.0; // kicking leg angle phase

  _ToyCharacter({
    required this.id,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.baseSpeed,
    required this.state,
  });
}

class _SoccerBall {
  double x;
  double y;
  double vx;
  double vy;

  _SoccerBall({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });
}

class _PlaygroundPainter extends CustomPainter {
  final List<_ToyCharacter> characters;
  final _SoccerBall? ball;
  final Color figureColor;
  final Color ballColor;
  final Color groundColor;

  _PlaygroundPainter({
    required this.characters,
    required this.ball,
    required this.figureColor,
    required this.ballColor,
    required this.groundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double groundY = size.height - 14.0;

    // 1. Draw Sleek Ground Line
    final Paint groundPaint = Paint()
      ..strokeWidth = 2.0
      ..shader = LinearGradient(
        colors: [
          groundColor.withAlpha(0),
          groundColor,
          groundColor.withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, groundY, size.width, 2.0));
    canvas.drawLine(Offset(0, groundY), Offset(size.width, groundY), groundPaint);

    // 2. Draw Bouncing Soccer Ball
    if (ball != null) {
      final Offset ballPos = Offset(ball!.x, groundY - ball!.y - 6.0);
      
      // Draw ball outer body
      final Paint ballPaint = Paint()
        ..color = ballColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(ballPos, 6.0, ballPaint);

      // Draw subtle sports pattern inside ball
      final Paint patternPaint = Paint()
        ..color = figureColor.withAlpha(150)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(ballPos, 3.5, patternPaint);
      canvas.drawLine(Offset(ballPos.dx - 6, ballPos.dy), Offset(ballPos.dx + 6, ballPos.dy), patternPaint);
      canvas.drawLine(Offset(ballPos.dx, ballPos.dy - 6), Offset(ballPos.dx, ballPos.dy + 6), patternPaint);
    }

    // 3. Draw Procedural Animated Figures
    final Paint limbPaint = Paint()
      ..color = figureColor
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint headPaint = Paint()
      ..color = figureColor
      ..style = PaintingStyle.fill;

    for (final c in characters) {
      canvas.save();
      
      // Translate coordinates to character position (hip is the origin)
      canvas.translate(c.x, groundY - c.y - 12.0); // pelvic center height
      
      // Flip layout if facing left
      if (c.faceLeft) {
        canvas.scale(-1.0, 1.0);
      }

      // Calculate procedural joint configurations
      double headTilt = 0.0;
      double torsoTilt = 0.0;
      double leg1Angle = 0.0;
      double leg2Angle = 0.0;
      double knee1Flex = 0.0;
      double knee2Flex = 0.0;
      double arm1Angle = 0.0;
      double arm2Angle = 0.0;
      
      // Height values
      const double hipY = 0.0;
      const double torsoLen = 10.0;

      if (c.state == _ToyState.idle) {
        // Breathing motion
        final double breath = sin(c.runTime * 2.0) * 0.4;
        torsoTilt = 0.04;
        headTilt = 0.02;
        
        // Idle limbs hanging straight
        leg1Angle = 0.05;
        leg2Angle = -0.05;
        knee1Flex = 0.0;
        knee2Flex = 0.0;
        
        arm1Angle = 0.1 + breath * 0.1;
        arm2Angle = -0.1 - breath * 0.1;
      } else if (c.isJumping) {
        // Jumping pose: legs tucked in, arms raised up
        torsoTilt = -0.08;
        headTilt = 0.1;

        leg1Angle = -0.28;
        leg2Angle = 0.15;
        knee1Flex = 0.85;
        knee2Flex = 0.65;

        arm1Angle = 2.5; // Arms high in air
        arm2Angle = 2.2;
      } else if (c.state == _ToyState.kicking) {
        // Kicking leg snaps forward, standing leg supports, arms open
        final double phase = c.kickTimer; // ranges [0..pi]
        final double kickLegAngle = -0.6 + sin(phase) * 1.8;
        
        torsoTilt = -0.2; // leaning back
        headTilt = 0.1;

        // Right leg is kicking
        leg2Angle = kickLegAngle;
        knee2Flex = phase > (pi * 0.6) ? 0.1 : 0.6;
        
        // Left leg is standing
        leg1Angle = -0.2;
        knee1Flex = 0.2;

        arm1Angle = 0.8; // arms wide for balance
        arm2Angle = -0.8;
      } else {
        // Walk / Run cycle: sine-wave joint swings
        final double amplitude = c.state == _ToyState.running ? 0.72 : 0.45;
        final double cycle = c.runTime;
        
        torsoTilt = c.state == _ToyState.running ? 0.18 : 0.08;
        headTilt = c.state == _ToyState.running ? 0.05 : 0.02;

        // Legs swing in anti-phase
        leg1Angle = sin(cycle) * amplitude;
        leg2Angle = -sin(cycle) * amplitude;

        // Bending knees on backswing
        knee1Flex = (cos(cycle) + 1.0) * 0.5 * amplitude * 1.2;
        knee2Flex = (-cos(cycle) + 1.0) * 0.5 * amplitude * 1.2;

        // Arms swing in anti-phase to legs
        arm1Angle = -sin(cycle) * amplitude * 1.1;
        arm2Angle = sin(cycle) * amplitude * 1.1;
      }

      // --- Vector Draw Order (Hip origin at 0,0) ---
      
      // 1. Torso segment
      final Offset hip = Offset.zero;
      final Offset shoulder = Offset(sin(torsoTilt) * torsoLen, -cos(torsoTilt) * torsoLen);
      canvas.drawLine(hip, shoulder, limbPaint);

      // 2. Head segment (neck base to skull)
      final Offset neck = shoulder + Offset(sin(torsoTilt + headTilt) * 2.0, -cos(torsoTilt + headTilt) * 2.0);
      canvas.drawCircle(neck - Offset(0, 3.2), 3.2, headPaint);

      // 3. Draw Arms
      // Back Arm (Arm 2)
      final double sArm2Angle = arm2Angle + pi * 0.6; // angle offset
      final Offset elbow2 = shoulder + Offset(sin(sArm2Angle) * 5.5, cos(sArm2Angle) * 5.5);
      final Offset hand2 = elbow2 + Offset(sin(sArm2Angle - 0.4) * 5.5, cos(sArm2Angle - 0.4) * 5.5);
      canvas.drawLine(shoulder, elbow2, limbPaint);
      canvas.drawLine(elbow2, hand2, limbPaint);

      // Front Arm (Arm 1)
      final double sArm1Angle = arm1Angle - pi * 0.6;
      final Offset elbow1 = shoulder + Offset(sin(sArm1Angle) * 5.5, cos(sArm1Angle) * 5.5);
      final Offset hand1 = elbow1 + Offset(sin(sArm1Angle + 0.4) * 5.5, cos(sArm1Angle + 0.4) * 5.5);
      canvas.drawLine(shoulder, elbow1, limbPaint);
      canvas.drawLine(elbow1, hand1, limbPaint);

      // 4. Draw Legs
      // Back Leg (Leg 2)
      final double sLeg2Angle = leg2Angle + pi * 0.95;
      final Offset knee2 = hip + Offset(sin(sLeg2Angle) * 6.5, cos(sLeg2Angle) * 6.5);
      final Offset foot2 = knee2 + Offset(sin(sLeg2Angle - knee2Flex) * 6.0, cos(sLeg2Angle - knee2Flex) * 6.0);
      canvas.drawLine(hip, knee2, limbPaint);
      canvas.drawLine(knee2, foot2, limbPaint);

      // Front Leg (Leg 1)
      final double sLeg1Angle = leg1Angle + pi * 0.95;
      final Offset knee1 = hip + Offset(sin(sLeg1Angle) * 6.5, cos(sLeg1Angle) * 6.5);
      final Offset foot1 = knee1 + Offset(sin(sLeg1Angle - knee1Flex) * 6.0, cos(sLeg1Angle - knee1Flex) * 6.0);
      canvas.drawLine(hip, knee1, limbPaint);
      canvas.drawLine(knee1, foot1, limbPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_PlaygroundPainter old) => true; // Constant tick animations
}
