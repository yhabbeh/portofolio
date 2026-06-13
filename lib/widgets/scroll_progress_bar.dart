import 'package:flutter/material.dart';

class ScrollProgressBar extends StatefulWidget {
  final ScrollController controller;

  const ScrollProgressBar({super.key, required this.controller});

  @override
  State<ScrollProgressBar> createState() => _ScrollProgressBarState();
}

class _ScrollProgressBarState extends State<ScrollProgressBar> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.controller.addListener(_updateProgress);
        _updateProgress();
      }
    });
  }

  void _updateProgress() {
    if (!widget.controller.hasClients) return;
    try {
      final max = widget.controller.position.maxScrollExtent;
      final current = widget.controller.position.pixels;
      final progress = max > 0 ? current / max : 0.0;
      if (progress != _progress) {
        setState(() => _progress = progress);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateProgress);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: _progress > 0 ? _progress : 0.0,
      backgroundColor: Colors.transparent,
      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2F5ED7)),
      minHeight: 3,
    );
  }
}
