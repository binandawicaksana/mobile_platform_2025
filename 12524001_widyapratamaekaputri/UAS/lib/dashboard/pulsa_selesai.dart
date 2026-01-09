import 'package:flutter/material.dart';
import 'cekpesanan.dart';

class PulsaSelesaiPage extends StatelessWidget {
  final String phoneNumber;
  final String provider;
  final String nominal; // formatted Rp
  final String method;
  final String total; // formatted Rp

  const PulsaSelesaiPage({
    super.key,
    required this.phoneNumber,
    required this.provider,
    required this.nominal,
    required this.method,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 56),
              const SizedBox(height: 10),
              const Text(
                'Pembelian Berhasil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _row('Nomor', phoneNumber),
              _row('Provider', provider),
              _row('Nominal', nominal),
              _row('Metode', method),
              const Divider(height: 18),
              _row('Total', total, isBold: true, color: Colors.red),
              const SizedBox(height: 16),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CekPesananPage()),
                        );
                      },
                      child: const Text('Cek Pesanan'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                      child: const Text('Ke Beranda'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String l, String r, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(l)),
          Text(
            r,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
              color: color,
            ),
          )
        ],
      ),
    );
  }
}
