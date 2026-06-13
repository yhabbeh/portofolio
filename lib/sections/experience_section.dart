import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/experience_card.dart';
import '../widgets/section_title.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Experience',
          subtitle: 'Professional roles and responsibilities earned over the years.',
          gradient: true,
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: kExperienceItems
                .map((e) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ExperienceCard(experience: e),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
