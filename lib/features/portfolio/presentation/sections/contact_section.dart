import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/section_title.dart';

import '../blocs/contact/contact_bloc.dart';
import '../blocs/contact/contact_event.dart';
import '../blocs/contact/contact_state.dart';

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

class ContactSection extends StatefulWidget {
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

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchLink(String url) async {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ContactBloc>().add(
            SubmitContactFormEvent(
              name: _nameController.text,
              email: _emailController.text,
              message: _messageController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final themeExt = theme.extension<PortfolioThemeExtension>();

    final details = [
      ContactDetail(title: 'Email', value: widget.email, link: 'mailto:${widget.email}'),
      ContactDetail(title: 'Phone', value: widget.phone, link: 'tel:${widget.phone}'),
      ContactDetail(
        title: 'LinkedIn',
        value: widget.linkedinUrl.replaceAll('https://www.', '').replaceAll('https://', ''),
        link: widget.linkedinUrl,
      ),
      ContactDetail(
        title: 'GitHub',
        value: widget.githubUrl.replaceAll('https://', ''),
        link: widget.githubUrl,
      ),
      ContactDetail(
        title: 'Location',
        value: widget.location,
        link: 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.location)}',
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

    final Widget contactForm = Card(
      elevation: 0,
      color: themeExt?.cardBackground ?? theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: themeExt?.border ?? colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send a Message',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter your name' : null,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter your email';
                  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegExp.hasMatch(val)) return 'Please enter a valid email address';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter your message' : null,
                decoration: InputDecoration(
                  labelText: 'Message',
                  prefixIcon: const Icon(Icons.chat_bubble_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              BlocConsumer<ContactBloc, ContactState>(
                listener: (context, state) {
                  if (state is ContactSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Message sent successfully!'),
                          ],
                        ),
                        backgroundColor: Colors.green.shade600,
                      ),
                    );
                    _nameController.clear();
                    _emailController.clear();
                    _messageController.clear();
                  } else if (state is ContactFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(child: Text('Error: ${state.error}')),
                          ],
                        ),
                        backgroundColor: Colors.red.shade600,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ContactSubmitting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return PrimaryButton(
                    label: 'Submit Message',
                    onPressed: _submitForm,
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
              Expanded(flex: 5, child: contactCards),
              const SizedBox(width: 32),
              Expanded(flex: 5, child: contactForm),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              contactCards,
              const SizedBox(height: 32),
              contactForm,
            ],
          ),
      ],
    );
  }
}
