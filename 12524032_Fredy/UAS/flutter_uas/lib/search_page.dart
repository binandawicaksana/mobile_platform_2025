import 'package:flutter/material.dart';
import 'detail_jasa.dart';
import 'filter_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  // DATA JASA
  final List<Map<String, dynamic>> jasaList = [
    {
      "title": "Premium Clean",
      "price": "Rp200.000",
      "image": "assets/images/foto.jpg",
    },
    {
      "title": "Deep Clean",
      "price": "Rp100.000",
      "image": "assets/images/foto.jpg",
    },
    {
      "title": "Basic Clean",
      "price": "Rp50.000",
      "image": "assets/images/foto.jpg",
    },
  ];

  List<Map<String, dynamic>> hasil = [];

  void _lakukanPencarian(String keyword) {
    final query = keyword.toLowerCase();

    setState(() {
      hasil = jasaList.where((item) {
        return item["title"].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Tombol back
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),

            // Kolom Pencarian
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: _lakukanPencarian,
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Cari layanan...",
                        ),
                      ),
                    ),

                    // Tombol clear (X)
                    GestureDetector(
                      onTap: () {
                        searchController.clear();
                        _lakukanPencarian('');
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Pencarian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hasil Pencarian “ ${searchController.text} “',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // TOMBOL FILTER
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FilterPage()),
                    );
                  },
                  child: const Text(
                    "Filter",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ================== HASIL GRID ==================
            Expanded(
              child: hasil.isEmpty
                  ? const Center(
                      child: Text(
                        "Tidak ada hasil ditemukan",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: hasil.map((item) {
                        return _hasilCard(item);
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================
  // CARD HASIL PENCARIAN
  // ================================
  Widget _hasilCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailJasaPage(
              title: data["title"],
              price: data["price"],
              imagePath: data["image"],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffEFE6FF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(data["image"], height: 90),

            const SizedBox(height: 8),

            Text(
              data["title"],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),

            Text(
              data["price"],
              style: const TextStyle(color: Colors.blue, fontSize: 13),
            ),

            const Spacer(),

            Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
