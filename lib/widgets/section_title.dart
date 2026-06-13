import 'package:flutter/material.dart';

class SectionTitle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool gradient;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradient = false,
  });

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedScale(
            scale: _hovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: _hovered
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                  child: widget.gradient
                      ? ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF1B3A8B), Color(0xFF2F5ED7)],
                          ).createShader(bounds),
                          child: Text(widget.title),
                        )
                      : Text(widget.title),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth >= 700
                        ? 700
                        : constraints.maxWidth,
                  ),
                  child: Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
