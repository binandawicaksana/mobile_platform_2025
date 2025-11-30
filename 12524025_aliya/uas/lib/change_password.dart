import 'package:flutter/material.dart';
import 'package:uas/login.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _submit() {
    if (_newPassword.text.isEmpty || _confirmPassword.text.isEmpty) {
      _showDialog("Gagal", "Semua field wajib diisi.");
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      _showDialog("Gagal", "Konfirmasi password tidak cocok.");
      return;
    }

    _showDialog("Berhasil", "Password berhasil diperbarui.");
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: EdgeInsets.only(
                  top: isMobile ? 25 : 40,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "MyPresence",
                      style: TextStyle(
                        fontSize: isMobile ? 32 : 42,
                        color: const Color(0xFF1E2A78),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset(
                      "assets/images/logounbin2.png",
                      height: isMobile ? 90 : 120,
                    ),
                  ],
                ),
              ),

              // CARD
              Container(
                width: isMobile ? size.width * 0.85 : 360,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 120,
                      height: 2,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 25),

                    // New Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password Baru",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _newPassword,
                      obscureText: _obscureNew,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Masukkan password baru",
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.65)),
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              setState(() => _obscureNew = !_obscureNew),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Konfirmasi Password",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _confirmPassword,
                      obscureText: _obscureConfirm,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Konfirmasi password baru",
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.65)),
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // BUTTON UPDATE
              Container(
                width: isMobile ? 150 : 200,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Update Password",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    color: Color(0xFF1E2A78),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
