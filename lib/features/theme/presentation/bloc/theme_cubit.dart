import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'user_theme_mode';

  ThemeCubit({required this.sharedPreferences}) : super(const ThemeState(ThemeMode.system)) {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final savedTheme = sharedPreferences.getString(_themeKey);
    if (savedTheme != null) {
      final mode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      emit(ThemeState(mode));
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    await sharedPreferences.setString(_themeKey, mode.toString());
    emit(ThemeState(mode));
  }
}
