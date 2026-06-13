import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Goal width in logical pixels ─────────────────────────────────────────────
const double _kGoalWidth = 18.0;

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
  double _width = 1000;

  // Scoring
  int _playerScore = 0;
  int _aiScore = 0;
  double _goalFlashTimer = 0.0;
  String _goalMessage = '';
  double _postGoalFreeze = 0.0; // physics pause after a goal

  // Challenge timer: 90 seconds
  double _challengeTimeLeft = 90.0;
  bool _gameOver = false;

  // Ball rotation angle (visual)
  double _ballAngle = 0.0;

  // Keyboard controls
  final FocusNode _focusNode = FocusNode();
  bool _leftPressed = false;
  bool _rightPressed = false;
  bool _jumpPressed = false;
  double? _targetPlayerX;

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
    _characters.clear();

    // Striker AI (Fast, eager)
    _characters.add(
      _ToyCharacter(
        id: 0,
        x: 150,
        y: 0,
        vx: 80,
        vy: 0,
        baseSpeed: 95,
        state: _ToyState.walking,
      ),
    );

    // Midfielder AI (Balanced)
    _characters.add(
      _ToyCharacter(
        id: 1,
        x: 450,
        y: 0,
        vx: 60,
        vy: 0,
        baseSpeed: 75,
        state: _ToyState.walking,
      ),
    );

    // Defender AI (Slower)
    _characters.add(
      _ToyCharacter(
        id: 2,
        x: 750,
        y: 0,
        vx: 50,
        vy: 0,
        baseSpeed: 60,
        state: _ToyState.walking,
      ),
    );

    // Player Character (YOU – orange)
    _characters.add(
      _ToyCharacter(
        id: 99,
        isPlayer: true,
        x: 300,
        y: 0,
        vx: 0,
        vy: 0,
        baseSpeed: 90,
        state: _ToyState.idle,
      ),
    );

    // Ball starts in the centre
    _ball = _SoccerBall(
      x: _width > 0 ? _width / 2 : 400,
      y: 120,
      vx: 80,
      vy: 0,
    );
  }

  /// Reset ball to centre and start a brief post-goal freeze.
  void _resetBall() {
    _ball = _SoccerBall(
      x: _width / 2,
      y: 120,
      vx: (_random.nextBool() ? 1 : -1) * 60.0,
      vy: 40,
    );
    _ballAngle = 0.0;
    _postGoalFreeze = 1.0; // 1 second physics pause
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updatePhysics() {
    if (!mounted) return;
    const double dt = 0.016;
    const double gravity = -420.0;
    const double groundY = 0.0;

    setState(() {
      // ── Challenge Timer ──────────────────────────────────────────────────────
      if (!_gameOver) {
        _challengeTimeLeft -= dt;
        if (_challengeTimeLeft <= 0) {
          _challengeTimeLeft = 0;
          _gameOver = true;
        }
      }

      // ── Goal flash & post-goal freeze countdowns ─────────────────────────────
      if (_goalFlashTimer > 0) {
        _goalFlashTimer -= dt;
        if (_goalFlashTimer < 0) _goalFlashTimer = 0;
      }
      if (_postGoalFreeze > 0) {
        _postGoalFreeze -= dt;
        if (_postGoalFreeze < 0) _postGoalFreeze = 0;
        return; // Skip all physics while frozen
      }

      if (_gameOver) return;

      // ── Ball Physics ─────────────────────────────────────────────────────────
      if (_ball != null) {
        _ball!.vy += gravity * dt;
        _ball!.x += _ball!.vx * dt;
        _ball!.y += _ball!.vy * dt;

        // Ball visual rotation based on horizontal speed
        _ballAngle += _ball!.vx * dt * 0.15;

        // Ground bounce
        if (_ball!.y <= groundY) {
          _ball!.y = groundY;
          _ball!.vy = -_ball!.vy * 0.72;
          _ball!.vx *= 0.96;
          if (_ball!.vx.abs() < 12 && _ball!.vy.abs() < 12) {
            _ball!.vx = (_random.nextDouble() - 0.5) * 140;
            _ball!.vy = _random.nextDouble() * 180 + 100;
          }
        }

        // ── Goal detection (early return prevents double-trigger) ─────────────
        final double leftGoalX = _kGoalWidth;
        final double rightGoalX = _width - _kGoalWidth;

        if (_ball!.x <= leftGoalX) {
          _aiScore++;
          _goalMessage = 'AI SCORES! 😈';
          _goalFlashTimer = 1.8;
          _resetBall();
          return; // Exit this frame — ball is already reset
        } else if (_ball!.x >= rightGoalX) {
          _playerScore++;
          _goalMessage = 'GOAL! 🎉';
          _goalFlashTimer = 1.8;
          _resetBall();
          return; // Exit this frame
        }
      }

      // ── Characters ───────────────────────────────────────────────────────────
      for (int i = 0; i < _characters.length; i++) {
        final c = _characters[i];
        c.actionTimer -= dt;

        // Kicking animation phase
        if (c.state == _ToyState.kicking) {
          c.kickTimer += dt * 8;
          if (c.kickTimer >= pi) {
            c.state = _ToyState.walking;
            c.kickTimer = 0.0;
          }
        }

        if (c.isPlayer) {
          // ── Player Input ───────────────────────────────────────────────────
          c.vx = 0;
          if (_leftPressed) {
            _targetPlayerX = null;
            c.vx = -c.baseSpeed * 1.35;
            c.faceLeft = true;
            c.state = _ToyState.running;
          } else if (_rightPressed) {
            _targetPlayerX = null;
            c.vx = c.baseSpeed * 1.35;
            c.faceLeft = false;
            c.state = _ToyState.running;
          } else if (_targetPlayerX != null) {
            final double dist = _targetPlayerX! - c.x;
            if (dist.abs() > 10) {
              c.vx = dist.sign * c.baseSpeed * 1.35;
              c.faceLeft = c.vx < 0;
              c.state = _ToyState.running;
            } else {
              _targetPlayerX = null;
              c.state = _ToyState.idle;
            }
          } else {
            if (c.state != _ToyState.kicking) c.state = _ToyState.idle;
          }

          if (_jumpPressed && !c.isJumping) {
            c.isJumping = true;
            c.vy = 240.0;
          }

          // Player ball interaction
          if (_ball != null && c.state != _ToyState.kicking) {
            final double distToBall = _ball!.x - c.x;
            final double distY = _ball!.y - c.y;
            if (distToBall.abs() < 24 && distY < 24) {
              c.state = _ToyState.kicking;
              c.kickTimer = 0.0;
              _targetPlayerX = null;
              _ball!.vx =
                  (c.faceLeft ? -1.0 : 1.0) *
                  (220.0 + _random.nextDouble() * 60.0);
              _ball!.vy = _random.nextDouble() * 120.0 + 90.0;
            } else if (distToBall.abs() < 30 &&
                _ball!.y > 22 &&
                _ball!.y < 65 &&
                !c.isJumping &&
                _jumpPressed) {
              c.isJumping = true;
              c.vy = 240.0;
              _ball!.vx = distToBall.sign * 180;
              _ball!.vy = _random.nextDouble() * 80 + 40;
            }
          }
        } else {
          // ── AI Behavior ────────────────────────────────────────────────────
          // id=2 is the dedicated goalkeeper — hugs the left goal
          final bool isGoalkeeper = c.id == 2;

          if (!isGoalkeeper) {
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
          }

          if (_ball != null && c.state != _ToyState.kicking) {
            final double distToBall = _ball!.x - c.x;
            final double distY = _ball!.y - c.y;

            if (isGoalkeeper) {
              // Goalkeeper: track ball's Y (height) and stay near left goal
              final double goalKeeperX = _kGoalWidth + 22;
              final double ballApproaching = _ball!.vx < 0 ? 1.0 : 0.5;
              final double gkTargetX = (_ball!.x < _width * 0.4)
                  ? goalKeeperX // Ball on our side — hold position
                  : goalKeeperX + 15; // Ball far — slightly forward

              final double gkDist = gkTargetX - c.x;
              if (gkDist.abs() > 8) {
                c.state = _ToyState.walking;
                c.vx = gkDist.sign * c.baseSpeed * ballApproaching;
                c.faceLeft = c.vx < 0;
              } else {
                c.state = _ToyState.idle;
                c.vx = 0;
                c.faceLeft = false;
              }

              // GK intercepts ball if it gets very close
              if (distToBall.abs() < 28 && distY < 28) {
                c.state = _ToyState.kicking;
                c.kickTimer = 0.0;
                // Clear the ball away from goal
                _ball!.vx = 180.0 + _random.nextDouble() * 60;
                _ball!.vy = _random.nextDouble() * 100 + 60;
              } else if (distToBall.abs() < 36 &&
                  _ball!.y > 16 &&
                  _ball!.y < 55 &&
                  !c.isJumping) {
                c.isJumping = true;
                c.vy = 220.0;
              }
            } else {
              // Regular AI chaser / support logic
              bool isChaser = true;
              for (final other in _characters) {
                if (other.id != c.id && other.id != 2) {
                  // Ignore GK
                  final double otherDist = (other.x - _ball!.x).abs();
                  if (otherDist < distToBall.abs() &&
                      (other.x - c.x).abs() > 30) {
                    isChaser = false;
                  }
                }
              }

              if (isChaser) {
                c.state = _ToyState.running;
                c.vx = distToBall.sign * c.baseSpeed * 1.35;
                if (c.vx > 5) c.faceLeft = false;
                if (c.vx < -5) c.faceLeft = true;

                if (distToBall.abs() < 24 && distY < 24) {
                  c.state = _ToyState.kicking;
                  c.kickTimer = 0.0;

                  // Pass to nearest non-GK teammate or shoot left
                  _ToyCharacter? target;
                  double minTargetDist = double.maxFinite;
                  for (final t in _characters) {
                    if (t.id != c.id && !t.isPlayer && t.id != 2) {
                      final d = (t.x - c.x).abs();
                      if (d < minTargetDist) {
                        minTargetDist = d;
                        target = t;
                      }
                    }
                  }

                  if (target != null && minTargetDist < _width * 0.4) {
                    final double passDir = (target.x - c.x).sign;
                    _ball!.vx = passDir * (190.0 + _random.nextDouble() * 50.0);
                    _ball!.vy = _random.nextDouble() * 120.0 + 80.0;
                  } else {
                    // Shoot toward left goal
                    _ball!.vx = -(200.0 + _random.nextDouble() * 60.0);
                    _ball!.vy = _random.nextDouble() * 100 + 60;
                  }
                } else if (distToBall.abs() < 32 &&
                    _ball!.y > 22 &&
                    _ball!.y < 65 &&
                    !c.isJumping) {
                  c.isJumping = true;
                  c.vy = 240.0;
                  c.vx = distToBall.sign * 40;
                }
              } else {
                // Support position
                final double targetX = c.id == 0
                    ? _width * 0.28
                    : _width * 0.55;
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
          }
        }

        // Gravity / jump physics
        if (c.isJumping) {
          c.vy += gravity * dt;
          c.y += c.vy * dt;
          if (c.y <= groundY) {
            c.y = groundY;
            c.vy = 0;
            c.isJumping = false;
          }
        }

        c.x += c.vx * dt;

        // Walk/run cycle timing
        if (c.state == _ToyState.running || c.state == _ToyState.walking) {
          final double speedFactor = c.state == _ToyState.running ? 16.0 : 9.0;
          c.runTime += dt * (c.vx.abs() / c.baseSpeed) * speedFactor;
        } else {
          c.runTime += dt * 2.0;
        }

        // Boundary clamp (inside goal posts)
        if (c.x <= _kGoalWidth + 5) {
          c.x = _kGoalWidth + 5;
          c.vx = -c.vx;
          c.faceLeft = false;
          if (c.isPlayer) _targetPlayerX = null;
        } else if (c.x >= _width - _kGoalWidth - 5) {
          c.x = _width - _kGoalWidth - 5;
          c.vx = -c.vx;
          c.faceLeft = true;
          if (c.isPlayer) _targetPlayerX = null;
        }
      }
    });
  }

  void _restartGame() {
    setState(() {
      _playerScore = 0;
      _aiScore = 0;
      _challengeTimeLeft = 90.0;
      _gameOver = false;
      _goalFlashTimer = 0;
      _goalMessage = '';
      _initPlayground();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color figureColor = isDark
        ? theme.colorScheme.primary.withAlpha(210)
        : theme.colorScheme.primary.withAlpha(230);
    final Color ballColor = isDark
        ? Colors.white.withAlpha(230)
        : Colors.black.withAlpha(200);

    final int minutes = (_challengeTimeLeft / 60).floor();
    final int seconds = (_challengeTimeLeft % 60).ceil();
    final String timerLabel = '$minutes:${seconds.toString().padLeft(2, '0')}';
    final bool timerWarning = _challengeTimeLeft <= 15;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Score & Timer HUD ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // YOU score
              _ScoreChip(
                label: 'YOU',
                score: _playerScore,
                color: Colors.orange,
                isDark: isDark,
              ),
              // Timer + restart
              GestureDetector(
                onTap: _restartGame,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _gameOver
                        ? Colors.green.withAlpha(30)
                        : timerWarning
                        ? Colors.red.withAlpha(30)
                        : theme.colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _gameOver
                          ? Colors.green
                          : timerWarning
                          ? Colors.red
                          : theme.colorScheme.primary.withAlpha(80),
                      width: 1.0,
                    ),
                  ),
                  child: _gameOver
                      ? Text(
                          _playerScore > _aiScore
                              ? '🏆 YOU WIN!'
                              : _playerScore < _aiScore
                              ? '😭 AI WINS'
                              : '🤝 DRAW',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _playerScore > _aiScore
                                ? Colors.green
                                : _playerScore < _aiScore
                                ? Colors.red
                                : theme.colorScheme.primary,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 11,
                              color: timerWarning
                                  ? Colors.red
                                  : theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timerLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                color: timerWarning
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              // AI score
              _ScoreChip(
                label: 'AI',
                score: _aiScore,
                color: theme.colorScheme.primary,
                isDark: isDark,
              ),
            ],
          ),
        ),

        // ── Playground Canvas ──────────────────────────────────────────────────
        Focus(
          autofocus: true,
          focusNode: _focusNode,
          onKeyEvent: (node, event) {
            final logicalKey = event.logicalKey;
            final isDown = event is KeyDownEvent || event is KeyRepeatEvent;
            bool handled = false;
            if (logicalKey == LogicalKeyboardKey.keyA) {
              _leftPressed = isDown;
              handled = true;
            }
            if (logicalKey == LogicalKeyboardKey.keyD) {
              _rightPressed = isDown;
              handled = true;
            }
            if (logicalKey == LogicalKeyboardKey.keyW ||
                logicalKey == LogicalKeyboardKey.space) {
              _jumpPressed = isDown;
              handled = true;
            }
            // Arrow keys pass through → page scrolls normally
            return handled ? KeyEventResult.handled : KeyEventResult.ignored;
          },
          child: MouseRegion(
            onEnter: (_) => _focusNode.requestFocus(),
            onExit: (_) {
              _focusNode.unfocus();
              _leftPressed = false;
              _rightPressed = false;
              _jumpPressed = false;
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                _focusNode.requestFocus();
                if (!_gameOver) _targetPlayerX = details.localPosition.dx;
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _width = constraints.maxWidth;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 80,
                        child: CustomPaint(
                          painter: _PlaygroundPainter(
                            characters: _characters,
                            ball: _ball,
                            ballAngle: _ballAngle,
                            figureColor: figureColor,
                            ballColor: ballColor,
                            groundColor: theme.colorScheme.primary.withAlpha(
                              120,
                            ),
                            isDark: isDark,
                            goalWidth: _kGoalWidth,
                          ),
                          child: Container(),
                        ),
                      ),
                      // ── GOAL flash overlay ───────────────────────────────────
                      if (_goalFlashTimer > 0)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: (_goalFlashTimer / 1.8).clamp(0.0, 1.0),
                              child: Center(
                                child: Text(
                                  _goalMessage,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: _goalMessage.contains('AI')
                                        ? Colors.red
                                        : Colors.orange,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(120),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // ── GAME OVER overlay ────────────────────────────────────
                      if (_gameOver)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: _restartGame,
                            child: Container(
                              color: Colors.black.withAlpha(100),
                              child: Center(
                                child: Text(
                                  'TAP TO RESTART',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withAlpha(200),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        // ── Controls hint ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            'A / D to run  ·  W or Space to jump  ·  Score in the RIGHT goal',
            style: TextStyle(
              fontSize: 9,
              color: theme.colorScheme.onSurface.withAlpha(80),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Score Chip Widget ─────────────────────────────────────────────────────────

class _ScoreChip extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  final bool isDark;

  const _ScoreChip({
    required this.label,
    required this.score,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(isDark ? 30 : 20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(100), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Models ───────────────────────────────────────────────────────────────

enum _ToyState { idle, walking, running, jumping, kicking }

class _ToyCharacter {
  final int id;
  final bool isPlayer;
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
  double kickTimer = 0.0;

  _ToyCharacter({
    required this.id,
    this.isPlayer = false,
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

// ─── CustomPainter ─────────────────────────────────────────────────────────────

class _PlaygroundPainter extends CustomPainter {
  final List<_ToyCharacter> characters;
  final _SoccerBall? ball;
  final double ballAngle;
  final Color figureColor;
  final Color ballColor;
  final Color groundColor;
  final bool isDark;
  final double goalWidth;

  _PlaygroundPainter({
    required this.characters,
    required this.ball,
    required this.ballAngle,
    required this.figureColor,
    required this.ballColor,
    required this.groundColor,
    required this.isDark,
    required this.goalWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double groundY = size.height - 14.0;
    const double goalHeight = 22.0;

    // 1. Ground line
    final Paint groundPaint = Paint()
      ..strokeWidth = 2.0
      ..shader = LinearGradient(
        colors: [
          groundColor.withAlpha(0),
          groundColor,
          groundColor.withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, groundY, size.width, 2.0));
    canvas.drawLine(
      Offset(0, groundY),
      Offset(size.width, groundY),
      groundPaint,
    );

    // 2. Centre line (dashed)
    final Paint dashPaint = Paint()
      ..color = groundColor.withAlpha(60)
      ..strokeWidth = 1.0;
    const double dashLen = 4.0;
    const double dashGap = 4.0;
    double dy = groundY - goalHeight;
    while (dy <= groundY) {
      canvas.drawLine(
        Offset(size.width / 2, dy),
        Offset(size.width / 2, dy + dashLen),
        dashPaint,
      );
      dy += dashLen + dashGap;
    }

    // 3. Goal posts
    final Paint goalPaint = Paint()
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Left goal (AI defends → AI scores here)
    goalPaint.color = (isDark ? Colors.redAccent : Colors.red).withAlpha(180);
    // Post
    canvas.drawLine(
      Offset(goalWidth, groundY - goalHeight),
      Offset(goalWidth, groundY),
      goalPaint,
    );
    // Crossbar
    canvas.drawLine(
      Offset(0, groundY - goalHeight),
      Offset(goalWidth, groundY - goalHeight),
      goalPaint,
    );
    // Net area tint
    canvas.drawRect(
      Rect.fromLTWH(0, groundY - goalHeight, goalWidth, goalHeight),
      Paint()..color = Colors.red.withAlpha(isDark ? 25 : 15),
    );

    // Right goal (Player scores here)
    goalPaint.color = (isDark ? Colors.greenAccent : Colors.green).withAlpha(
      180,
    );
    canvas.drawLine(
      Offset(size.width - goalWidth, groundY - goalHeight),
      Offset(size.width - goalWidth, groundY),
      goalPaint,
    );
    canvas.drawLine(
      Offset(size.width - goalWidth, groundY - goalHeight),
      Offset(size.width, groundY - goalHeight),
      goalPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        size.width - goalWidth,
        groundY - goalHeight,
        goalWidth,
        goalHeight,
      ),
      Paint()..color = Colors.green.withAlpha(isDark ? 25 : 15),
    );

    // Goal labels
    _drawLabel(
      canvas,
      '←',
      Offset(goalWidth / 2, groundY - goalHeight - 6),
      Colors.red.withAlpha(160),
      8,
    );
    _drawLabel(
      canvas,
      '→',
      Offset(size.width - goalWidth / 2, groundY - goalHeight - 6),
      Colors.green.withAlpha(160),
      8,
    );

    // 4. Ball (with spin rotation)
    if (ball != null) {
      final Offset ballPos = Offset(ball!.x, groundY - ball!.y - 6.0);
      // Shadow
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(ballPos.dx, groundY - 1),
          width: 10 + (ball!.y * 0.06).clamp(0, 4),
          height: 3.5,
        ),
        Paint()..color = Colors.black.withAlpha(isDark ? 40 : 25),
      );
      // Ball body
      canvas.drawCircle(ballPos, 6.0, Paint()..color = ballColor);
      // Rotating pattern
      canvas.save();
      canvas.translate(ballPos.dx, ballPos.dy);
      canvas.rotate(ballAngle);
      final Paint patternPaint = Paint()
        ..color = figureColor.withAlpha(150)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset.zero, 3.5, patternPaint);
      canvas.drawLine(const Offset(-6, 0), const Offset(6, 0), patternPaint);
      canvas.drawLine(const Offset(0, -6), const Offset(0, 6), patternPaint);
      canvas.restore();
    }

    // 5. Procedural Characters
    for (final c in characters) {
      canvas.save();
      canvas.translate(c.x, groundY - c.y - 12.0);
      if (c.faceLeft) canvas.scale(-1.0, 1.0);

      final Color characterColor = c.isPlayer
          ? (isDark ? Colors.orangeAccent : Colors.orange.shade700)
          : figureColor;

      final Paint limbPaint = Paint()
        ..color = characterColor
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final Paint headPaint = Paint()
        ..color = characterColor
        ..style = PaintingStyle.fill;

      // "YOU" label
      if (c.isPlayer) {
        canvas.save();
        canvas.translate(0, -25.0);
        if (c.faceLeft) canvas.scale(-1.0, 1.0);
        _drawLabel(
          canvas,
          'YOU',
          Offset.zero,
          characterColor,
          8,
          bold: true,
          centered: true,
        );
        canvas.restore();
      }

      // Procedural joints
      double headTilt = 0.0;
      double torsoTilt = 0.0;
      double leg1Angle = 0.0;
      double leg2Angle = 0.0;
      double knee1Flex = 0.0;
      double knee2Flex = 0.0;
      double arm1Angle = 0.0;
      double arm2Angle = 0.0;
      const double torsoLen = 10.0;

      if (c.state == _ToyState.idle) {
        final double breath = sin(c.runTime * 2.0) * 0.4;
        torsoTilt = 0.04;
        headTilt = 0.02;
        leg1Angle = 0.05;
        leg2Angle = -0.05;
        arm1Angle = 0.1 + breath * 0.1;
        arm2Angle = -0.1 - breath * 0.1;
      } else if (c.isJumping) {
        torsoTilt = -0.08;
        headTilt = 0.1;
        leg1Angle = -0.28;
        leg2Angle = 0.15;
        knee1Flex = 0.85;
        knee2Flex = 0.65;
        arm1Angle = 2.5;
        arm2Angle = 2.2;
      } else if (c.state == _ToyState.kicking) {
        final double phase = c.kickTimer;
        final double kickLegAngle = -0.6 + sin(phase) * 1.8;
        torsoTilt = -0.2;
        headTilt = 0.1;
        leg2Angle = kickLegAngle;
        knee2Flex = phase > (pi * 0.6) ? 0.1 : 0.6;
        leg1Angle = -0.2;
        knee1Flex = 0.2;
        arm1Angle = 0.8;
        arm2Angle = -0.8;
      } else {
        final double amplitude = c.state == _ToyState.running ? 0.72 : 0.45;
        final double cycle = c.runTime;
        torsoTilt = c.state == _ToyState.running ? 0.18 : 0.08;
        headTilt = c.state == _ToyState.running ? 0.05 : 0.02;
        leg1Angle = sin(cycle) * amplitude;
        leg2Angle = -sin(cycle) * amplitude;
        knee1Flex = (cos(cycle) + 1.0) * 0.5 * amplitude * 1.2;
        knee2Flex = (-cos(cycle) + 1.0) * 0.5 * amplitude * 1.2;
        arm1Angle = -sin(cycle) * amplitude * 1.1;
        arm2Angle = sin(cycle) * amplitude * 1.1;
      }

      // Torso
      final Offset shoulder = Offset(
        sin(torsoTilt) * torsoLen,
        -cos(torsoTilt) * torsoLen,
      );
      canvas.drawLine(Offset.zero, shoulder, limbPaint);

      // Head
      final Offset neck =
          shoulder +
          Offset(
            sin(torsoTilt + headTilt) * 2.0,
            -cos(torsoTilt + headTilt) * 2.0,
          );
      canvas.drawCircle(neck - const Offset(0, 3.2), 3.2, headPaint);

      // Back arm
      final double sArm2Angle = arm2Angle + pi * 0.6;
      final Offset elbow2 =
          shoulder + Offset(sin(sArm2Angle) * 5.5, cos(sArm2Angle) * 5.5);
      final Offset hand2 =
          elbow2 +
          Offset(sin(sArm2Angle - 0.4) * 5.5, cos(sArm2Angle - 0.4) * 5.5);
      canvas.drawLine(shoulder, elbow2, limbPaint);
      canvas.drawLine(elbow2, hand2, limbPaint);

      // Front arm
      final double sArm1Angle = arm1Angle - pi * 0.6;
      final Offset elbow1 =
          shoulder + Offset(sin(sArm1Angle) * 5.5, cos(sArm1Angle) * 5.5);
      final Offset hand1 =
          elbow1 +
          Offset(sin(sArm1Angle + 0.4) * 5.5, cos(sArm1Angle + 0.4) * 5.5);
      canvas.drawLine(shoulder, elbow1, limbPaint);
      canvas.drawLine(elbow1, hand1, limbPaint);

      // Back leg
      final double sLeg2Angle = leg2Angle + pi * 0.95;
      final Offset knee2 = Offset(sin(sLeg2Angle) * 6.5, cos(sLeg2Angle) * 6.5);
      final Offset foot2 =
          knee2 +
          Offset(
            sin(sLeg2Angle - knee2Flex) * 6.0,
            cos(sLeg2Angle - knee2Flex) * 6.0,
          );
      canvas.drawLine(Offset.zero, knee2, limbPaint);
      canvas.drawLine(knee2, foot2, limbPaint);

      // Front leg
      final double sLeg1Angle = leg1Angle + pi * 0.95;
      final Offset knee1 = Offset(sin(sLeg1Angle) * 6.5, cos(sLeg1Angle) * 6.5);
      final Offset foot1 =
          knee1 +
          Offset(
            sin(sLeg1Angle - knee1Flex) * 6.0,
            cos(sLeg1Angle - knee1Flex) * 6.0,
          );
      canvas.drawLine(Offset.zero, knee1, limbPaint);
      canvas.drawLine(knee1, foot1, limbPaint);

      canvas.restore();
    }
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset center,
    Color color,
    double fontSize, {
    bool bold = false,
    bool centered = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      centered
          ? Offset(center.dx - tp.width / 2, center.dy - tp.height / 2)
          : center,
    );
  }

  @override
  bool shouldRepaint(_PlaygroundPainter old) => true;
}
