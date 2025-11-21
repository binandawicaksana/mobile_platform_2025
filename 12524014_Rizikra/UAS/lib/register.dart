import 'package:flutter/material.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isAgreed = false;

  static const Color primaryPurple = Color(0xFF4A00E0);

  void _onDaftar() {
    // validasi form + checkbox
    if (_formKey.currentState!.validate()) {
      if (!_isAgreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Centang dulu syarat & ketentuan.')),
        );
        return;
      }

      // DI SINI KUNCI-NYA ➜ setelah daftar, balik ke LOGIN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Daftar', style: TextStyle(color: Colors.white)),
      ),
      body: Align(
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ilustrasi + titik
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
                            Icons.person_add_alt,
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
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryPurple,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Nama
                  TextFormField(
                    controller: _namaController,
                    decoration: _inputDecoration('Nama'),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: _inputDecoration('Username'),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Username tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration(
                      'Password',
                    ).copyWith(suffixIcon: const Icon(Icons.arrow_drop_down)),
                    validator: (v) => v == null || v.length < 6
                        ? 'Password minimal 6 karakter'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        activeColor: primaryPurple,
                        onChanged: (val) {
                          setState(() => _isAgreed = val ?? false);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Dengan membuat akun, anda menyetujui syarat dan ketentuan kami',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // tombol Daftar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onDaftar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAgreed
                            ? primaryPurple
                            : const Color(0xFFEDEBFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _isAgreed
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // sudah punya akun? Masuk
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Sudah Punya Akun? ',
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'Masuk',
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
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
