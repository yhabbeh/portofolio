import 'package:flutter/material.dart';

@immutable
class PortfolioThemeExtension extends ThemeExtension<PortfolioThemeExtension> {
  final Color? textSecondary;
  final Color? cardBackground;
  final Color? border;
  final Color? shadow;
  final List<Color>? gradientColors;

  const PortfolioThemeExtension({
    required this.textSecondary,
    required this.cardBackground,
    required this.border,
    required this.shadow,
    required this.gradientColors,
  });

  @override
  PortfolioThemeExtension copyWith({
    Color? textSecondary,
    Color? cardBackground,
    Color? border,
    Color? shadow,
    List<Color>? gradientColors,
  }) {
    return PortfolioThemeExtension(
      textSecondary: textSecondary ?? this.textSecondary,
      cardBackground: cardBackground ?? this.cardBackground,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      gradientColors: gradientColors ?? this.gradientColors,
    );
  }

  @override
  PortfolioThemeExtension lerp(
    ThemeExtension<PortfolioThemeExtension>? other,
    double t,
  ) {
    if (other is! PortfolioThemeExtension) return this;
    return PortfolioThemeExtension(
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t),
      border: Color.lerp(border, other.border, t),
      shadow: Color.lerp(shadow, other.shadow, t),
      gradientColors: gradientColors, // Or interpolate individually if needed
    );
  }
}

class AppTheme {
  static TextTheme _buildTextTheme(Color textPrimaryColor, Color textSecondaryColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        color: textPrimaryColor,
        height: 1.05,
      ),
      displayMedium: TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textSecondaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.7,
        color: textSecondaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.7,
        color: textSecondaryColor,
      ),
    );
  }

  static ThemeData get lightTheme {
    const textPrimary = Color(0xFF111827);
    const textSecondary = Color(0xFF475569);
    const primary = Color(0xFF1B3A8B);
    const secondary = Color(0xFF2F5ED7);
    const background = Color(0xFFF4F7FF);
    const surface = Color(0xFFFFFFFF);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      textTheme: _buildTextTheme(textPrimary, textSecondary),
      extensions: const [
        PortfolioThemeExtension(
          textSecondary: textSecondary,
          cardBackground: surface,
          border: Color(0xFFE2E8F0),
          shadow: Color(0x0F0F172A),
          gradientColors: [primary, secondary],
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    const textPrimary = Color(0xFFF8FAFC);
    const textSecondary = Color(0xFF94A3B8);
    const primary = Color(0xFF60A5FA); // Lighter blue for dark mode
    const secondary = Color(0xFF3B82F6);
    const background = Color(0xFF0F172A); // Slate 900
    const surface = Color(0xFF1E293B); // Slate 800

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      textTheme: _buildTextTheme(textPrimary, textSecondary),
      extensions: const [
        PortfolioThemeExtension(
          textSecondary: textSecondary,
          cardBackground: surface,
          border: Color(0xFF334155),
          shadow: Color(0x3D000000),
          gradientColors: [primary, Color(0xFF93C5FD)],
        ),
      ],
    );
  }
}
