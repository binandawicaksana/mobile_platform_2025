import 'package:flutter/material.dart';
import 'cart_store.dart';
import 'order_store.dart';
import 'cekpesanan.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  int selectedMethod = 0;
  final methods = const ['QRIS', 'Transfer Bank', 'E-Wallet', 'COD'];

  int _parsePrice(String p) {
    final clean = p.replaceAll('Rp', '').replaceAll('.', '').trim();
    return int.tryParse(clean) ?? 0;
  }

  String _formatRp(int v) {
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
    final items = CartStore.items;
    final subtotal = items.fold<int>(0, (sum, it) => sum + _parsePrice(it.price) * it.qty);
    final shipping = items.isEmpty ? 0 : 9000;
    final total = subtotal + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text('Keranjang'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Keranjang kosong'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final it = items[i];
                      return Card(
                        color: const Color(0xFFFFFBF5),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              it.imgUrl,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image),
                            ),
                          ),
                          title: Text(it.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it.price, style: const TextStyle(color: Colors.red)),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() {
                                      if (it.qty > 1) it.qty--;
                                    }),
                                    icon: const Icon(Icons.remove_circle_outline),
                                    iconSize: 20,
                                  ),
                                  Text('${it.qty}'),
                                  IconButton(
                                    onPressed: () => setState(() => it.qty++),
                                    icon: const Icon(Icons.add_circle_outline),
                                    iconSize: 20,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => setState(() => items.removeAt(i)),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Metode pembayaran
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: List.generate(methods.length, (i) {
                    final active = selectedMethod == i;
                    return ChoiceChip(
                      label: Text(methods[i]),
                      selected: active,
                      onSelected: (_) => setState(() => selectedMethod = i),
                      selectedColor: const Color(0xFFB45F4B),
                      labelStyle: TextStyle(
                        color: active ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Total + Checkout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 11)),
                      Text(
                        _formatRp(total),
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
                    onPressed: items.isEmpty
                        ? null
                        : () {
                            final method = methods[selectedMethod];
                            for (final it in items) {
                              OrderStore.diproses.add(
                                OrderItem(
                                  name: it.name,
                                  price: it.price,
                                  eta: it.eta,
                                  imgUrl: it.imgUrl,
                                  qty: it.qty,
                                  shipping: shipping,
                                  paymentMethod: method,
                                ),
                              );
                            }
                            CartStore.clear();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const CekPesananPage()),
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

