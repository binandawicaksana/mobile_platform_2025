import 'package:flutter/material.dart';
import 'main_navigation.dart';

class SelectContentPage extends StatelessWidget {
  const SelectContentPage({super.key});

  Widget contentCard({
    required BuildContext context,
    required String imagePath,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        // LANGSUNG KE DASHBOARD
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withOpacity(0.35),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // ===========================
              // JUDUL
              // ===========================
              const Text(
                "Pilih Sekarang!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Pilih kegemaran olahraga\nyang kamu suka",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),

              const SizedBox(height: 30),

              // ===========================
              // LIST KONTEN
              // ===========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    contentCard(
                      context: context,
                      imagePath: "assets/images/fb_boy.png",
                      title: "Football Man",
                    ),
                    contentCard(
                      context: context,
                      imagePath: "assets/images/fb_girl.png",
                      title: "Football Women",
                    ),
                    contentCard(
                      context: context,
                      imagePath: "assets/images/bsb.png",
                      title: "Basketball",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

            // ===========================
              // BUTTON (OPSIONAL)
              // ===========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainNavigation(),
                        ),
                      );
                    },
                    child: const Text("Lanjutkan"),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
