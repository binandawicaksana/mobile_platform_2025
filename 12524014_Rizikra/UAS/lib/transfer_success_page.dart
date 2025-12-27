import 'package:flutter/material.dart';

class TransferSuccessPage extends StatelessWidget {
  final String amountText;
  final String receiverName;

  const TransferSuccessPage({
    super.key,
    required this.amountText,
    required this.receiverName,
  });

  Color get primaryPurple => const Color(0xFF5B2ECC);
  Color get lightBackground => const Color(0xFFF6F7FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text(
          'Selesai',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/gambar2.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Transfer Berhasil!!',
                style: TextStyle(
                  color: Color(0xFF2757D8),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Kamu Berhasil Mengirimkan',
                style: TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: amountText,
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: ' ke ',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    TextSpan(
                      text: receiverName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: '!',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    // kirim "true" supaya TransferPage tahu bahwa user sudah selesai
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
