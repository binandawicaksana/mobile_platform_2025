import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'faq_page.dart';
import 'login.dart';
import 'settings_page.dart';
import 'uts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4C6FFF),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEEF2FF),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/uts': (context) => const UtsPage(),
        '/settings': (context) => const SettingsPage(),
        '/faq': (context) => const FaqPage(),
      },
    );
  }
}
