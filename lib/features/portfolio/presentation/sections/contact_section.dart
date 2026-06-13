import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/contact_form_dialog.dart';
import '../../../../widgets/section_title.dart';

class ContactDetail {
  final String title;
  final String value;
  final String link;

  const ContactDetail({
    required this.title,
    required this.value,
    required this.link,
  });
}

class ContactSection extends StatelessWidget {
  final String email;
  final String phone;
  final String linkedinUrl;
  final String githubUrl;
  final String location;

  const ContactSection({
    super.key,
    required this.email,
    required this.phone,
    required this.linkedinUrl,
    required this.githubUrl,
    required this.location,
  });

  Future<void> _launchLink(String url) async {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final themeExt = theme.extension<PortfolioThemeExtension>();

    final details = [
      ContactDetail(title: 'Email', value: email, link: 'mailto:$email'),
      ContactDetail(title: 'Phone', value: phone, link: 'tel:$phone'),
      ContactDetail(
        title: 'LinkedIn',
        value: linkedinUrl.replaceAll('https://www.', '').replaceAll('https://', ''),
        link: linkedinUrl,
      ),
      ContactDetail(
        title: 'GitHub',
        value: githubUrl.replaceAll('https://', ''),
        link: githubUrl,
      ),
      ContactDetail(
        title: 'Location',
        value: location,
        link: 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}',
      ),
    ];

    final bool isWide = MediaQuery.of(context).size.width >= 900;

    final Widget contactCards = Wrap(
      spacing: 16,
      runSpacing: 16,
      children: details
          .map(
            (detail) => SizedBox(
              width: 260,
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => _launchLink(detail.link),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: themeExt?.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          detail.value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Contact',
          subtitle: 'Reach out directly via email, phone, professional profiles, or drop a message below.',
          gradient: true,
        ),
        const SizedBox(height: 32),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: contactCards),
              const SizedBox(width: 32),
              Expanded(flex: 4, child: _buildMessageCard(context, theme, colors, themeExt)),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              contactCards,
              const SizedBox(height: 32),
              _buildMessageCard(context, theme, colors, themeExt),
            ],
          ),
      ],
    );
  }

  Widget _buildMessageCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
    PortfolioThemeExtension? themeExt,
  ) {
    return Card(
      elevation: 0,
      color: themeExt?.cardBackground ?? theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: themeExt?.border ?? colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.send_rounded, color: colors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Send a Message',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Have a question, opportunity, or just want to say hi? I\'ll get back to you as soon as possible.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: themeExt?.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ContactFormDialog.show(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  elevation: 2,
                  shadowColor: colors.primary.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Write a Message',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
