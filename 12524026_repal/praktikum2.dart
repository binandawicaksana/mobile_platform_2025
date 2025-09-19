import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latihan Mobile Platform 2025BD',
      home: const KalkulatorPage(),
    );
  }
}

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  int? hasilTambah;
  int? hasilKurang;
  int? hasilKali;
  double? hasilBagi;

  void hitung() {
    final int? a = int.tryParse(_aController.text);
    final int? b = int.tryParse(_bController.text);

    if (a != null && b != null) {
      setState(() {
        hasilTambah = a + b;
        hasilKurang = a - b;
        hasilKali = a * b;
        hasilBagi = b != 0 ? a / b : double.nan;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PS E DOSEN LABIN - Latihan Mobile Platform 2025BD"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pasukan nilai A:"),
              TextField(
                controller: _aController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan nilai A",
                ),
              ),
              const SizedBox(height: 16),

              const Text("Masukan nilai B:"),
              TextField(
                controller: _bController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan nilai B",
                ),
              ),
              const SizedBox(height: 16),

              const Text("Nama Lengkap:"),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan nama lengkap",
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: hitung,
                child: const Text("Hitung"),
              ),
              const SizedBox(height: 20),

              if (hasilTambah != null) ...[
                Text("Nama Lengkap: ${_nameController.text}"),
                Text("Hasil Penjumlahan: $hasilTambah"),
                Text("Hasil Pengurangan: $hasilKurang"),
                Text("Hasil Perkalian: $hasilKali"),
                Text("Hasil Pembagian: $hasilBagi"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}