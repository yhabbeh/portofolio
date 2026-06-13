import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../widgets/section_title.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Certifications',
          subtitle: 'Recognized professional development and technical achievement.',
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
                  const Icon(Icons.verified, color: Color(0xFF1B3A8B), size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      kCertificationTitle,
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
