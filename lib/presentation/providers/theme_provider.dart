import 'package:fin_track/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { light, dark, sepia }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.light);

  void toggleTheme() {
    state = switch (state) {
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.sepia,
      AppThemeMode.sepia => AppThemeMode.light,
    };
  }
  
  ThemeData get currentThemeData {
      return switch (state) {
          AppThemeMode.light => AppTheme.lightTheme,
          AppThemeMode.dark => AppTheme.darkTheme,
          AppThemeMode.sepia => AppTheme.sepiaTheme,
      };
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});
