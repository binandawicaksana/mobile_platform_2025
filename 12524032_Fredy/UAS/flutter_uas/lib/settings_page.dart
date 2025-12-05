import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= Akun =================
            const Text(
              "Akun",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage("assets/images/foto.jpg"),
                  ),
                  const SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Fredy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Fredy@sapulidi.com",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.black),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Divider
            Divider(color: Colors.grey.shade300),

            const SizedBox(height: 12),

            // ================= Pengaturan =================
            const Text(
              "Pengaturan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _menuItem(Icons.notifications_none, "Notifikasi"),
            _menuItem(Icons.language, "Bahasa", trailingText: "Indonesia"),
            _menuItem(Icons.lock_outline, "Privasi"),
            _menuItem(Icons.headphones_outlined, "Pusat Bantuan"),
            _menuItem(Icons.info_outline, "Tentang Kami"),
          ],
        ),
      ),
    );
  }

  // ================================
  // WIDGET MENU ITEM
  // ================================
  Widget _menuItem(
    IconData icon,
    String title, {
    String? trailingText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          if (trailingText != null) ...[
            Text(
              trailingText,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
          ],

          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.black54),
        ],
      ),
    );
  }
}