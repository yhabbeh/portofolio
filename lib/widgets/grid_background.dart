import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  final Widget child;

  const GridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.primary.withAlpha(18)
        : theme.colorScheme.primary.withAlpha(8);

    return CustomPaint(
      painter: _GridPainter(dotColor: dotColor),
      child: child,
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color dotColor;

  const _GridPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double spacing = 32.0;
    const double radius = 0.9;

    for (double x = 16; x < size.width; x += spacing) {
      for (double y = 16; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor;
  }
}
