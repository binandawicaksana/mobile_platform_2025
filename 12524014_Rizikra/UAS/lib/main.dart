import 'package:flutter/material.dart';
import 'login.dart'; // pastikan file ini ada dan class LoginPage sudah benar

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS Mobile Banking',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5B2ECC),
        fontFamily: 'Roboto',
      ),
      // HALAMAN PERTAMA SELALU LOGIN
      home: const LoginPage(),
    );
  }
}
