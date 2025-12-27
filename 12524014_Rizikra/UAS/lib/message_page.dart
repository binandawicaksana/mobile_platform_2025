import 'package:flutter/material.dart';
import 'activity_page.dart';
import 'message_detail_page.dart';
import 'account_page.dart';

class MessagePage extends StatelessWidget {
  /// daftar aktivitas, dipakai kalau dari Pesan ingin pindah ke halaman Aktivitas
  final List<Map<String, dynamic>> activities;

  const MessagePage({super.key, required this.activities});

  Color get primaryPurple => const Color(0xFF5B2ECC);

  @override
  Widget build(BuildContext context) {
    // dummy data pesan
    final messages = <_Message>[
      _Message(
        title: 'Akun',
        preview:
            'Akun kamu terbatas. Tolong melakukan verifikasi secepatnya...',
        date: '12/10',
        type: _MessageType.account,
      ),
      _Message(
        title: 'Peringatan',
        preview:
            'Saldo mu telah dalam peninjauan, tolong cek kembali transaksi terakhir...',
        date: '11/10',
        type: _MessageType.warning,
      ),
      _Message(
        title: 'Paypal',
        preview:
            'Akun mu terkunci, tolong lakukan perubahan password secepatnya...',
        date: '10/11',
        type: _MessageType.paypal,
      ),
      _Message(
        title: 'Tarik Tunai',
        preview:
            'Teruntuk Customer, dengan no 1267 transaksi tarik tunai berhasil diproses...',
        date: '10/12',
        type: _MessageType.cash,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
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
          'Pesan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final style = _iconStyle(msg.type);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MessageDetailPage(
                        title: msg.title,
                        date: msg.date,
                        content: msg.preview, // bisa diganti teks panjang
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: style.bgColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          style.icon,
                          color: style.iconColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              msg.preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        msg.date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
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
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // =================== BOTTOM NAV ===================

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F7FB),
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
                    // HOME – selalu ke Dashboard (route pertama)
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

                    // AKTIVITAS – bisa pindah ke ActivityPage
                    IconButton(
                      icon: const Icon(
                        Icons.list_alt,
                        size: 20,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ActivityPage(activities: activities),
                          ),
                        );
                      },
                    ),

                    // PESAN (aktif – pill ungu)
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
                          Icon(
                            Icons.email_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Pesan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

// ===================== MODEL & STYLE ICON =====================

class _Message {
  final String title;
  final String preview;
  final String date;
  final _MessageType type;

  _Message({
    required this.title,
    required this.preview,
    required this.date,
    required this.type,
  });
}

enum _MessageType { account, warning, paypal, cash }

class _MessageIconStyle {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  _MessageIconStyle({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

_MessageIconStyle _iconStyle(_MessageType type) {
  switch (type) {
    case _MessageType.account:
      return _MessageIconStyle(
        icon: Icons.person,
        iconColor: Colors.white,
        bgColor: const Color(0xFFFF5C7A),
      );
    case _MessageType.warning:
      return _MessageIconStyle(
        icon: Icons.credit_card,
        iconColor: Colors.white,
        bgColor: const Color(0xFF2289FF),
      );
    case _MessageType.paypal:
      return _MessageIconStyle(
        icon: Icons.payment,
        iconColor: Colors.white,
        bgColor: const Color(0xFFFFB74D),
      );
    case _MessageType.cash:
    default:
      return _MessageIconStyle(
        icon: Icons.receipt_long,
        iconColor: Colors.white,
        bgColor: const Color(0xFF24C9A8),
      );
  }
}
