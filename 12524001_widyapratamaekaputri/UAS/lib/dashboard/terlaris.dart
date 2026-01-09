import 'package:flutter/material.dart';
import 'order_store.dart';

class TerlarisPage extends StatelessWidget {
  const TerlarisPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kumpulkan semua pesanan dari store
    final allOrders = <OrderItem>[
      ...OrderStore.diproses,
      ...OrderStore.dikemas,
      ...OrderStore.dikirim,
      ...OrderStore.selesai,
    ];

    // Agregasi jumlah terjual per produk (berdasarkan name+imgUrl)
    final Map<String, _Agg> agg = {};
    for (final o in allOrders) {
      final key = '${o.name}||${o.imgUrl}';
      final cur = agg[key];
      if (cur == null) {
        agg[key] = _Agg(name: o.name, price: o.price, imgUrl: o.imgUrl, totalQty: o.qty);
      } else {
        cur.totalQty += o.qty;
        // Simpan harga terakhir yang terlihat (asumsi stabil)
        cur.price = o.price;
      }
    }

    // Urutkan dari yang paling banyak terjual
    final popular = agg.values.toList()
      ..sort((a, b) => b.totalQty.compareTo(a.totalQty));

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: const Text(
                'Terlaris: urut berdasarkan jumlah pembelian terbanyak dari pesanan kamu.',
                style: TextStyle(fontSize: 12.5),
              ),
            ),
            const SizedBox(height: 8),
            if (popular.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('Belum ada data pembelian'),
                ),
              )
            else
              ...popular.map((p) => Card(
                    color: const Color(0xFFFFFBF5),
                    child: ListTile(
                      leading: _leadingThumb(p.imgUrl),
                      title: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${p.price} • Terjual: ${p.totalQty}'),
                      trailing: const Icon(Icons.local_fire_department_outlined, color: Colors.redAccent),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _Agg {
  String name;
  String price;
  String imgUrl;
  int totalQty;
  _Agg({required this.name, required this.price, required this.imgUrl, required this.totalQty});
}

Widget _leadingThumb(String imgUrl) {
  if (imgUrl.startsWith('icon:')) {
    switch (imgUrl) {
      case 'icon:pulsa':
        return const CircleAvatar(child: Icon(Icons.phone_android));
      case 'icon:data':
        return const CircleAvatar(child: Icon(Icons.data_saver_off));
      default:
        return const CircleAvatar(child: Icon(Icons.image));
    }
  }
  return ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: Image.network(
      imgUrl,
      width: 44,
      height: 44,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const CircleAvatar(child: Icon(Icons.image_not_supported)),
    ),
  );
}
