import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token; // simulasi token dari email

  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passC = TextEditingController();
  final confirmC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9A679),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        elevation: 0,
        title: const Text('Setel Password Baru'),
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
                        'Masukkan password baru Anda. Halaman ini mensimulasikan tautan yang dibuka dari email reset.',
                        style: TextStyle(fontSize: 12.5),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passC,
                        obscureText: _obscure1,
                        validator: (v) {
                          if (v == null || v.length < 6) return 'Minimal 6 karakter';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password Baru',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscure1 = !_obscure1),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFF3E8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: confirmC,
                        obscureText: _obscure2,
                        validator: (v) {
                          if (v != passC.text) return 'Password tidak sama';
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Konfirmasi Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscure2 = !_obscure2),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFF3E8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
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
                              const SnackBar(content: Text('Password berhasil diganti. Silakan login.')),
                            );
                            Navigator.popUntil(context, (r) => r.isFirst);
                          },
                          child: const Text('Simpan Password'),
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

