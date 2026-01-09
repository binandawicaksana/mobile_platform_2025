import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9A679),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        elevation: 0,
        title: const Text('Daftar Akun'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 420,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Buat akun baru untuk belanja lebih mudah. Seperti Shopee, kamu bisa simpan alamat dan pantau pesanan.',
                        style: TextStyle(fontSize: 12.5),
                      ),
                      const SizedBox(height: 12),
                      _Input(label: 'Nama Lengkap', controller: nameC, icon: Icons.person_outline),
                      const SizedBox(height: 10),
                      _Input(
                        label: 'Email',
                        controller: emailC,
                        icon: Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                        validator: (v){
                          if (v==null || v.isEmpty) return 'Email wajib diisi';
                          final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,}$");
                          if (!regex.hasMatch(v)) return 'Email tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _Input(label: 'Password', controller: passC, icon: Icons.lock_outline, obscure: true,
                        validator: (v){
                          if (v==null || v.length < 6) return 'Minimal 6 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _Input(label: 'Konfirmasi Password', controller: confirmC, icon: Icons.lock_outline, obscure: true,
                        validator: (v){
                          if (v != passC.text) return 'Password tidak sama';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB45F4B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() != true) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Akun berhasil dibuat. Silakan login.')),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Daftar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;

  const _Input({
    required this.label,
    required this.controller,
    required this.icon,
    this.obscure = false,
    this.keyboard,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFFFF3E8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
