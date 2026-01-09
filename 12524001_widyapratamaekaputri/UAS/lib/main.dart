import 'package:flutter/material.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard/settings_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SettingsStore.themeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "UAS Shop",
          themeMode: mode,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFFFF3E8),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB45F4B)),
            useMaterial3: true,
            textTheme: GoogleFonts.fredokaTextTheme(),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB45F4B), brightness: Brightness.dark),
            useMaterial3: true,
            textTheme: GoogleFonts.fredokaTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9A679),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shopping_bag_outlined, size: 90, color: Colors.black),
            SizedBox(height: 12),
            Text(
              "UAS Shop",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
