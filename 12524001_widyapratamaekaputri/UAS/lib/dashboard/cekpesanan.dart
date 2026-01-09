import 'package:flutter/material.dart';
import 'order_store.dart';
import 'detailbarang.dart';

class CekPesananPage extends StatefulWidget {
  const CekPesananPage({super.key});

  @override
  State<CekPesananPage> createState() => _CekPesananPageState();
}

class _CekPesananPageState extends State<CekPesananPage>
    with SingleTickerProviderStateMixin {
  late TabController tabC;

  @override
  void initState() {
    super.initState();
    tabC = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diproses = OrderStore.diproses;
    final dikirim = OrderStore.dikirim;
    final selesai = OrderStore.selesai;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        elevation: 0,
        title: const Text(
          'Cek Pesanan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        bottom: TabBar(
          controller: tabC,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'Diproses'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabC,
        children: [
          // Diproses -> Dikirim
          _buildList(
            diproses,
            emptyText: 'Belum ada pesanan diproses',
            actionLabel: 'Kirim',
            onAction: (i) => _moveItem(OrderStore.diproses, OrderStore.dikirim, i),
          ),

          // Dikirim -> Selesai
          _buildList(
            dikirim,
            emptyText: 'Belum ada pesanan dikirim',
            actionLabel: 'Selesai',
            onAction: (i) => _moveItem(OrderStore.dikirim, OrderStore.selesai, i),
          ),

          // Selesai (tanpa aksi)
          _buildList(
            selesai,
            emptyText: 'Belum ada pesanan selesai',
          ),
        ],
      ),
    );
  }

  void _moveItem(List<OrderItem> from, List<OrderItem> to, int index) {
    setState(() {
      to.add(from.removeAt(index));
    });
  }

  Widget _buildList(
    List<OrderItem> items, {
    required String emptyText,
    String? actionLabel,
    void Function(int index)? onAction,
  }) {
    if (items.isEmpty) {
      return Center(child: Text(emptyText));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final o = items[i];
        return Card(
          color: const Color(0xFFFFFBF5),
          child: ListTile(
            leading: _leadingThumb(o.imgUrl),
            title: Text(
              o.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(o.price, style: const TextStyle(color: Colors.red)),
                Text(
                  'Qty: ${o.qty} • Estimasi: ${o.eta}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Metode: ${o.paymentMethod}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onAction != null && actionLabel != null)
                  TextButton(
                    onPressed: () => onAction(i),
                    child: Text(actionLabel),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailBarangPage(
                    name: o.name,
                    price: o.price,
                    sold: 'Pesanan kamu',
                    eta: o.eta,
                    imgUrl: o.imgUrl,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _leadingThumb(String imgUrl) {
    if (imgUrl.startsWith('icon:')) {
      IconData icon;
      if (imgUrl.contains('pulsa')) {
        icon = Icons.sim_card_outlined;
      } else if (imgUrl.contains('data')) {
        icon = Icons.data_usage;
      } else {
        icon = Icons.shopping_bag_outlined;
      }
      return Container(
        width: 55,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF5),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, color: const Color(0xFFB45F4B)),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        imgUrl,
        width: 55,
        height: 55,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 55,
          height: 55,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black12),
          ),
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}
