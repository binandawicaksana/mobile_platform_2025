import 'package:flutter/material.dart';
import 'theme_const.dart';
import 'order_complete.dart';

class ReviewOrderScreen extends StatelessWidget {
  final int rendangQty;
  final int nasiGorengQty;
  final int steakAyamQty;

  const ReviewOrderScreen({
    super.key,
    required this.rendangQty,
    required this.nasiGorengQty,
    required this.steakAyamQty,
  });

  int get subtotal =>
      rendangQty * 50000 + nasiGorengQty * 35000 + steakAyamQty * 48000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context, 'Review Pesanan'),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (rendangQty > 0) _reviewItem('Rendang', 50000, rendangQty),
                    if (nasiGorengQty > 0) _reviewItem('Nasi Goreng', 35000, nasiGorengQty),
                    if (steakAyamQty > 0) _reviewItem('Steak Ayam', 48000, steakAyamQty),

                    const Divider(thickness: 2),
                    _rowTotal('Subtotal', subtotal),
                    _rowTotal('Total', subtotal),
                    const Divider(thickness: 2),

                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pemesan', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Tria Agustin'),
                          ],
                        ),
                        Text('LionAir123', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(thickness: 2),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Pilih Metode Pembayaran',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transfer Bank'),
                        Text('Mandiri', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Spacer(),

                    SizedBox(
                      width: 220,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const OrderCompleteScreen()),
                          );
                        },
                        child: const Text('Pesan Sekarang',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BackButton(color: Colors.white),
          Text(title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _reviewItem(String name, int price, int qty) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Rp. $price',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F1FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('$qty x', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _rowTotal(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Rp. $value', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
