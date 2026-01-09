import 'package:flutter/material.dart';
import 'cekpesanan.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(visible: false, child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Text(
                  'Notifikasi: pantau promo, status pesanan, dan info penting lainnya agar tidak ketinggalan update — mirip pusat notifikasi Shopee.',
                  style: TextStyle(fontSize: 12.5),
                ),
              )),
              Center(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45F4B),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CekPesananPage()),
                      );
                    },
                    child: const Text("Cek Pesanan"),
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
