import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE1EC),
              Color(0xFFFFF7ED),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // APPBAR CUTE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: const [
                    Icon(
                      Icons.dashboard_customize_rounded,
                      color: Color(0xFFE75480),
                      size: 26,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "DASHBOARD",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Color(0xFF3B2430),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // WELCOME CONTENT
              Column(
                children: const [
                  Text(
                    "⌯(｡´‿`｡)⌯",
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xFFE75480),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "✨A little corner of calm just for you ♡",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB56A7C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // CARD MENU — SUDAH DIRAPIKAN
              Container(
                width: 340,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.25),
                      blurRadius: 24,
                      spreadRadius: 3,
                      offset: const Offset(0, 6),
                    )
                  ],
                  border: Border.all(
                    color: const Color(0xFFFFA7C0),
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "kamu bisa isi di sini ✿",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A3F53),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // MENU ICONS — DIRAPIKAN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _menuItem(
                          icon: Icons.assignment_turned_in_rounded,
                          text: "Tugas",
                          onTap: () {},
                        ),
                        _menuItem(
                          icon: Icons.person,
                          text: "Profile",
                          onTap: () {},
                        ),
                        _menuItem(
                          icon: Icons.logout,
                          text: "Logout",
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ITEM MENU MINI CHIP — RAPIH!
  Widget _menuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBF3),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFFE75480)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7A3F53),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
