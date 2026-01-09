import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'homepage.dart'; // Ganti sesuai halaman tujuanmu

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// BACK BUTTON
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),

              const SizedBox(height: 20),

              /// TITLE LOGO STYLE
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF2AF598), Color(0xFF8E54E9)],
                ).createShader(bounds),
                child: const Text(
                  "XbhiuStore",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Login to Your Account",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 30),

              /// INPUT EMAIL
              _inputField(Icons.email, "Email", false),

              const SizedBox(height: 20),

              /// INPUT PASSWORD
              _inputField(Icons.lock, "Password", true),

              const SizedBox(height: 15),

              /// REMEMBER ME
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (v) {},
                    side: const BorderSide(color: Colors.white),
                    checkColor: Colors.black,
                    activeColor: Colors.white,
                  ),
                  const Text("Ingatkan saya",
                      style: TextStyle(color: Colors.white)),
                ],
              ),

              const SizedBox(height: 10),

              /// SIGN-IN BUTTON (FIXED)
              _signInButton(context),

              const SizedBox(height: 20),

              /// DIVIDER
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or continue with",
                        style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 20),

              /// SOCIAL LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton("Google", "assets/google.png"),
                  _socialButton("Facebook", "assets/facebook.png"),
                  _socialButton("Github", "assets/github.png"),
                ],
              ),

              const SizedBox(height: 30),

              /// SIGN-UP REDIRECT
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFF2AF598),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// INPUT FIELD
  Widget _inputField(IconData icon, String hint, bool obscure) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// SIGN-IN BUTTON (WITH NAVIGATION FIX)
  Widget _signInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()), 
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF2AF598)),
          ),
        ),
        child: const Text(
          "Sign in",
          style: TextStyle(
            color: Color(0xFF2AF598),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// SOCIAL LOGIN BUTTON
  Widget _socialButton(String title, String asset) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Image.asset(asset, height: 28),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
