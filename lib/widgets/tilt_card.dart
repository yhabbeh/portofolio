import 'package:flutter/material.dart';

class TiltCard extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final bool enableShadow;

  const TiltCard({
    super.key,
    required this.child,
    this.maxTilt = 0.05,
    this.enableShadow = true,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  Offset _mousePos = Offset.zero;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      onHover: (event) => setState(() => _mousePos = event.localPosition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: widget.enableShadow
            ? BoxDecoration(
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : null,
              )
            : null,
        transform: _hovered ? _getTransform() : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child: widget.child,
      ),
    );
  }

  Matrix4 _getTransform() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return Matrix4.identity();
    final size = renderBox.size;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final dx = (_mousePos.dx - cx) / cx;
    final dy = (_mousePos.dy - cy) / cy;
    return Matrix4.identity()
      ..rotateX(-dy * widget.maxTilt)
      ..rotateY(dx * widget.maxTilt)
      ..setEntry(3, 2, 0.001);
  }
}
