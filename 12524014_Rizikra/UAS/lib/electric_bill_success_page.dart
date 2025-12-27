import 'package:flutter/material.dart';

class ElectricBillSuccessPage extends StatelessWidget {
  final int paidAmount;

  const ElectricBillSuccessPage({super.key, required this.paidAmount});

  Color get primaryPurple => const Color(0xFF5B2ECC);

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7FB);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context, false), // batal / back biasa
        ),
        title: const Text(
          'Tagihan Listrik',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // ilustrasi (ganti asset sesuai punyamu)
              SizedBox(
                height: 180,
                child: Image.asset(
                  'assets/images/listrik_success.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Transaksi Berhasil!!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3B4FFF),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kamu berhasil membayar tagihan listrik!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // balik ke detail dengan status DONE
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
