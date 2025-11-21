import 'package:flutter/material.dart';
import 'package:uas/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Akademik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B3C8C),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color(0xFF0F1E5A),
          displayColor: const Color(0xFF0F1E5A),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
