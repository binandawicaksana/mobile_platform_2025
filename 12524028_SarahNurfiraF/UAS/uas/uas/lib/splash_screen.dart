import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // setelah 3 detik pindah ke login
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFB6C8), // pink pastel seperti di figma
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // logo kotak lucu (sementara pakai icon)
            Icon(
              Icons.inventory_2_rounded,
              size: 120,
              color: Color(0xFFFF7FA5),
            ),
            SizedBox(height: 20),
            Text(
              'Premium Inventory',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF5E8D),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
