import 'package:flutter/material.dart';
import 'theme_const.dart';
import 'home.dart';
import 'ticket.dart';
import 'dashboard.dart';
import 'account.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  const MainBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (idx) {
        if (idx == currentIndex) return;
        Widget target;
        switch (idx) {
          case 0:
            target = const HomeScreen();
            break;
          case 1:
            target = const TicketScreen();
            break;
          case 2:
            target = const DashboardPenerbanganScreen();
            break;
          case 3:
          default:
            target = const AccountScreen();
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => target),
          (route) => false,
        );
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Beli'),
        BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Penerbangan'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
      ],
    );
  }
}
