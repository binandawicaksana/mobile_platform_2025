import 'package:flutter/material.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===========================
      // 🔵 APP BAR
      // ===========================
      appBar: AppBar(
        backgroundColor: const Color(0xff003b7a),
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),

      // ===========================
      // 🧱 BODY
      // ===========================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),

          // ===========================
          // 🔲 CONTAINER LUAR (PELAPIS)
          // ===========================
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF3C3C3C),
              borderRadius: BorderRadius.circular(26),
            ),

            // ===========================
            // ⬜ CONTAINER DALAM
            // ===========================
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),

              child: Column(
                children: [
                  // ===========================
                  // 👤 HEADER PROFIL
                  // ===========================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // FOTO PROFIL
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage("assets/images/k_mbp.png"),
                      ),

                      const SizedBox(width: 12),

                      // NAMA
                      const Text(
                        "Althof Khaidir",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      // ===========================
                      // 👑 LEVEL (CROWN DI LUAR)
                      // ===========================
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // KOTAK LEVEL
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              children: const [
                                Text(
                                  "1",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Level", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),

                          // 👑 CROWN OUTLINE
                          Image.asset(
                            "assets/images/crown.png",
                            width: 26,
                            height: 26,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ===========================
                  // 📊 INFO CARD
                  // ===========================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoBox("Daily Streak", "1"),
                      _infoBox("Total Score", "50"),
                      _infoBox("Penampilan", "2"),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ===========================
                  // 🌈 GABUNG MEMBER (DOUBLE)
                  // ===========================
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8EA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xff4d6cff), Color(0xffb66cff)],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Gabung Member",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================
  // 📦 INFO BOX
  // ===========================
  Widget _infoBox(String title, String value) {
    return Container(
      width: 95,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
