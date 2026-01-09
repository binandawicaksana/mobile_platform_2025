import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C3C3C),

      body: Column(
        children: [
          // ===========================
          // 🔵 HEADER BIRU
          // ===========================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            color: const Color(0xff003b7a),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Berita",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ===========================
          // 📦 CONTAINER PUTIH BESAR
          // ===========================
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),

                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _newsItem(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // 📰 NEWS ITEM (CLICKABLE)
  // =========================
  Widget _newsItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showNewsDetail(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/k_mbp.png",
                width: 120,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // TEKS
            const Expanded(
              child: Text(
                "Real Madrid begin preparations for Liverpool match",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // 🧾 MODAL DETAIL BERITA
  // =========================
  void _showNewsDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),

          child: Column(
            children: [
              // =========================
              // HEADER + CLOSE
              // =========================
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Xabi Alonso: "The players gave everything they had"',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // =========================
              // CONTENT
              // =========================
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/k_mbp.png",
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 16),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "The players gave everything they had and showed great attitude despite all the difficulties faced by the team. The coach praised their mentality and fighting spirit until the final whistle.\n\nThe team continues to work hard and remains confident in achieving positive results in upcoming matches.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
