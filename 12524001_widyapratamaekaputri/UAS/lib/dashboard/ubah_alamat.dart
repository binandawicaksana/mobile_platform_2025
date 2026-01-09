import 'package:flutter/material.dart';
import 'profile_store.dart';

class UbahAlamatPage extends StatefulWidget {
  const UbahAlamatPage({super.key});

  @override
  State<UbahAlamatPage> createState() => _UbahAlamatPageState();
}

class _UbahAlamatPageState extends State<UbahAlamatPage> {
  late final TextEditingController _addrC;

  @override
  void initState() {
    super.initState();
    _addrC = TextEditingController(text: ProfileStore.address);
  }

  @override
  void dispose() {
    _addrC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text('Ubah Alamat'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Kartu preview alamat saat ini
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFBF5), Color(0xFFF4E0C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Alamat saat ini', style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(ProfileStore.address),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 14),

          const Text('Alamat Pengiriman', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _addrC,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Masukkan alamat lengkap...\n(Contoh: Jalan, RT/RW, Kel/Desa, Kec, Kota, Kode Pos)',
              filled: true,
              fillColor: const Color(0xFFFFFBF5),
              prefixIcon: const Icon(Icons.home_outlined),
              alignLabelWithHint: true,
              labelText: 'Alamat lengkap',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45F4B),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan Alamat'),
              onPressed: () {
                final text = _addrC.text.trim();
                if (text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alamat tidak boleh kosong')),
                  );
                  return;
                }
                ProfileStore.updateAddress(text);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
