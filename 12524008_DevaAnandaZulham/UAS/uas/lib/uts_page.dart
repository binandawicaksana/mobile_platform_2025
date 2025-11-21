import 'package:flutter/material.dart';

class UTSPage extends StatelessWidget {
  const UTSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111427),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ------------------------
            // BAGIAN 1 — Splash Screen
            // ------------------------
            SizedBox(
              height: 700,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/foto1.jpg",
                    width: 250,
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(
                    strokeWidth: 4,
                  ),
                ],
              ),
            ),

            // --------------------------------------
            // BAGIAN 2 — Welcome Screen (Halaman Welcome)
            // --------------------------------------
            SizedBox(
              height: 700,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/images/welcome.png",
                      height: 480,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome to 👋",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
  "XbhiuStore",
  style: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    foreground: Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF32D1C0),
          Color(0xFFBA11F3),
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 250, 70)),
  ),
),
                        const SizedBox(height: 15),
                        const Text(
                          "Aplikasi terbaik untuk memenuhi kebutuhan\nbermain Game anda!",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
