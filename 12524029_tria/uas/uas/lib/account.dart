import 'package:flutter/material.dart';
import 'theme_const.dart';
import 'login.dart';
import 'bottom_nav.dart';
import 'ticket.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String name = 'Tria Agustin';
  String email = 'triacantik@gmail.com';
  String language = 'Indonesia';
  String payment = 'Belum dipilih';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      bottomNavigationBar: const MainBottomNav(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/profil.jpeg'),
            ),
            const SizedBox(height: 12),
            Text(name,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(email, style: const TextStyle(color: Colors.white, fontSize: 13)),
            const SizedBox(height: 24),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          children: [
                            _MenuItem(
                              icon: Icons.person_outline,
                              title: 'Edit Profil',
                              onTap: _editProfile,
                            ),
                            _MenuItem(
                              icon: Icons.language,
                              title: 'Bahasa',
                              trailing: language,
                              onTap: _chooseLanguage,
                            ),
                            _MenuItem(
                              icon: Icons.credit_card,
                              title: 'Metode Pembayaran',
                              trailing: payment == 'Belum dipilih' ? null : payment,
                              onTap: _choosePayment,
                            ),
                            _MenuItem(
                              icon: Icons.receipt_long,
                              title: 'Riwayat Transaksi',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TicketScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            _MenuItem(
                              icon: Icons.power_settings_new,
                              title: 'Keluar',
                              destructive: true,
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  (route) => false,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editProfile() async {
    final nameCtl = TextEditingController(text: name);
    final emailCtl = TextEditingController(text: email);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final insets = MediaQuery.of(ctx).viewInsets;
        return Padding(
          padding: EdgeInsets.only(bottom: insets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtl,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailCtl,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      name = nameCtl.text.trim().isEmpty ? name : nameCtl.text.trim();
                      email = emailCtl.text.trim().isEmpty ? email : emailCtl.text.trim();
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _chooseLanguage() async {
    final langs = ['Indonesia', 'English', 'Bahasa Melayu'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: langs
              .map((e) => ListTile(
                    title: Text(e),
                    trailing: e == language ? const Icon(Icons.check, color: kPrimaryColor) : null,
                    onTap: () => Navigator.pop(ctx, e),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      setState(() => language = selected);
    }
  }

  Future<void> _choosePayment() async {
    final methods = ['BCA', 'BNI', 'BRI', 'Gopay', 'OVO', 'ShopeePay'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: methods.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (c, i) => ListTile(
            title: Text(methods[i]),
            trailing: methods[i] == payment ? const Icon(Icons.check, color: kPrimaryColor) : null,
            onTap: () => Navigator.pop(ctx, methods[i]),
          ),
        ),
      ),
    );
    if (selected != null) {
      setState(() => payment = selected);
    }
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final bool destructive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(icon, color: destructive ? Colors.red : Colors.black87),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: destructive ? Colors.red : Colors.black87)),
              ),
              if (trailing != null)
                Text(trailing!,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
