import 'package:flutter/material.dart';
import 'cekpesanan.dart';

class PesananBerhasilPage extends StatelessWidget {
  final String name;
  final String price;
  final String eta;
  final String imgUrl;
  final int qty;
  final int shipping;
  final String paymentMethod;

  const PesananBerhasilPage({
    super.key,
    required this.name,
    required this.price,
    required this.eta,
    required this.imgUrl,
    required this.qty,
    required this.shipping,
    required this.paymentMethod,
  });

  int _parsePrice(String p) {
    final clean = p.replaceAll("Rp", "").replaceAll(".", "").trim();
    return int.tryParse(clean) ?? 0;
  }

  String _formatRp(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(".");
    }
    return "Rp${buf.toString()}";
  }

  @override
  Widget build(BuildContext context) {
    final itemPrice = _parsePrice(price);
    final subtotal = itemPrice * qty;
    final total = subtotal + shipping;

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
              _row('Produk', name),
              _row('Qty', qty.toString()),
              _row('Harga', price),
              _row('Ongkir', _formatRp(shipping)),
              _row('Metode', paymentMethod),
              const Divider(height: 18),
              _row('Total', _formatRp(total), isBold: true, color: Colors.red),
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

