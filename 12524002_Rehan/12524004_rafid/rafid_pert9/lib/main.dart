import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🌙 Nama aplikasi / judul tab web
      title: 'Dark Purple Login',

      // 🌙 Tema dark mode ungu elegan
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor: const Color(0xFF12002F),
      ),

      home: const LoginPage(),
    );
  }
}
