import 'package:flutter/material.dart';
import 'dashboard.dart'; // ⬅️ tambahkan ini

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE1EC), // soft pink
            Color(0xFFFFF7ED), // cream
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // dekorasi bulat-bulat pastel di background
            Positioned(
              top: -40,
              left: -30,
              child: _softBubble(120),
            ),
            Positioned(
              top: 80,
              right: -50,
              child: _softBubble(160),
            ),
            Positioned(
              bottom: -40,
              right: -20,
              child: _softBubble(110),
            ),
            Positioned(
              bottom: 60,
              left: -30,
              child: _softBubble(140),
            ),

            // isi utama
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),

                    // WELCOME TEXT lucu
                    const Text(
                      "Welcome, sweetie ♡",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE75480),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Have a soft & lovely day ✿",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB56A7C),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // CARD KECIL CUTE
                    Container(
                      width: 310,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.25),
                            blurRadius: 24,
                            spreadRadius: 3,
                            offset: const Offset(0, 6),
                          )
                        ],
                        border: Border.all(
                          color: const Color(0xFFFFA7C0),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "૮₍｡´• ˕ •`｡₎ა",
                            style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFFE75480),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Color(0xFFE75480),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // USERNAME
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: const TextStyle(
                                color: Color(0xFFE75480),
                                fontWeight: FontWeight.w600,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFFEBF3),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFFE75480),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFB6D5),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE75480),
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // PASSWORD
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                color: Color(0xFFE75480),
                                fontWeight: FontWeight.w600,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFFEBF3),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFFE75480),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFFB6D5),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE75480),
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // BUTTON
                          SizedBox(
                            height: 45,
                            width: 170,
                            child: ElevatedButton(
                              onPressed: () {
                                // logika login versi kamu + pindah ke dashboard
                                debugPrint(
                                    "username: ${usernameController.text}");
                                debugPrint(
                                    "password: ${passwordController.text}");

                                // ➜ navigasi ke DASHBOARD
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE75480),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                                shadowColor: Colors.pinkAccent,
                              ),
                              child: const Text(
                                "Masuk ♡",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "you are doing great ✧",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFB56A7C),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // widget dekorasi bubble lembut
  Widget _softBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFCDE5),
            Color(0xFFFFF6F0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          )
        ],
      ),
    );
  }
}
