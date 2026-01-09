import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  void setFromLabel(String label) {
    switch (label) {
      case 'Terang':
        mode.value = ThemeMode.light;
        break;
      case 'Gelap':
        mode.value = ThemeMode.dark;
        break;
      default:
        mode.value = ThemeMode.system;
    }
  }

  String labelFromMode() {
    switch (mode.value) {
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      case ThemeMode.system:
      default:
        return 'Sistem';
    }
  }
}

