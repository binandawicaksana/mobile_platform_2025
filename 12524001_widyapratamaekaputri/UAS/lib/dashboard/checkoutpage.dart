import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'order_store.dart';
import 'profile_store.dart';
import 'pesananberhasil.dart';

class CheckoutPage extends StatefulWidget {
  final String name;
  final String price;
  final String eta;
  final String imgUrl;
  final int qty;

  const CheckoutPage({
    super.key,
    required this.name,
    required this.price,
    required this.eta,
    required this.imgUrl,
    required this.qty,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int selectedMethod = 0;
  final methods = const [
    'QRIS',
    'Transfer Bank',
    'E-Wallet',
    'COD',
  ];

  // Transfer Bank (VA-like) helpers
  String? transferCode;
  int selectedBank = 0;
  final banks = const ['BCA', 'BRI', 'BNI', 'Mandiri'];

  int _parsePrice(String p) {
    final clean = p.replaceAll('Rp', '').replaceAll('.', '').trim();
    return int.tryParse(clean) ?? 0;
  }

  String formatRp(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write('.');
    }
    return 'Rp${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.name;
    final price = widget.price;
    final eta = widget.eta;
    final imgUrl = widget.imgUrl;
    final qty = widget.qty;

    final itemPrice = _parsePrice(price);
    final shipping = 9000; // sesuai desain
    final subtotal = itemPrice * qty;
    final total = subtotal + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFBFA07A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFA07A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                // Alamat
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E0C8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          ProfileStore.address,
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Produk
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E0C8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              price,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('x$qty', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Pengiriman
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E0C8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Regular', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          Text(
                            formatRp(shipping),
                            style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text(eta, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Metode Pembayaran interaktif
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E0C8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black26),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Metode Pembayaran',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: List.generate(methods.length, (i) {
                      final active = selectedMethod == i;
                      return ChoiceChip(
                        label: Text(methods[i]),
                        selected: active,
                        onSelected: (_) => setState(() {
                          selectedMethod = i;
                          // reset transfer code state when switching methods
                          if (i != 1) transferCode = null;
                        }),
                        selectedColor: const Color(0xFF8B6B3F),
                        labelStyle: TextStyle(
                          color: active ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  ),
                  // Extra UI when choosing Transfer Bank
                  if (selectedMethod == 1) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Transfer Bank',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text('Pilih Bank: '),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: selectedBank,
                          items: List.generate(
                            banks.length,
                            (i) => DropdownMenuItem(value: i, child: Text(banks[i])),
                          ),
                          onChanged: (v) => setState(() {
                            selectedBank = v ?? 0;
                            transferCode = null; // ganti bank, reset code
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (transferCode == null)
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () {
                            final prefix = {
                              'BCA': '014',
                              'BRI': '002',
                              'BNI': '009',
                              'Mandiri': '008',
                            }[banks[selectedBank]]!;
                            final rnd = Random();
                            final code = List.generate(10, (_) => rnd.nextInt(10)).join();
                            setState(() => transferCode = '$prefix$code');
                          },
                          child: const Text('Buat Nomor Pembayaran (VA)'),
                        ),
                      )
                    else ...[
                      SelectableText('Nomor VA ${banks[selectedBank]}: $transferCode'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                if (transferCode == null) return;
                                await Clipboard.setData(ClipboardData(text: transferCode!));
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Nomor VA disalin')),
                                );
                              },
                              child: const Text('Salin'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Transfer ke nomor VA melalui mBanking/ATM/E-Wallet.'),
                                  ),
                                );
                              },
                              child: const Text('Instruksi'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                  const SizedBox(height: 6),
                  const Text(
                    'Tips: Pilih metode yang paling nyaman. Pembayaran diproses aman dan cepat.',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Subtotal
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E0C8),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Subtotal pesanan',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(child: Text('Subtotal Pembayaran', style: TextStyle(fontSize: 12))),
                          Text(
                            formatRp(subtotal),
                            style: const TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text('Biaya pengiriman', style: TextStyle(fontSize: 12))),
                          Text(
                            formatRp(shipping),
                            style: const TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Total pembayaran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                          Text(
                            formatRp(total),
                            style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar total + checkout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF4E0C8),
              border: Border(top: BorderSide(color: Colors.black26)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 11)),
                      Text(
                        formatRp(total),
                        style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45F4B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                    label: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700)),
                    onPressed: () {
                      String method = methods[selectedMethod];
                      // Auto-generate code if Transfer Bank selected but no code yet
                      if (selectedMethod == 1 && transferCode == null) {
                        final prefix = {
                          'BCA': '014',
                          'BRI': '002',
                          'BNI': '009',
                          'Mandiri': '008',
                        }[banks[selectedBank]]!;
                        final rnd = Random();
                        final code = List.generate(10, (_) => rnd.nextInt(10)).join();
                        transferCode = '$prefix$code';
                      }
                      if (selectedMethod == 1 && transferCode != null) {
                        method = 'Transfer Bank - ${banks[selectedBank]} (VA: $transferCode)';
                      }
                      OrderStore.diproses.add(
                        OrderItem(
                          name: name,
                          price: price,
                          eta: eta,
                          imgUrl: imgUrl,
                          qty: qty,
                          shipping: shipping,
                          paymentMethod: method,
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PesananBerhasilPage(
                            name: name,
                            price: price,
                            eta: eta,
                            imgUrl: imgUrl,
                            qty: qty,
                            shipping: shipping,
                            paymentMethod: method,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
