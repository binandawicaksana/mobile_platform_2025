import 'package:flutter/material.dart';
import 'onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS Flutter - Travel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C7CF),
        ),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const OnboardingScreen(),
    );
  }
}

