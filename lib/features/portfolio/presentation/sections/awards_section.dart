import 'package:flutter/material.dart';

import '../../../../widgets/section_title.dart';

class AwardsSection extends StatelessWidget {
  final String awardTitle;

  const AwardsSection({super.key, required this.awardTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Awards',
          subtitle: 'Recognition for performance in competitive and technical challenges.',
          gradient: true,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 420,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      awardTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
