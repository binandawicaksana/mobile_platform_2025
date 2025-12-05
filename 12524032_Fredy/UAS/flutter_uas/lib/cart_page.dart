import 'package:flutter/material.dart';
import 'order_detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> items = [
    {
      "title": "Premium Clean",
      "subtitle": "Cleaning Service",
      "price": "Rp200.000",
      "qty": 1,
      "image": "assets/images/foto.jpg",
    },
    {
      "title": "Deep Clean",
      "subtitle": "Cleaning Service",
      "price": "Rp100.000",
      "qty": 0,
      "image": "assets/images/foto.jpg",
    },
    {
      "title": "Basic Clean",
      "subtitle": "Cleaning Service",
      "price": "Rp50.000",
      "qty": 0,
      "image": "assets/images/foto.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Keranjang",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= LIST ITEM =================
            ...items.map((item) => _cartItem(item)).toList(),

            const SizedBox(height: 20),

            // ================= RINGKASAN PESANAN =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ringkasan Pesanan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _rowSummary("Layanan", "1"),
                  _rowSummary("Harga Sebelum Diskon", "Rp200.000"),
                  _rowSummary("Diskon", "Rp25.000"),
                  _rowSummary("Biaya Kunjungan", "Rp2.000"),

                  const Divider(height: 20),

                  _rowSummary("Total", "Rp177.000", bold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= BUTTON CHECKOUT =================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderDetailPage()),
                  );
                },

                child: const Text(
                  "Check Out",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= Item Keranjang =================
  Widget _cartItem(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // FOTO
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              data["image"],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 16),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data["subtitle"],
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  data["price"],
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // TRASH BUTTON
          Icon(Icons.delete, color: Colors.red.shade400),

          const SizedBox(width: 8),

          // DECREASE BUTTON
          _qtyButton(
            icon: Icons.remove,
            onTap: () {
              setState(() {
                if (data["qty"] > 0) data["qty"]--;
              });
            },
          ),

          const SizedBox(width: 8),

          // NUMBER
          Text(
            data["qty"].toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 8),

          // INCREASE BUTTON
          _qtyButton(
            icon: Icons.add,
            onTap: () {
              setState(() {
                data["qty"]++;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.deepPurple),
      ),
    );
  }

  Widget _rowSummary(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left),
          Text(
            right,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
