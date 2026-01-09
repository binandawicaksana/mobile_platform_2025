import 'package:flutter/material.dart';

import '../dashboard.dart'; // Home (welcome + akun)
import 'terlaris.dart';
import 'notifikasi.dart';
import 'akun.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    Dashboard(),       // Home
    TerlarisPage(),    // Terlaris
    NotifikasiPage(),  // Notifikasi
    AkunPage(),        // Akun (info singkat)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4E0C8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 28),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department_outlined, size: 28),
              label: "Terlaris",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none, size: 28),
              label: "Notifikasi",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28),
              label: "Akun",
            ),
          ],
        ),
      ),
    );
  }
}
