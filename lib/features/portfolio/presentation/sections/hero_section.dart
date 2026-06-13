import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/responsive_container.dart';
import '../../../../widgets/tilt_card.dart';

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
    // final cardBg =
    //     themeExt?.cardBackground ?? theme.cardTheme.color ?? Colors.white;
    // final shadowColor = themeExt?.shadow ?? Colors.black.withAlpha(20);

    final bool isWide = MediaQuery.of(context).size.width >= 900;

    final Widget textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) {
            final value = sin(_gradientController.value * 2 * pi) * 0.3;
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: gradientColors,
                begin: Alignment(-1 + value, 0),
                end: Alignment(1 + value, 0),
              ).createShader(bounds),
              child: Text(
                widget.headline,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                ),
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
      ],
    );

    final Widget pulsingHalo = AnimatedBuilder(
      animation: _floatingController,
      builder: (context, _) {
        final scale = 1.0 + sin(_floatingController.value * 2 * pi) * 0.05;
        final opacity = 0.15 + sin(_floatingController.value * 2 * pi) * 0.05;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: isWide ? 340 : 280,
            height: isWide ? 420 : 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  gradientColors.first.withAlpha((opacity * 255).round()),
                  gradientColors.last.withAlpha((opacity * 0.4 * 255).round()),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        );
      },
    );

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                widget.profileImage,
                height: isWide ? 320 : 260,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: isWide ? 320 : 260,
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

    final Widget profileCardWithAura = Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -24,
          bottom: -24,
          left: -24,
          right: -24,
          child: pulsingHalo,
        ),
        profileCard,
      ],
    );

    return ResponsiveContainer(
      child: ValueListenableBuilder<double>(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: textColumn),
                  const SizedBox(width: 32),
                  Expanded(flex: 4, child: profileCardWithAura),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textColumn,
                  const SizedBox(height: 48),
                  Center(child: profileCardWithAura),
                ],
              ),
      ),
    );
  }
}
