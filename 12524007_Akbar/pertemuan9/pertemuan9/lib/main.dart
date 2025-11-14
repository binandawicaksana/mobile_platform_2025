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
      title: 'LOGIN PAGE TEST', // <- judul beda biar kelihatan
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
      home: const LoginPage(),
    );
  }
}