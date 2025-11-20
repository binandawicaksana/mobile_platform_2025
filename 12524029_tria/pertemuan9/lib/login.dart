import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌈 GRADIENT SUPER SOFT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFEFF7), // pink creamy
              Color(0xFFE4F2FF), // baby blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // ================== BUNGA & HEWAN ==================
            _floatingCute("🌸", 52, const Alignment(-0.9, -0.6)),
            _floatingCute("🐰", 60, const Alignment(-0.2, -0.8)),
            _floatingCute("🌷", 50, const Alignment(-0.9, 0.0)),
            _floatingCute("✨", 30, const Alignment(-0.6, 0.3)),
            _floatingCute("🐱", 56, const Alignment(-0.9, 0.65)),

            _floatingCute("💖", 34, const Alignment(0.9, -0.55)),
            _floatingCute("🌻", 52, const Alignment(0.9, -0.15)),
            _floatingCute("🐣", 52, const Alignment(0.9, 0.25)),
            _floatingCute("🦊", 58, const Alignment(0.8, 0.6)),
            _floatingCute("🐻", 60, const Alignment(0.75, 0.85)),

            // ================== LOGIN UI ==================
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome 💗",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 7, color: Colors.pinkAccent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("🌸🐰🌷💖🌼", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 24),

                    Container(
                      width: 330,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: const Color(0xFFFFC7E8),
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            color: Colors.pinkAccent.withOpacity(0.18),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Login 💕🌸",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Username
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFFF3FA),
                              labelText: "Username",
                              labelStyle: const TextStyle(
                                color: Color(0xFFFF6FAF),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFFFF6FAF),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Password
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFE8F1FF),
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                color: Color(0xFF6FA9FF),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF6FA9FF),
                              ),
                              suffixIcon: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                child: Text(
                                  _isPasswordVisible ? "Hide ✨" : "Show ✨",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6FA9FF),
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF5FB8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 5,
                                shadowColor:
                                    Colors.pinkAccent.withOpacity(0.4),
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Login ✨",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),
                    const Text(
                      "Stay cute & stay happy 🌸✨🐰",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌷 floating bubble yang tidak menumpuk (pakai Align)
  Widget _floatingCute(String emoji, double size, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Opacity(
        opacity: 0.9,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.35),
          ),
          child: Text(
            emoji,
            style: TextStyle(fontSize: size),
          ),
        ),
      ),
    );
  }
}
