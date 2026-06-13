import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/section_title.dart';
import '../widgets/skill_chip.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Skills',
          subtitle: 'Grouped skills that demonstrate ability across mobile, AI, programming, and tooling.',
          gradient: true,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: kSkillCategories.map(
            (category) => SizedBox(
              width: 280,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: category.skills
                            .map((skill) => SkillChip(label: skill))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }
}
