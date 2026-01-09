import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1024),

      appBar: AppBar(
  backgroundColor: const Color(0xff003b7a),
  elevation: 0,
  title: const Text(
    "Pengaturan",
    style: TextStyle(color: Colors.white),
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
  ),
),

      body: ListView(
        children: const [
          _SettingItem(title: "Tim yang di follow"),
          _SettingItem(title: "Aktivitas live"),
          _SettingItem(title: "Notifikasi"),
          _SettingItem(title: "Bahasa", trailing: "Indonesia"),
          _SettingItem(title: "Tema", trailing: "Menyesuaikan sistem"),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SettingItem({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: trailing != null
          ? Text(trailing!, style: const TextStyle(color: Colors.white70))
          : const Icon(Icons.chevron_right, color: Colors.white70),
    );
  }
}
