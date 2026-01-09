import 'package:flutter/material.dart';
import 'checkout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController emailController = TextEditingController();
  String selectedDiamond = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.person, color: Colors.greenAccent, size: 32),
              ),

              const SizedBox(height: 20),

              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _diamondBox("200"),
                  _diamondBox("255"),
                  _diamondBox("300"),
                  _diamondBox("105"),
                  _diamondBox("990"),
                  _diamondBox("180"),
                ],
              ),

              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Masukan email",
                    style: TextStyle(color: Colors.white70)),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "contoh@email.com",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(
                          email: emailController.text,
                          diamond: selectedDiamond,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.greenAccent, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Go",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _diamondBox(String jumlah) {
    final isSelected = selectedDiamond == jumlah;

    return GestureDetector(
      onTap: () => setState(() => selectedDiamond = jumlah),
      child: Container(
        width: 130,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.greenAccent.withOpacity(0.2) : null,
          border: Border.all(color: Colors.greenAccent, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.diamond, color: Colors.cyanAccent),
            const SizedBox(width: 6),
            Text(jumlah, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
