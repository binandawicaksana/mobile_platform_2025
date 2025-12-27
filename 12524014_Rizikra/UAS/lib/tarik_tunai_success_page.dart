import 'package:flutter/material.dart';

class TarikTunaiSuccessPage extends StatelessWidget {
  final int amount;

  const TarikTunaiSuccessPage({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5B2ECC);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 18,
          ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                child: Image.asset(
                  'assets/images/gambar2.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'berhasil Tarik Tunai!',
                style: TextStyle(
                  color: primaryPurple,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              // ==== TEKS DENGAN NOMINAL MERAH ====
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Kamu Berhasil Tarik Tunai\nSebesar '),
                    TextSpan(
                      text: '\$$amount',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' silahkan tekan menekan tombol dibawah\nuntuk menyelesaikan transaksi',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
