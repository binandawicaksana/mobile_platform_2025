import 'package:flutter/material.dart';

class JasaPage extends StatelessWidget {
  const JasaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Jasa",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _jasaCard("Deep Clean", "Rp100.000", "assets/deep_clean.png"),
            _jasaCard("Premium Clean", "Rp200.000", "assets/premium_clean.png"),
            _jasaCard("Basic Clean", "Rp50.000", "assets/basic_clean.png"),
          ],
        ),
      ),
    );
  }

  Widget _jasaCard(String title, String price, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Image.asset(imagePath, height: 85),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(color: Colors.blue)),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}