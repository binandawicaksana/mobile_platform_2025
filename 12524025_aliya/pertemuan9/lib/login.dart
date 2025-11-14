import 'package:flutter/material.dart';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _obscure = true;

  late AnimationController _controller;

  final List<String> cuteEmotes = ["✨", "🌸", "🎀", "⭐", "💜"];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Floating emoji builder
  Widget floatingEmoji({
    required double top,
    required double left,
    required double dx,
    required double dy,
    required int seed,
    String icon = "🌸",
    double size = 36,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double movement = sin((_controller.value * 2 * pi) + seed) * 6;

        return Positioned(
          top: top + (dy * movement),
          left: left + (dx * movement),
          child: Text(
            icon,
            style: TextStyle(
              fontSize: size,
              color: Colors.purple.shade200,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final glow = 0.5 + (_controller.value * 0.5);

          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                          const Color(0xFFF7F3FF), const Color(0xFFF2ECFF), glow)!,
                      Color.lerp(
                          const Color(0xFFF2ECFF), const Color(0xFFEEE8FF), glow)!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // ---------- FIX POSITION CUTE FLOATING EMOJIS ----------
              floatingEmoji(
                top: 70,
                left: 30,
                dx: 0,
                dy: 1,
                seed: 1,
                icon: "✨",
              ),

              floatingEmoji(
                top: 70,
                left: MediaQuery.of(context).size.width - 70,
                dx: 0,
                dy: 1,
                seed: 2,
                icon: "🌸",
                size: 40,
              ),

              floatingEmoji(
                top: MediaQuery.of(context).size.height / 2 - 50,
                left: 20,
                dx: 1,
                dy: 0,
                seed: 3,
                icon: "🎀",
                size: 45,
              ),

              floatingEmoji(
                top: MediaQuery.of(context).size.height / 2 - 40,
                left: MediaQuery.of(context).size.width - 70,
                dx: 1,
                dy: 0,
                seed: 4,
                icon: "✨",
                size: 32,
              ),

              floatingEmoji(
                top: MediaQuery.of(context).size.height - 120,
                left: 40,
                dx: 0,
                dy: 1,
                seed: 5,
                icon: "⭐",
                size: 36,
              ),

              floatingEmoji(
                top: MediaQuery.of(context).size.height - 130,
                left: MediaQuery.of(context).size.width - 80,
                dx: 0,
                dy: 1,
                seed: 6,
                icon: "💜",
                size: 40,
              ),

              floatingEmoji(
                top: 20,
                left: MediaQuery.of(context).size.width / 2 - 20,
                dx: 0,
                dy: 1,
                seed: 7,
                icon: "🌸",
                size: 34,
              ),

              floatingEmoji(
                top: MediaQuery.of(context).size.height - 70,
                left: MediaQuery.of(context).size.width / 2 - 20,
                dx: 0,
                dy: 1,
                seed: 8,
                icon: "✨",
                size: 30,
              ),

              // ----------------- MAIN UI -----------------
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // GLOWING TITLE
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Text(
                          "Welcome Cuties! 💜",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color.lerp(
                                const Color(0xFF6D5BD0),
                                const Color(0xFF9C86FF),
                                glow),
                            shadows: [
                              Shadow(
                                blurRadius: 25 * glow,
                                color: Colors.purpleAccent.withOpacity(0.6),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    // LOGIN CARD
                    Container(
                      width: 360,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE6FF),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFB8A7FF).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("😻", style: TextStyle(fontSize: 45)),
                          const SizedBox(height: 10),

                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D5BD0),
                            ),
                          ),
                          const SizedBox(height: 28),

                          TextFormField(
                            controller: _username,
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle:
                                  const TextStyle(color: Color(0xFF6D5BD0)),
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFF6D5BD0)),
                              filled: true,
                              fillColor: const Color(0xFFF3EEFF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFF6D5BD0)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _password,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle:
                                  const TextStyle(color: Color(0xFF6D5BD0)),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color(0xFF6D5BD0)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF6D5BD0),
                                ),
                                onPressed: () {
                                  setState(() => _obscure = !_obscure);
                                },
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF3EEFF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    const BorderSide(color: Color(0xFF6D5BD0)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6D5BD0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            "Stay cute & stay productive 🎀",
                            style: TextStyle(
                              color: Color(0xFF8B79E8),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
