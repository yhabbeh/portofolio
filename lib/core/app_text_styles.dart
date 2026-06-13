import 'package:flutter/material.dart';

class AppTextStyles {
  static final TextTheme textTheme = ThemeData.light().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: Color(0xFF111827),
          height: 1.05,
        ),
        displayMedium: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
          height: 1.2,
        ),
        titleLarge: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
        titleMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
        titleSmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          height: 1.7,
          color: Color(0xFF475569),
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 1.7,
          color: Color(0xFF475569),
        ),
      );
}
