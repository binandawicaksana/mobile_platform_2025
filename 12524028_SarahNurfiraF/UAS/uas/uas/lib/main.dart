import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'theme_controller.dart';

void main() {
  runApp(const PremiumInventoryApp());
}

class PremiumInventoryApp extends StatelessWidget {
  const PremiumInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.mode,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Premium Inventory',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFFFE4EF),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF7FA8),
              brightness: Brightness.light,
            ),
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFF7FA8),
              brightness: Brightness.dark,
            ),
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
