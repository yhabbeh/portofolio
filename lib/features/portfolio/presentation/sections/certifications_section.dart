import 'package:flutter/material.dart';

import '../../../../widgets/section_title.dart';

class CertificationsSection extends StatelessWidget {
  final String certificationTitle;

  const CertificationsSection({super.key, required this.certificationTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Icon(Icons.verified, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      certificationTitle,
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
