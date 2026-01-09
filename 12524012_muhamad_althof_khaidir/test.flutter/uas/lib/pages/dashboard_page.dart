import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // Outer dark frame (mirip mockup border) + overall bg
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Header (background image + match info)
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 20,
                    right: 20,
                    bottom: 12,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg_lalig.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // top icons + title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.person_outline,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfilePage(),
                                ),
                              );
                            },
                          ),

                          const Text(
                            "La liga",
                            style: TextStyle(color: Colors.white),
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // logos + date + score
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/Logo_RM.png",
                            width: 70,
                            height: 70,
                          ),
                          Column(
                            children: const [
                              Text(
                                "Sen 2 nov - 03:00",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "4 - 0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 46,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/Logo_Val.png",
                            width: 70,
                            height: 70,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // club names
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Real Madrid",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Valencia",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "K. Mbappe 18' (pen), 30'",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "J. Bellingham 43'",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "Alvaro Carreras 81'",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text("", style: TextStyle(color: Colors.white70)),
                              Text("", style: TextStyle(color: Colors.white70)),
                              Text("", style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        "Football · First Team\nGame day 11 · Stadion Santiago Bernabeu",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              // Pinned TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  SizedBox(
                    height: 50,
                    child: ColoredBox(
                      color: const Color(
                        0xff003b7a,
                      ), // gunakan biru agar sesuai mockup tab
                      child: const TabBar(
                        indicatorColor: Colors.yellow,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: [
                          Tab(text: "Langsung"),
                          Tab(text: "Ringkasan"),
                          Tab(text: "Statistik"),
                          Tab(text: "Perlengkapan"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },

          // TAB VIEW - keep other tabs intact, Statistik will use improved UI
          body: TabBarView(
            children: [
              _tabListView(),
              _tabListView(),
              _statistikViewFullCard(context),
              _perlengkapanView(),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------
  // Default list used by Langsung / Ringkasan / Perlengkapan
  // --------------------
  Widget _tabListView() {
  return Container(
    // 🟦 FRAME LUAR (ABU GELAP) — MEMANJANG KE BAWAH
    color: const Color.fromARGB(255, 255, 255, 255),

    child: Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520),

        // jarak dari frame abu
        padding: const EdgeInsets.all(12),

        child: Container(
          // ⬜ CONTAINER PUTIH PEMBUNGKUS KONTEN
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff3b3b3b),
            borderRadius: BorderRadius.circular(20),
          ),

          child: ListView.builder(
            // ⛔ penting: biar ListView tidak overflow
            padding: EdgeInsets.zero,
            itemCount: 6,
            itemBuilder: (context, index) {
              return _highlightCard();
            },
          ),
        ),
      ),
    ),
  );
}

  // --------------------
  // STATISTIK VIEW - FULL CARD like design
  // --------------------
  Widget _statistikViewFullCard(BuildContext context) {
    // sample data (kamu sebut tidak ingin mengganti value stat)
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      children: [
        Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 520),

            // 🟦 BACKGROUND LUAR (abu2 gelap)
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xff3b3b3b),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Container(
              // 🟩 INI CONTAINER PUTIH PALING LUAR (yang kamu minta)
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // warna putih
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [
                  // ==========================================================
                  // 🔵 MATCH STAT + MADRID VS — GABUNG JADI SATU
                  // ==========================================================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        // 🔵 HEADER MATCH STAT
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xff55a8ff),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Match Stat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // ⚪ SCORE Madrid vs
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "R. Madrid",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "4 - 0",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Valencia",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "La liga",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // 🔽 STAT BAGIAN BAWAH — TIDAK DIRUBAH
                  // ==========================================================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _statItem("Penguasaan bola", "64,9%", "35,1%", 0.649),
                        const SizedBox(height: 14),
                        _statItem("Duel antar pemain", "96", "94", 0.505),
                        const SizedBox(height: 14),
                        _statItem(
                          "Presentase duel dimenangkan",
                          "42,7%",
                          "53,2%",
                          0.445,
                        ),
                        const SizedBox(height: 14),
                        _statItem("Duel udara", "12", "12", 0.5),
                        const SizedBox(height: 14),
                        _statItem("Duel udara dimenangkan", "50%", "50%", 0.5),
                        const SizedBox(height: 14),
                        _statItem("Dribel berhasil", "8", "8", 0.5),
                        const SizedBox(height: 14),
                        _statItem("Offside", "2", "0", 1.0),
                        const SizedBox(height: 14),
                        _statItem("Tendangan sudut", "7", "1", 0.875),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --------------------
  // Single stat item: label top center, values + bar below
  // --------------------
  Widget _statItem(String title, String left, String right, double leftFactor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // TITLE
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        // NUMBERS + BAR
        Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(
                left,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: leftFactor.clamp(0, 1),
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xff4da3ff), Color(0xff003b7a)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 50,
              child: Text(
                right,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --------------------
  // Highlight card unchanged
  // --------------------
  Widget _highlightCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xff252525),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              "assets/images/k_mbp.png",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Real Madrid 4-0 Valencia HIGHLIGHTS | LaLiga",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white70,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text("888", style: TextStyle(color: Colors.white70)),
                    SizedBox(width: 14),
                    Icon(
                      Icons.mode_comment_outlined,
                      color: Colors.white70,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text("35", style: TextStyle(color: Colors.white70)),
                    SizedBox(width: 14),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white70,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text("40", style: TextStyle(color: Colors.white70)),
                    SizedBox(width: 14),
                    Icon(Icons.visibility, color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text("1.2k", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom nav item
class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomItem(this.icon, this.label, {this.active = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.yellow : Colors.white, size: 26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.yellow : Colors.white,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ==========================
// TAB PERLENGKAPAN (TABLE VERSION)
// ==========================
Widget _perlengkapanView() {
  return ListView(
    
    padding: const EdgeInsets.all(16),
    children: [
      Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff3b3b3b),
            borderRadius: BorderRadius.circular(26),
          ),

          child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(26),
          ),
          
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // ===== HEADER BIRU =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xff4da3ff),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Fixtures - Spanish La Liga",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                // ===== ISI TABLE =====
                _fixtureDateSection("Saturday 1 November 2025", const [
                  ["FT", "Getafe", "2", "v", "1", "Girona"],
                  ["FT", "Villarreal", "2", "v", "1", "R Vallecano"],
                  ["FT", "Getafe", "2", "v", "1", "Girona"],
                ]),

                _fixtureDateSection("Saturday 2 November 2025", const [
                  ["FT", "Getafe", "2", "v", "1", "Girona"],
                  ["FT", "Villarreal", "2", "v", "1", "R Vallecano"],
                  ["FT", "Getafe", "2", "v", "1", "Girona"],
                  ["FT", "Villarreal", "2", "v", "1", "R Vallecano"],
                ]),

                _fixtureDateSection("Saturday 3 November 2025", const [
                  ["FT", "Getafe", "2", "v", "1", "Girona"],
                  ["FT", "Villarreal", "2", "v", "1", "R Vallecano"],
                ]),
              ],
            ),
          ),
        ),
      ),
      ),
    ],
  );
}

// ==========================
// SECTION TANGGAL + TABLE MATCH
// ==========================
Widget _fixtureDateSection(String date, List<List<String>> rows) {
  final matchRowColors = [const Color(0xffFFFFFF), const Color(0xffDDDDDD)];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ===== HEADER TANGGAL (SELALU ABU #BABABA) =====
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        color: const Color(0xffBABABA),
        child: Text(
          date,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 13,
          ),
        ),
      ),

      // ===== TABEL MATCH =====
      Table(
        columnWidths: const {
          0: FixedColumnWidth(40), // FT
          1: FlexColumnWidth(), // match row
        },
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          final bgColor = matchRowColors[index % matchRowColors.length];

          return TableRow(
            decoration: BoxDecoration(color: bgColor),
            children: [
              // ===== FT =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 6,
                ),
                child: Text(
                  row[0],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // ===== MATCH CENTER =====
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(text: row[1]),
                        const TextSpan(text: "  "),
                        const TextSpan(
                          text: "2",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "  v  "),
                        const TextSpan(
                          text: "1",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(text: row[5]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    ],
  );
}

// cell kiri / teks biasa
Widget _cell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
    child: Text(text, style: const TextStyle(fontSize: 13)),
  );
}

// cell tengah (score)
Widget _cellCenter(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

// Section tanggal fixtures
Widget _fixtureSection(String date, List<String> matches) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // label tanggal
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          date,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),

      const SizedBox(height: 6),

      // list match
      ...matches.map(
        (m) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              const SizedBox(
                width: 28,
                child: Text("FT", style: TextStyle(fontSize: 13)),
              ),
              Expanded(child: Text(m, style: const TextStyle(fontSize: 13))),
            ],
          ),
        ),
      ),
    ],
  );
}

// Sliver delegate for pinned TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverAppBarDelegate(this.child);

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
