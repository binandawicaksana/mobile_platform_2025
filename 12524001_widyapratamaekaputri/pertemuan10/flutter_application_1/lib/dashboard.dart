import 'package:flutter/material.dart';
import 'login.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true, // tetap tampil tombol back

        title: const Text(
          "🍪 DASHBOARD",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        // 🔥 Tombol Logout di kanan
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.black, size: 26),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E8),
              Color(0xFFF4E0C8),
            ],
          ),
        ),

        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;

              // Responsive width
              double cardWidth =
                  maxWidth < 480 ? maxWidth * 0.90 :        // HP kecil
                  maxWidth < 900 ? maxWidth * 0.60 :        // tablet
                  600;                                      // laptop/web

              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardWidth),
                child: Card(
                  elevation: 10,
                  shadowColor: const Color(0xFFDEB79C).withOpacity(0.6),
                  color: const Color(0xFFFFFBF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: maxWidth < 500 ? 20 : 35, // responsive padding
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Selamat Datang di Dashboard 🤎✨",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: maxWidth < 500 ? 20 : 24, // responsive text
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFB45F4B),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width: 70,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9C7A3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Ini adalah halaman dashboard\nuntuk tugas UAS.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8A5640),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
