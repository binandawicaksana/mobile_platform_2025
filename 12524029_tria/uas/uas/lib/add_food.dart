import 'package:flutter/material.dart';
import 'theme_const.dart';
import 'review_order.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  int rendangQty = 0;
  int nasiGorengQty = 0;
  int steakAyamQty = 0;

  int get total =>
      rendangQty * 50000 + nasiGorengQty * 35000 + steakAyamQty * 48000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context, 'Tambah Makanan'),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // ✅ RENDANG (pakai foto dari website yang kamu minta)
                      _foodRow(
                        'Rendang',
                        50000,
                        rendangQty,
                        imageUrl: 'assets/images/rendanggg.jpeg',
                        onMinus: () => setState(
                            () => rendangQty = (rendangQty > 0) ? rendangQty - 1 : 0),
                        onPlus: () => setState(() => rendangQty++),
                      ),
                    const SizedBox(height: 16),

                    // NASI GORENG
                    _foodRow(
                      'Nasi Goreng',
                      35000,
                      nasiGorengQty,
                      imageUrl:
                          'https://upload.wikimedia.org/wikipedia/commons/3/3e/Nasi_goreng_indonesia.jpg',
                      onMinus: () => setState(() =>
                          nasiGorengQty = (nasiGorengQty > 0) ? nasiGorengQty - 1 : 0),
                      onPlus: () => setState(() => nasiGorengQty++),
                    ),
                    const SizedBox(height: 16),

                    // STEAK AYAM
                    _foodRow(
                      'Steak Ayam',
                      48000,
                      steakAyamQty,
                      imageUrl:
                          'https://www.holycowsteak.com/cdn/shop/articles/cara-membuat-steak-ayam_b3a949ed-5ad8-403b-b943-04a0ca80fdef.jpg?v=1739340667',
                      onMinus: () => setState(() =>
                          steakAyamQty = (steakAyamQty > 0) ? steakAyamQty - 1 : 0),
                      onPlus: () => setState(() => steakAyamQty++),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: kPrimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(
                        'Rp. $total',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewOrderScreen(
                            rendangQty: rendangQty,
                            nasiGorengQty: nasiGorengQty,
                            steakAyamQty: steakAyamQty,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Lanjutkan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ===================== WIDGET BANTUAN =====================

  Widget _topBar(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const BackButton(color: Colors.white),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _foodRow(
    String name,
    int price,
    int qty, {
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    String? imageUrl,
  }) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: imageUrl == null
              ? const Icon(Icons.fastfood)
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fastfood),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text('Rp. $price',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F1FF),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                iconSize: 18,
                onPressed: onMinus,
              ),
              Text('$qty',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add),
                iconSize: 18,
                onPressed: onPlus,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
