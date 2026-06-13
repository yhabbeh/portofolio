import 'package:flutter/material.dart';

class CursorGlow extends StatefulWidget {
  final Widget child;

  const CursorGlow({super.key, required this.child});

  @override
  State<CursorGlow> createState() => _CursorGlowState();
}

class _CursorGlowState extends State<CursorGlow> {
  final ValueNotifier<Offset?> _cursorPos = ValueNotifier(null);

  @override
  void dispose() {
    _cursorPos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => _cursorPos.value = event.localPosition,
      onEnter: (event) => _cursorPos.value = event.localPosition,
      onExit: (_) => _cursorPos.value = null,
      child: Stack(
        children: [
          RepaintBoundary(child: widget.child),
          ValueListenableBuilder<Offset?>(
            valueListenable: _cursorPos,
            builder: (context, pos, _) {
              if (pos == null) return const SizedBox.shrink();
              return Positioned(
                left: pos.dx - 200,
                top: pos.dy - 200,
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF1B3A8B).withValues(alpha: 0.06),
                            const Color(0xFF2F5ED7).withValues(alpha: 0.03),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
