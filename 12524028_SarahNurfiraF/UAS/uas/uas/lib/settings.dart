import 'package:flutter/material.dart';
import 'theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifEnabled = true;
  bool biometricsEnabled = false;
  String themeMode = 'Terang';
  String language = 'Indonesia';

  // UI-only: no persistence, no side-effects

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE0ED),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF5B2B3A)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _Section(title: 'Akun', children: [
            _Item(
              icon: Icons.person_outline,
              title: 'Profil',
              subtitle: 'Nama, email, dan foto',
              onTap: () => _info(context),
            ),
            _Item(
              icon: Icons.lock_outline,
              title: 'Keamanan',
              subtitle: 'Password & verifikasi',
              onTap: () => _info(context),
            ),
          ]),
          const SizedBox(height: 12),
          _Section(title: 'Tampilan', children: [
            _Item(
              icon: Icons.color_lens_outlined,
              title: 'Tema',
              subtitle: themeMode,
              onTap: _chooseTheme,
            ),
            _Item(
              icon: Icons.language_outlined,
              title: 'Bahasa',
              subtitle: language,
              onTap: _chooseLanguage,
            ),
          ]),
          const SizedBox(height: 12),
          _Section(title: 'Preferensi', children: [
            SwitchListTile.adaptive(
              value: notifEnabled,
              onChanged: (v) {
                setState(() => notifEnabled = v);
              },
              secondary: const Icon(Icons.notifications_none, color: Color(0xFFB45F4B)),
              title: const Text('Notifikasi'),
              subtitle: const Text('Aktifkan pemberitahuan aplikasi'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              activeColor: const Color(0xFFFF4F8C),
            ),
            SwitchListTile.adaptive(
              value: biometricsEnabled,
              onChanged: (v) {
                setState(() => biometricsEnabled = v);
              },
              secondary: const Icon(Icons.fingerprint, color: Color(0xFFB45F4B)),
              title: const Text('Kunci Biometrik'),
              subtitle: const Text('Gunakan sidik jari/face ID'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              activeColor: const Color(0xFFFF4F8C),
            ),
          ]),
          const SizedBox(height: 12),
          _Section(title: 'Tentang', children: const [
            _AboutItem(),
          ]),
        ],
      ),
    );
  }

  void _info(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hanya tampilan (UI), belum terhubung.')),
    );
  }

  void _chooseTheme() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _PickerSheet(
        title: 'Pilih Tema',
        options: const ['Terang', 'Gelap', 'Sistem'],
        current: themeMode,
      ),
    );
    if (selected != null) {
      setState(() => themeMode = selected);
      ThemeController.instance.setFromLabel(selected);
    }
  }

  void _chooseLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _PickerSheet(
        title: 'Pilih Bahasa',
        options: const ['Indonesia', 'English'],
        current: language,
      ),
    );
    if (selected != null) setState(() => language = selected);
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8A5640),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _Item({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB45F4B)),
      title: Text(title, style: const TextStyle(color: Color(0xFF5B2B3A), fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: Color(0xFF9C6E86))) : null,
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFB889A1)),
      onTap: onTap,
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String current;

  const _PickerSheet({
    required this.title,
    required this.options,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B2B3A),
              ),
            ),
            const SizedBox(height: 8),
            ...options.map((e) => RadioListTile<String>(
                  value: e,
                  groupValue: current,
                  onChanged: (v) => Navigator.pop(context, v),
                  activeColor: const Color(0xFFFF4F8C),
                  title: Text(e),
                )),
          ],
        ),
      ),
    );
  }
}

class _AboutItem extends StatelessWidget {
  const _AboutItem();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline, color: Color(0xFFB45F4B)),
      title: const Text('Premium Inventory'),
      subtitle: const Text('Versi 1.0.0'),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFB889A1)),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationIcon: const FlutterLogo(),
          applicationName: 'Premium Inventory',
          applicationVersion: '1.0.0',
          children: const [
            Text('Aplikasi inventori sederhana. (Halaman ini hanya UI).'),
          ],
        );
      },
    );
  }
}
