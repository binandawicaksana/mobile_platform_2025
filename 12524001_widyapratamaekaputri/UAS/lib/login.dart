import 'package:flutter/material.dart';
import 'dashboard/dashboardpage.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _userC = TextEditingController();
  final _passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9A679),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),

                _InputBox(
                  controller: _userC,
                  hint: "Username / Email",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 10),
                _InputBox(
                  controller: _passC,
                  hint: "Password",
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45F4B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const DashboardPage()),
                      );
                    },
                    child: const Text("Login"),
                  ),
                ),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                    );
                  },
                  child: const Text("Lupa Password?"),
                ),

                const SizedBox(height: 6),
                const Text("atau", style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),

                _SocialBtn(
                  icon: Icons.g_mobiledata,
                  text: "Login dengan Google",
                  color: Colors.white,
                  textColor: Colors.black,
                ),
                const SizedBox(height: 8),
                _SocialBtn(
                  icon: Icons.facebook,
                  text: "Login dengan Facebook",
                  color: const Color(0xFF1877F2),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 8),
                _SocialBtn(
                  icon: Icons.chat, // pengganti whatsapp bawaan flutter
                  text: "Login dengan WhatsApp",
                  color: const Color(0xFF25D366),
                  textColor: Colors.white,
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Belum punya akun? ",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterPage()),
                        );
                      },
                      child: const Text('Daftar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _InputBox({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFFFBF5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color textColor;

  const _SocialBtn({
    required this.icon,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {},
        icon: Icon(icon),
        label: Text(text),
      ),
    );
  }
}
