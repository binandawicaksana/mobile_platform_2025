import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Hanya langsung masuk jika user masih login (misalnya setelah restart app)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AuthService.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  void _doLogin() {
    final ok = AuthService.instance.loginAuto();
    if (ok) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal login')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND FOTO LOKAL — ganti path sesuai asetmu
          Positioned.fill(
            child: Image.asset(
              'assets/images/brom.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // LAPISAN GELAP TIPIS supaya teks terbaca
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),

          // CARD LOGIN (ditengah)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Jelajahi Keindahan\nGunung Bersama\nOpen Trip Kami',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Nikmati pengalaman mendaki tanpa ribet! Dapatkan harga terbaik untuk open trip gunung, penginapan, dan transportasi. Lebih hemat, lebih seru, lebih banyak opsi perjalanan lengkap.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // DAFTAR AKUN — terlihat seperti aktif tapi tidak bisa dipencet
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: null, // tampil saja, tidak bisa ditekan
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          disabledBackgroundColor: Colors.grey[700],
                          disabledForegroundColor: Colors.white70,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Daftar Akun'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // MASUK — aktif, langsung masuk
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _doLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Masuk'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
