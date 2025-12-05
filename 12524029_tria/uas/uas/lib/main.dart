import 'package:flutter/material.dart';
import 'dashboard.dart'; // berisi OnboardingScreen & screen lainnya

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
          seedColor: const Color(0xFF00C7CF), // warna biru tosca app travel
        ),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      // layar pertama: halaman promo "TINGKATKAN PENGALAMAN PERJALANAN ANDA"
      home: const OnboardingScreen(),
    );
  }
}
