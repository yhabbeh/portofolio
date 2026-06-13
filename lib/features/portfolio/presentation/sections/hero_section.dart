import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/responsive_container.dart';
import '../../../../widgets/tilt_card.dart';
import '../../../../widgets/small_men_playground.dart';

class HeroSection extends StatefulWidget {
  final String headline;
  final String subtitle;
  final String name;
  final String location;
  final String profileImage;
  final VoidCallback onContactPressed;
  final VoidCallback onDownloadPressed;
  final ValueNotifier<double> scrollOffsetNotifier;

  const HeroSection({
    super.key,
    required this.headline,
    required this.subtitle,
    required this.name,
    required this.location,
    required this.profileImage,
    required this.onContactPressed,
    required this.onDownloadPressed,
    required this.scrollOffsetNotifier,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _gradientController;
  late final AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeExt = theme.extension<PortfolioThemeExtension>();
    final gradientColors =
        themeExt?.gradientColors ??
        [theme.colorScheme.primary, theme.colorScheme.secondary];

    final bool isWide = MediaQuery.of(context).size.width >= 900;

    final Widget textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) {
            return Text(
              widget.headline,
              style: theme.textTheme.displayLarge?.copyWith(
                color: gradientColors.first,
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          widget.subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: themeExt?.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            PrimaryButton(
              label: 'Contact Me',
              onPressed: widget.onContactPressed,
            ),
            PrimaryButton(
              label: 'Download CV',
              onPressed: widget.onDownloadPressed,
              outlined: true,
            ),
          ],
        ),
        if (isWide) ...[
          const SizedBox(height: 48),
          // Center(
          //   child: SizedBox(
          //     height: 240,
          //     width: 320,
          //     child: Lottie.network(
          //       'https://assets5.lottiefiles.com/packages/lf20_iv4dsx3q.json',
          //       fit: BoxFit.contain,
          //       errorBuilder: (context, error, stackTrace) =>
          //           const SizedBox.shrink(),
          //     ),
          //   ),
          // ),
        ],
      ],
    );

    final double imageSize = isWide ? 320 : 260;

    final Widget profileCard = AnimatedBuilder(
      animation: Listenable.merge([
        _floatingController,
        widget.scrollOffsetNotifier,
      ]),
      builder: (context, child) {
        final floatOffset = sin(_floatingController.value * 2 * pi) * 8.0;
        final parallaxOffset = widget.scrollOffsetNotifier.value * 0.15;
        return Transform.translate(
          offset: Offset(0, floatOffset - parallaxOffset * 0.5),
          child: child,
        );
      },
      child: TiltCard(
        maxTilt: 0.03,
        enableShadow: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                AnimatedBuilder(
                  animation: _floatingController,
                  builder: (context, _) {
                    final scale =
                        1.0 + sin(_floatingController.value * 2 * pi) * 0.05;
                    final opacity =
                        0.15 + sin(_floatingController.value * 2 * pi) * 0.05;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: imageSize + 48,
                        height: imageSize + 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              gradientColors.first.withAlpha(
                                (opacity * 255).round(),
                              ),
                              gradientColors.last.withAlpha(
                                (opacity * 0.4 * 255).round(),
                              ),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ClipOval(
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: Image.asset(
                      widget.profileImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.primary.withAlpha(30),
                          child: Icon(
                            Icons.person,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.location,
              style: theme.textTheme.bodySmall?.copyWith(
                color: themeExt?.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    return ResponsiveContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, _) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: _OrbsPainter(
                    t: _floatingController.value,
                    colors: gradientColors,
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder<double>(
            valueListenable: widget.scrollOffsetNotifier,
            builder: (context, scrollOffset, child) {
              final parallaxOffset = scrollOffset * 0.15;
              return Transform.translate(
                offset: Offset(0, parallaxOffset),
                child: child,
              );
            },
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: textColumn),
                      const SizedBox(width: 32),
                      Expanded(flex: 4, child: profileCard),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textColumn,
                      const SizedBox(height: 48),
                      Center(child: profileCard),
                    ],
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -60,
            child: const SmallMenPlayground(),
          ),
        ],
      ),
    );
  }
}

class _OrbsPainter extends CustomPainter {
  final double t;
  final List<Color> colors;

  const _OrbsPainter({required this.t, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      _OrbData(0.2, 0.15, 200, 0.0, 0.6),
      _OrbData(0.8, 0.7, 140, 1.3, 0.5),
      _OrbData(0.5, 0.3, 160, 2.8, 0.4),
      _OrbData(0.9, 0.2, 100, 0.7, 0.35),
      _OrbData(0.15, 0.75, 120, 3.5, 0.3),
    ];

    for (final orb in orbs) {
      final dx = sin(t * 2 * pi * 0.3 + orb.phase) * size.width * 0.12;
      final dy = cos(t * 2 * pi * 0.2 + orb.phase) * size.height * 0.08;
      final cx = size.width * orb.x + dx;
      final cy = size.height * orb.y + dy;
      final radius = orb.radius * (1 + sin(t * 2 * pi * 0.4 + orb.phase) * 0.1);

      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: [
            colors.first.withAlpha((orb.alpha * 255).round()),
            colors.last.withAlpha((orb.alpha * 0.4 * 255).round()),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius));

      canvas.drawCircle(Offset(cx, cy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_OrbsPainter old) => old.t != t;
}

class _OrbData {
  final double x, y, radius, phase, alpha;
  const _OrbData(this.x, this.y, this.radius, this.phase, this.alpha);
}
