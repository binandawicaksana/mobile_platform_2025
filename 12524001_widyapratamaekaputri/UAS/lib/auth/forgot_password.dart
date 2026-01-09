import 'package:flutter/material.dart';
import 'reset_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9A679),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        elevation: 0,
        title: const Text('Lupa Password'),
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
                child: sent ? _Success(email: emailC.text) : _Form(emailC: emailC, formKey: _formKey, onSubmit: _send),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _send() {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => sent = true);
  }
}

class _Form extends StatelessWidget {
  final TextEditingController emailC;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;

  const _Form({
    required this.emailC,
    required this.formKey,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Masukkan email terdaftar. Kami akan mengirim tautan untuk mengganti password, seperti proses reset via email pada Shopee.',
            style: TextStyle(fontSize: 12.5),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            validator: (v){
              if (v==null || v.isEmpty) return 'Email wajib diisi';
              final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,}$");
              if (!regex.hasMatch(v)) return 'Email tidak valid';
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
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
              onPressed: onSubmit,
              child: const Text('Kirim Tautan Reset'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Success extends StatelessWidget {
  final String email;
  const _Success({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.mark_email_read_outlined, size: 56, color: Colors.green),
        const SizedBox(height: 10),
        const Text('Tautan reset terkirim!', style: TextStyle(fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text('Cek email: $email', textAlign: TextAlign.center),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ResetPasswordPage(token: 'dummy-token')),
            ),
            child: const Text('Buka Tautan Reset (Simulasi)'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali ke Login'),
          ),
        ),
      ],
    );
  }
}
