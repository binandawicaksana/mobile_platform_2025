import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true; // untuk show/hide password

  static const Color primaryPurple = Color(0xFF4A00E0);

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      // Jika valid, langsung pindah ke dashboard dengan saldo awal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardPage(
            initialBalance: 8129, // saldo awal di dashboard
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryPurple,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Masuk', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Panel putih melengkung
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ilustrasi + titik warna-warni
                      SizedBox(
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F2FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_outline,
                                size: 48,
                                color: primaryPurple,
                              ),
                            ),
                            const Positioned(
                              top: 40,
                              right: 60,
                              child: _Dot(color: Color(0xFFFF5C7A)),
                            ),
                            const Positioned(
                              top: 35,
                              left: 55,
                              child: _Dot(color: Color(0xFF38D9A9)),
                            ),
                            const Positioned(
                              bottom: 40,
                              left: 70,
                              child: _Dot(color: Color(0xFFFFC857)),
                            ),
                            const Positioned(
                              bottom: 35,
                              right: 70,
                              child: _Dot(color: Color(0xFF4D96FF)),
                            ),
                            const Positioned(
                              top: 25,
                              child: _Dot(color: Color(0xFF4D96FF), size: 6),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Selamat Datang, Kembali',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: primaryPurple,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ================= USERNAME =================
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: primaryPurple),
                          ),
                        ),
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) {
                            return "Username tidak boleh kosong";
                          }
                          if (v.length < 4) {
                            return "Username minimal 4 karakter";
                          }
                          // hanya huruf, angka, underscore
                          final regex = RegExp(r'^[a-zA-Z0-9_]+$');
                          if (!regex.hasMatch(v)) {
                            return "Username hanya boleh huruf, angka, dan _ (tanpa spasi)";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= PASSWORD =================
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: const Color(0xFFF7F7F7),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          // BUKAN selectbox: pakai ikon eye untuk show/hide
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(color: primaryPurple),
                          ),
                        ),
                        validator: (value) {
                          final v = value ?? '';
                          if (v.isEmpty) {
                            return "Password tidak boleh kosong";
                          }
                          if (v.length < 8) {
                            return "Password minimal 8 karakter";
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(v)) {
                            return "Password harus mengandung huruf besar";
                          }
                          if (!RegExp(r'[a-z]').hasMatch(v)) {
                            return "Password harus mengandung huruf kecil";
                          }
                          if (!RegExp(r'[0-9]').hasMatch(v)) {
                            return "Password harus mengandung angka";
                          }
                          if (!RegExp(
                            r'[!@#\$%^&*(),.?":{}|<>_\-]',
                          ).hasMatch(v)) {
                            return "Password harus mengandung simbol";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Lupa Password ?',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tombol Masuk
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Icon(
                        Icons.fingerprint,
                        size: 64,
                        color: primaryPurple,
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Belum Punya Akun? ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: 'Daftar',
                                style: TextStyle(
                                  color: primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// titik warna-warni
class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({required this.color, this.size = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
