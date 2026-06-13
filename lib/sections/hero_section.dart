import 'dart:math';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/primary_button.dart';
import '../widgets/responsive_container.dart';
import '../widgets/tilt_card.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onContactPressed;
  final VoidCallback onDownloadPressed;
  final double scrollOffset;

  const HeroSection({
    super.key,
    required this.onContactPressed,
    required this.onDownloadPressed,
    this.scrollOffset = 0,
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
    final bool isWide = MediaQuery.of(context).size.width >= 900;
    final parallaxOffset = widget.scrollOffset * 0.15;

    final Widget textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, _) {
            final value = sin(_gradientController.value * 2 * pi) * 0.3;
            return ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: const [Color(0xFF1B3A8B), Color(0xFF2F5ED7)],
                begin: Alignment(-1 + value, 0),
                end: Alignment(1 + value, 0),
              ).createShader(bounds),
              child: Text(
                kHeroHeadline,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(kHeroSubtitle, style: Theme.of(context).textTheme.bodyLarge),
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
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40),
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF2F5ED7).withValues(alpha: opacity),
                  const Color(0xFF1B3A8B).withValues(alpha: opacity * 0.4),
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
      animation: _floatingController,
      builder: (context, child) {
        final floatOffset = sin(_floatingController.value * 2 * pi) * 8.0;
        return Transform.translate(
          offset: Offset(0, floatOffset - parallaxOffset * 0.5),
          child: child,
        );
      },
      child: TiltCard(
        maxTilt: 0.03,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 28,
                offset: Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  kProfileImage,
                  height: isWide ? 320 : 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(kName, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(kLocation, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
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
      child: Transform.translate(
        offset: Offset(0, parallaxOffset),
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
