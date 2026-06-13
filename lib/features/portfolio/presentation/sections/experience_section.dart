import 'package:flutter/material.dart';

import '../../../../widgets/experience_card.dart';
import '../../../../widgets/section_title.dart';
import '../../domain/entities/experience.dart';

class ExperienceSection extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceSection({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Experience',
          subtitle:
              'Professional roles and responsibilities earned over the years.',
          gradient: true,
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              final e = experiences[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ExperienceCard(experience: e),
              );
            },
          ),
        ),
      ],
    );
  }
}
