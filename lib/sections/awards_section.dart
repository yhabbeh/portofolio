import 'package:flutter/material.dart';

import '../widgets/section_title.dart';
import '../core/constants.dart';

class AwardsSection extends StatelessWidget {
  const AwardsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.emoji_events, color: Color(0xFF1B3A8B), size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      kAwardTitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
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
