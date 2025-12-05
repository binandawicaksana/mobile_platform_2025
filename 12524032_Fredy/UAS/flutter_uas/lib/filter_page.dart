import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedLayanan = 0;
  int selectedTipe = 1;
  int selectedArea = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Filter",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===================== LAYANAN ====================
            const Text(
              "Layanan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _chip("All", 0, selectedLayanan, (v) => setState(() => selectedLayanan = v)),
                _chip("Termahal", 1, selectedLayanan, (v) => setState(() => selectedLayanan = v)),
                _chip("Termurah", 2, selectedLayanan, (v) => setState(() => selectedLayanan = v)),
              ],
            ),

            const SizedBox(height: 24),

            // ===================== TIPE PEMBERSIHAN ====================
            const Text(
              "Tipe Pembersihan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _chip("Harian", 0, selectedTipe, (v) => setState(() => selectedTipe = v)),
                _chip("Mingguan", 1, selectedTipe, (v) => setState(() => selectedTipe = v)),
                _chip("Bulanan", 2, selectedTipe, (v) => setState(() => selectedTipe = v)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _chip("Tahunan", 3, selectedTipe, (v) => setState(() => selectedTipe = v)),
              ],
            ),

            const SizedBox(height: 24),

            // ===================== RANGE HARGA ====================
            const Text(
              "Harga",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Rp475.000"),
                Text("Rp1.000.000"),
              ],
            ),

            const SizedBox(height: 6),
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 24),

            // ===================== AREA PEMBERSIHAN ====================
            const Text(
              "Area Pembersihan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _chip("Kamar", 0, selectedArea, (v) => setState(() => selectedArea = v)),
                _chip("Dapur", 1, selectedArea, (v) => setState(() => selectedArea = v)),
                _chip("Toilet", 2, selectedArea, (v) => setState(() => selectedArea = v)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _chip("Kantor", 3, selectedArea, (v) => setState(() => selectedArea = v)),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Text("Opsi Lainnya"),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 18),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ===================== BUTTON ====================
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Terapkan Filter",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CHIP GENERATOR
  Widget _chip(String text, int value, int selected, Function(int) onSelected) {
    final bool active = value == selected;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => onSelected(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.deepPurple : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}