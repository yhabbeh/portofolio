import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool gradient;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradient = false,
  });

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeExt = theme.extension<PortfolioThemeExtension>();
    final gradientColors = themeExt?.gradientColors ?? [theme.colorScheme.primary, theme.colorScheme.secondary];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedScale(
            scale: _hovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: _hovered
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  child: widget.gradient
                      ? ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: gradientColors,
                          ).createShader(bounds),
                          child: Text(
                            widget.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : Text(widget.title),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth >= 700
                        ? 700
                        : constraints.maxWidth,
                  ),
                  child: Text(
                    widget.subtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: themeExt?.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
