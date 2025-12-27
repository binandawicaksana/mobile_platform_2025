import 'package:flutter/material.dart';
import 'activity_page.dart';
import 'message_page.dart';
import 'change_password_page.dart';

class AccountPage extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const AccountPage({super.key, required this.activities});

  Color get primaryPurple => const Color(0xFF5B2ECC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 60),
            _buildMenuList(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ================= HEADER UNGU + FOTO PROFIL =================

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: primaryPurple,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              const Text(
                'Akun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -40,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/PP.png'),
              ),
              const SizedBox(height: 8),
              Text(
                'Rizikra',
                style: TextStyle(
                  color: primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= LIST MENU (Password, Bahasa, CS) =================

  Widget _buildMenuList(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Password', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Bahasa', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    // nanti bisa diisi dialog pemilihan bahasa
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text(
                    'Customer Service',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: const Text(
                    '19008888',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    // bisa diisi panggilan telp / whatsapp dsb.
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM NAV =================

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HOME
                    IconButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(
                        Icons.home_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),

                    // AKTIVITAS
                    IconButton(
                      icon: const Icon(
                        Icons.list_alt,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ActivityPage(activities: activities),
                          ),
                        );
                      },
                    ),

                    // PESAN
                    IconButton(
                      icon: const Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MessagePage(activities: activities),
                          ),
                        );
                      },
                    ),

                    // AKUN (aktif – pill ungu)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primaryPurple,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.settings_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Akun',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
