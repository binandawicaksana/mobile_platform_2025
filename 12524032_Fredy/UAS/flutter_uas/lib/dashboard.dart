import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR CUSTOM =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Foto Profil
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(
                "assets/images/foto.jpg", // ganti sesuai file kamu
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Halo!",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  "Fredy",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 48,
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Cari",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= Banner Promo =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xff6A5AE0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Dapatkan diskon hingga\n20% Potongan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Image.asset(
                      "assets/images/foto.jpg", // Ganti sesuai file kamu
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Indicator Carousel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: index == 0 ? 12 : 8,
                  height: index == 0 ? 12 : 8,
                  decoration: BoxDecoration(
                    color: index == 0
                        ? Colors.deepPurple
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= UNGGULAN =================
            _buildSectionTitle("Unggulan"),

            const SizedBox(height: 14),

            _buildServiceGrid(),

            const SizedBox(height: 30),

            // ================= TERLARIS =================
            _buildSectionTitle("Terlaris"),

            const SizedBox(height: 14),

            _buildServiceGrid(),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  // ================================================================
  // COMPONENTS
  // ================================================================

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Lihat semua",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return _buildServiceCard();
      },
    );
  }

  Widget _buildServiceCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEFE6FF),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              "assets/images/foto.jpg", // ganti sesuai file kamu
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Premium Clean",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            "Rp200.000",
            style: TextStyle(color: Colors.blue, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
