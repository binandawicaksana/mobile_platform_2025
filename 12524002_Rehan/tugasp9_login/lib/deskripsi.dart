import 'package:flutter/material.dart';

class DeskripsiPage extends StatelessWidget {
  final String namaGunung;
  final String lokasi;
  final String deskripsi;
  final bool isAgung; // biar bisa bedain foto agung / pangrango

  const DeskripsiPage({
    super.key,
    required this.namaGunung,
    required this.lokasi,
    required this.deskripsi,
    required this.isAgung,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(namaGunung),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FOTO DARI ASSETS
            Image.asset(
              isAgung
                  ? 'assets/f.jpg'
                  : 'assets/gjpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 240,
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaGunung,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    lokasi,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    deskripsi,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
