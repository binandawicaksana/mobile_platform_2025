import 'package:flutter/material.dart';
import 'settings_store.dart';
import 'cart_store.dart';
import 'wallet_store.dart';
import 'package:flutter/foundation.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _Section(
            title: 'Notifikasi',
            child: Column(
              children: [
                SwitchListTile(
                  value: SettingsStore.notifPromo,
                  title: const Text('Promo & Penawaran'),
                  onChanged: (v) =>
                      setState(() => SettingsStore.notifPromo = v),
                ),
                SwitchListTile(
                  value: SettingsStore.notifStatus,
                  title: const Text('Status Pesanan'),
                  onChanged: (v) =>
                      setState(() => SettingsStore.notifStatus = v),
                ),
              ],
            ),
          ),

          _Section(
            title: 'Preferensi',
            child: Column(
              children: [
                ListTile(
                  leading: _circleIcon(Icons.language),
                  title: const Text('Bahasa'),
                  trailing: DropdownButton<String>(
                    value: SettingsStore.language,
                    items: const [
                      DropdownMenuItem(value: 'id', child: Text('Indonesia')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                    onChanged: (v) =>
                        setState(() => SettingsStore.language = v ?? 'id'),
                  ),
                ),
                ListTile(
                  leading: _circleIcon(Icons.attach_money_outlined),
                  title: const Text('Mata Uang'),
                  trailing: DropdownButton<String>(
                    value: SettingsStore.currency,
                    items: const [
                      DropdownMenuItem(value: 'IDR', child: Text('IDR (Rp)')),
                      DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                    ],
                    onChanged: (v) =>
                        setState(() => SettingsStore.currency = v ?? 'IDR'),
                  ),
                ),
                SwitchListTile(
                  value: SettingsStore.privacyHideAmount,
                  title: const Text('Sembunyikan nominal di notifikasi'),
                  onChanged: (v) =>
                      setState(() => SettingsStore.privacyHideAmount = v),
                ),
              ],
            ),
          ),

          _Section(
            title: 'Tampilan & Keamanan',
            child: Column(
              children: [
                ListTile(
                  leading: _circleIcon(Icons.color_lens_outlined),
                  title: const Text('Tema Aplikasi'),
                  trailing: DropdownButton<ThemeMode>(
                    value: SettingsStore.themeMode.value,
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Terang'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Gelap'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('Ikuti Sistem'),
                      ),
                    ],
                    onChanged: (v) => setState(
                      () =>
                          SettingsStore.themeMode.value = v ?? ThemeMode.light,
                    ),
                  ),
                ),
                SwitchListTile(
                  value: SettingsStore.lockShopPay,
                  title: const Text('Kunci ShopPay (PIN)'),
                  onChanged: (v) {
                    setState(() => SettingsStore.lockShopPay = v);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          v
                              ? 'Kunci ShopPay diaktifkan (contoh)'
                              : 'Kunci ShopPay dimatikan',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          _Section(
            title: 'Utilitas',
            child: Column(
              children: [
                ListTile(
                  leading: _circleIcon(Icons.cleaning_services_outlined),
                  title: const Text('Kosongkan Keranjang'),
                  onTap: () {
                    CartStore.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Keranjang dikosongkan')),
                    );
                  },
                ),
                ListTile(
                  leading: _circleIcon(Icons.receipt_long_outlined),
                  title: const Text('Hapus Riwayat ShopPay'),
                  onTap: () {
                    WalletStore.history.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Riwayat ShopPay dihapus')),
                    );
                  },
                ),
                ListTile(
                  leading: _circleIcon(Icons.info_outline),
                  title: const Text('Tentang Aplikasi'),
                  subtitle: const Text('UAS Mobile Platform 2025'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFBF5), Color(0xFFF4E0C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              border: Border.all(color: Colors.black12, width: 0.5),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

Widget _circleIcon(IconData icon) {
  return Container(
    width: 36,
    height: 36,
    decoration: const BoxDecoration(
      color: Color(0xFFF4E0C8),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: Color(0xFFB45F4B)),
  );
}
