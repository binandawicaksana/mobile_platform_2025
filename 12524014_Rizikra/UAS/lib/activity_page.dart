import 'package:flutter/material.dart';
import 'message_page.dart';
import 'account_page.dart';

/// helper format angka ribuan: 1000 -> "1.000"
String formatNumber(String value) {
  if (value.isEmpty) return "";
  value = value.replaceAll(".", "");
  final number = int.tryParse(value);
  if (number == null) return "";
  final s = number.toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
}

class ActivityPage extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const ActivityPage({super.key, required this.activities});

  Color get primaryPurple => const Color(0xFF5B2ECC);

  String _monthLabel(DateTime dt, {bool isCurrentMonth = false}) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    if (isCurrentMonth) return 'Bulan Ini';
    return '${bulan[dt.month]} ${dt.year}';
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${two(dt.day)} ${bulan[dt.month]} ${dt.year} - '
        '${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    // --- Grouping aktivitas per bulan (key: yyyy-MM) ---
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final act in activities) {
      final dateStr = (act['date'] ?? '') as String;
      final dt = DateTime.tryParse(dateStr) ?? now;
      final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add({...act, '_dt': dt});
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // terbaru di atas

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aktivitas',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: activities.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada aktivitas.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: sortedKeys.length,
                itemBuilder: (context, index) {
                  final key = sortedKeys[index];
                  final monthItems = grouped[key]!;
                  final isCurrentMonth = key == currentKey;
                  final dtForLabel = monthItems.first['_dt'] as DateTime;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== HEADER BULAN =====
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          _monthLabel(
                            dtForLabel,
                            isCurrentMonth: isCurrentMonth,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE5E5E5)),

                      // ===== DAFTAR AKTIVITAS UNTUK BULAN INI =====
                      ...List.generate(monthItems.length, (i) {
                        final act = monthItems[i];
                        final dt = act['_dt'] as DateTime;
                        final type = (act['type'] ?? 'kirim') as String;
                        final name = (act['name'] ?? '') as String;
                        final amount = (act['amount'] ?? 0) as int;

                        final _IconStyle iconStyle = _iconByType(
                          type,
                          primaryPurple,
                        );

                        // + / - & warna hijau / merah
                        final bool isPlus = type == 'isi' || type == 'terima';
                        final String amountText =
                            "${isPlus ? '+' : '-'} \$${formatNumber(amount.toString())}";
                        final Color amountColor = isPlus
                            ? Colors.green.shade600
                            : Colors.red.shade600;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: iconStyle.bgColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      iconStyle.icon,
                                      size: 18,
                                      color: iconStyle.iconColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          iconStyle.title,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _formatDate(dt),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        if (name.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Text(
                                    amountText,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: amountColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Color(0xFFE5E5E5)),
                          ],
                        );
                      }),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HOME – selalu balik ke dashboard (route pertama)
                    IconButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(
                        Icons.home_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),

                    // AKTIVITAS (aktif – pill ungu)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: primaryPurple,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.list_alt, size: 20, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Aktivitas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // PESAN – bisa pindah ke MessagePage
                    IconButton(
                      icon: const Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MessagePage(activities: activities),
                          ),
                        );
                      },
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.settings_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AccountPage(activities: activities),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 4,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====== Helper untuk style icon berdasarkan tipe aktivitas ======

class _IconStyle {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;

  _IconStyle({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
  });
}

_IconStyle _iconByType(String type, Color primaryPurple) {
  switch (type) {
    case 'tarik':
      return _IconStyle(
        icon: Icons.attach_money,
        iconColor: const Color(0xFFFFA000),
        bgColor: const Color(0xFFFFF3E0),
        title: 'Tarik Tunai',
      );
    case 'isi':
      return _IconStyle(
        icon: Icons.add,
        iconColor: primaryPurple,
        bgColor: const Color(0xFFEDE7FF),
        title: 'Isi Saldo',
      );
    case 'terima':
      return _IconStyle(
        icon: Icons.person_add_alt_1,
        iconColor: const Color(0xFFFFA000),
        bgColor: const Color(0xFFFFF3E0),
        title: 'Terima Uang',
      );
    case 'kirim':
    default:
      return _IconStyle(
        icon: Icons.person_add_alt_1,
        iconColor: primaryPurple,
        bgColor: const Color(0xFFEDE7FF),
        title: 'Kirim Uang',
      );
  }
}
