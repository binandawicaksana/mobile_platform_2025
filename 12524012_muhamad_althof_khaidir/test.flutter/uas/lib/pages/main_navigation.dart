import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'news_page.dart';
import 'calendar_page.dart';
import 'live_tv_page.dart';
import 'shop_page.dart';


class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    NewsPage(),
    CalendarPage(),
    LiveTVPage(),
    ShopPage(),
  ];

  void _onTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],   // halaman berubah di sini

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 244, 238, 53),
        backgroundColor: const Color(0xff003b7a),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: _onTapped,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: "Today",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: "Live TV",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Shop",
          ),
        ],
      ),
    );
  }
}
