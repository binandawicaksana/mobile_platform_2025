import 'package:flutter/material.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // FOTO PROFIL
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage("assets/images/foto.jpg"),
              ),

              const SizedBox(height: 16),

              const Text(
                "Fredy",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Fredy@sapulidi.com",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              // MENU LIST
              _menuItem(context, Icons.person, "Profil"),
              _menuItem(context, Icons.settings, "Pengaturan",
                  page: const SettingsPage()),
              _menuItem(context, Icons.mail, "Kontak"),
              _menuItem(context, Icons.share, "Bagikan"),
              _menuItem(context, Icons.help_outline, "Bantuan"),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Keluar",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // MENU ITEM — dengan halaman tujuan opsional
  // =====================================================
  Widget _menuItem(BuildContext context, IconData icon, String title,
      {Widget? page}) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}