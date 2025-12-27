import 'package:flutter/material.dart';

class InternetBillSuccessPage extends StatelessWidget {
  final int paidAmount;

  const InternetBillSuccessPage({super.key, required this.paidAmount});

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
          // kalau back di kiri → anggap belum selesai
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text(
          'Tagihan Internet',
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

              // ilustrasi
              SizedBox(
                height: 210,
                child: Image.asset(
                  'assets/images/dasbor.png', // ganti kalau ilustrasinya beda
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Transaksi Berhasil!!',
                style: TextStyle(
                  color: primaryPurple,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Kamu telah membayar tagihan internet!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // kembali ke detail dengan nilai true (selesai)
                    Navigator.pop(context, true);
                  },
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
