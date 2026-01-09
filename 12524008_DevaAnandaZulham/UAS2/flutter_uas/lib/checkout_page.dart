import 'package:flutter/material.dart';
import 'payment_page.dart';


class CheckoutPage extends StatelessWidget {
  final String email;
  final String diamond;

  const CheckoutPage({
    super.key,
    required this.email,
    required this.diamond,
  });

  @override
  Widget build(BuildContext context) {
    // LANGSUNG PINDAH KE PAYMENT PAGE (AMAN)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PaymentPage(),
        ),
      );
    });

    // HALAMAN INI TIDAK DITAMPILKAN
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: SizedBox.shrink(),
    );
  }
}
