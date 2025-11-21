import 'package:flutter/material.dart';
import 'dart:math';
import 'package:uas/dashboard.dart';

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

  // Floating emoji
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
            style: TextStyle(fontSize: size, color: Colors.purple.shade200),
          ),
        );
      },
    );
  }

  void _login() {
    String user = _username.text.trim();
    String pass = _password.text.trim();

    if (user == "admin" && pass == "123") {
      // LOGIN SUKSES → PINDAH KE DASHBOARD
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(username: user),
        ),
      );
    } else {
      // LOGIN GAGAL → TAMPILKAN PESAN
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Login Failed"),
          content: const Text("Username atau Password salah!"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final glow = 0.5 + (_controller.value * 0.5);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(const Color(0xFFF7F3FF),
                      const Color(0xFFF2ECFF), glow)!,
                  Color.lerp(const Color(0xFFF2ECFF),
                      const Color(0xFFEEE8FF), glow)!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating emojis
          floatingEmoji(top: 70, left: 30, dx: 0, dy: 1, seed: 1, icon: "✨"),
          floatingEmoji(
              top: 70,
              left: MediaQuery.of(context).size.width - 70,
              dx: 0,
              dy: 1,
              seed: 2,
              icon: "🌸",
              size: 40),
          floatingEmoji(
              top: MediaQuery.of(context).size.height / 2 - 50,
              left: 20,
              dx: 1,
              dy: 0,
              seed: 3,
              icon: "🎀",
              size: 45),

          // MAIN LOGIN UI
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Text(
                      "Welcome Cuties! 💜",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.lerp(const Color(0xFF6D5BD0),
                            const Color(0xFF9C86FF), glow),
                        shadows: [
                          Shadow(
                              blurRadius: 25 * glow,
                              color:
                                  Colors.purpleAccent.withOpacity(0.6)),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),

                // LOGIN FORM
                Container(
                  width: 350,
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
                    children: [
                      const Text("😻", style: TextStyle(fontSize: 45)),
                      const SizedBox(height: 10),
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D5BD0)),
                      ),
                      const SizedBox(height: 25),

                      // Username
                      TextField(
                        controller: _username,
                        decoration: InputDecoration(
                          labelText: "Username",
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xFF6D5BD0)),
                          filled: true,
                          fillColor: const Color(0xFFF3EEFF),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password
                      TextField(
                        controller: _password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock,
                              color: Color(0xFF6D5BD0)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF6D5BD0),
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3EEFF),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6D5BD0),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
