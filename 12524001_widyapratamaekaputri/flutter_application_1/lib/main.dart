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
      title: "Cute Brown Login",

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3E5D7), // coklat susu pastel
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8D6E63), // coklat latte
          foregroundColor: Colors.white,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}