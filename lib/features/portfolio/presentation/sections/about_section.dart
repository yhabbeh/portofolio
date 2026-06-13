import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/section_title.dart';
import '../../../../widgets/tilt_card.dart';

class AboutSection extends StatelessWidget {
  final String description;
  final List<String> highlights;

  const AboutSection({
    super.key,
    required this.description,
    required this.highlights,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeExt = theme.extension<PortfolioThemeExtension>();
    final cardBg = themeExt?.cardBackground ?? theme.cardTheme.color ?? Colors.white;
    final borderColor = themeExt?.border ?? Colors.grey;

    final bool isWide = MediaQuery.of(context).size.width >= 900;
    
    Widget buildHighlights() {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: highlights
            .map(
              (text) => TiltCard(
                maxTilt: 0.05,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    child: Text(
                      text,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'About',
          subtitle: 'Mobile Software Engineer and AI Specialist with a focus on scalable mobile systems and modern app experiences.',
          gradient: true,
        ),
        const SizedBox(height: 32),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: themeExt?.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 4,
                child: buildHighlights(),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: themeExt?.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              buildHighlights(),
            ],
          ),
      ],
    );
  }
}
