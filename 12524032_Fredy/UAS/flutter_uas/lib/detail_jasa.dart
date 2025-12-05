import 'package:flutter/material.dart';
import 'cart_page.dart';

class DetailJasaPage extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;

  const DetailJasaPage({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Header Image ----------------
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(color: Colors.purple.shade100),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),

                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, color: Colors.black),
                  ),
                ),
              ],
            ),

            // ---------------- Title & Price ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- Rating ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  SizedBox(width: 4),
                  Text(
                    "4.5 (20 Review)",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- Deskripsi ----------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Deskripsi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Premium Clean adalah layanan pembersihan menyeluruh dengan hasil maksimal. "
                "Membersihkan setiap sudut ruangan agar tampak segar, wangi, dan rapi seperti baru. "
                "Cocok untuk Anda yang ingin kebersihan total tanpa repot.",
                style: TextStyle(color: Colors.black87, height: 1.5),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- Luas Area ----------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Luas Area",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _areaBox("8"),
                  const SizedBox(width: 8),
                  _areaBox("10"),
                  const SizedBox(width: 8),
                  _areaBox("38"),
                  const SizedBox(width: 8),
                  _areaBox("40"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- Button ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },

                  child: const Text(
                    "Pesan Sekarang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _areaBox(String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
