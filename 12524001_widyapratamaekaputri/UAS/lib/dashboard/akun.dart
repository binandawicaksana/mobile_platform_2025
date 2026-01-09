import 'package:flutter/material.dart';
import 'shoppaypage.dart';
import 'pulsadatapage.dart';
import 'cekpesanan.dart';
import '../login.dart';
import 'ubah_alamat.dart';
import 'profile_store.dart';
import 'pengaturan_page.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "AKUN",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Deskripsi dihilangkan sesuai permintaan
          const SizedBox.shrink(),

          const SizedBox(height: 10),

          // ===== KARTU PROFIL (Cute) =====
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD9A679), Color(0xFFBFA07A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                // Avatar dengan fallback berlapis
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF5),
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFF4E0C8),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/pages/fotoku.jpeg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Image.asset(
                          'lib/pages/fotoku.jpg',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (c2, e2, s2) => Image.asset(
                            'lib/dashboard/fotoku.jpg',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (c3, e3, s3) => Image.asset(
                              'lib/dashboard/fotoku.jpeg',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.person_outline, size: 30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Widya Pratama Eka Putri",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "@widyapratamaep15",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBF5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Member', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== BUTTON SHOPPAY =====
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45F4B),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopPayPage()),
                );
              },
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: const Text("Buka ShopPay"),
            ),
          ),

          const SizedBox(height: 10),

          // ===== ALAMAT RINGKAS =====
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(ProfileStore.address),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UbahAlamatPage()),
                    ).then((_) => (context as Element).markNeedsBuild());
                  },
                  child: const Text('Ubah'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== MENU AKUN =====
          _MenuTile(
            icon: Icons.receipt_long_outlined,
            text: "Pesanan Saya",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CekPesananPage()),
              );
            },
          ),
          _MenuTile(
            icon: Icons.location_on_outlined,
            text: "Alamat",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UbahAlamatPage()),
              );
            },
          ),
          _MenuTile(
            icon: Icons.phone_android_outlined,
            text: "Pulsa & Data",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PulsaDataPage()),
              );
            },
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            text: "Pengaturan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PengaturanPage()),
              );
            },
          ),
          _MenuTile(icon: Icons.headset_mic_outlined, text: "Bantuan"),
          _MenuTile(
            icon: Icons.logout,
            text: "Logout",
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _MenuTile({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFBF5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFF4E0C8),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFB45F4B)),
        ),
        title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        onTap: onTap ?? () {},
      ),
    );
  }
}
