import 'package:flutter/material.dart';

import 'widgets/app_drawer.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_FaqItem> _items = [
    _FaqItem(
      question: "Bagaimana cara menambahkan tugas baru?",
      answer:
          "Ketik tugas Anda di kolom input dan klik tombol \"Tambahkan Tugas\" "
          "atau tekan Enter.",
      isExpanded: true,
    ),
    _FaqItem(
      question: "Bagaimana cara menandai sebagai selesai?",
      answer:
          "Cukup centang tugas yang sudah selesai, tugas akan otomatis "
          "berpindah ke kategori selesai.",
    ),
    _FaqItem(
      question: "Bagaimana cara menghapus tugas?",
      answer: "Untuk saat ini tugas hanya dapat disembunyikan dengan menandai "
          "sebagai selesai.",
    ),
    _FaqItem(
      question: "Apa fungsi filter?",
      answer:
          "Filter membantu Anda melihat semua tugas, hanya tugas aktif, atau "
          "tugas yang sudah selesai.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE9F2FF),
      drawer: AppDrawer(
        activeDestination: DrawerDestination.faq,
        onGoToDashboard: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "FREQUENTLY ASKED QUESTIONS",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "FAQ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Kumpulan pertanyaan dan jawaban yang sering muncul saat "
                "menggunakan aplikasi ini.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return _buildFaqCard(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(int index) {
    final item = _items[index];
    return GestureDetector(
      onTap: () {
        setState(() => _items[index] =
            item.copyWith(isExpanded: !item.isExpanded));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  item.isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black87,
                ),
              ],
            ),
            if (item.isExpanded) ...[
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 10),
              Text(
                item.answer,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  final String question;
  final String answer;
  final bool isExpanded;

  _FaqItem copyWith({bool? isExpanded}) {
    return _FaqItem(
      question: question,
      answer: answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
