import 'package:flutter/material.dart';

enum DashboardMenuAction { aplikasi, logout }

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const Color primaryColor = Color(0xFF4C6FFF);

  @override
  Widget build(BuildContext context) {
    final evaluations = [
      const _EvaluationItem(
        title: "Kemudahan Penggunaan",
        description:
            "Antarmuka sederhana dengan navigasi jelas membuat pengguna baru cepat paham.",
        score: "4.5 / 5",
      ),
      const _EvaluationItem(
        title: "Kinerja Aplikasi",
        description:
            "Respons layar cepat dan interaksi terasa mulus bahkan di perangkat low-end.",
        score: "4.2 / 5",
      ),
      const _EvaluationItem(
        title: "Kelengkapan Fitur",
        description:
            "Fitur to-do, filter, FAQ, dan Setting mendukung kebutuhan belajar terpadu.",
        score: "4.0 / 5",
      ),
      const _EvaluationItem(
        title: "Stabilitas Offline",
        description:
            "Ketika koneksi internet bermasalah, data belum tersimpan lokal sehingga tugas bisa hilang.",
        score: "3.2 / 5",
      ),
      const _EvaluationItem(
        title: "Visualisasi Data",
        description:
            "Belum tersedia grafik progreso atau statistik sehingga pengguna sulit membaca tren belajar.",
        score: "3.0 / 5",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DASHBOARD",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<DashboardMenuAction>(
            icon: const Icon(Icons.menu_rounded),
            onSelected: (action) {
              switch (action) {
                case DashboardMenuAction.aplikasi:
                  Navigator.pushNamed(context, '/uts');
                  break;
                case DashboardMenuAction.logout:
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: DashboardMenuAction.aplikasi,
                child: Text("Aplikasi"),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: DashboardMenuAction.logout,
                child: Text("Logout"),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEF2FF),
              Color(0xFFE0ECFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Selamat datang di Dashboard 👋",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Ini adalah halaman utama setelah login. "
                            "Dari sini kamu bisa menuju halaman UTS atau logout.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ringkasan Penilaian Aplikasi",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Berikut umpan balik singkat mengenai kualitas aplikasi UTS ini.",
                            style: TextStyle(color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: evaluations.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = evaluations[index];
                              return _EvaluationCard(item: item);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EvaluationItem {
  const _EvaluationItem({
    required this.title,
    required this.description,
    required this.score,
  });

  final String title;
  final String description;
  final String score;
}

class _EvaluationCard extends StatelessWidget {
  const _EvaluationCard({required this.item});

  final _EvaluationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF4C6FFF).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fact_check_outlined,
              color: Color(0xFF4C6FFF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      item.score,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
