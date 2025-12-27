import 'package:flutter/material.dart';
import 'transfer_page.dart';
import 'activity_page.dart';
import 'message_page.dart';
import 'account_page.dart';
import 'tarik_tunai_page.dart';
import 'bill_payment_page.dart';

/// helper format angka ribuan
String formatNumber(String value) {
  if (value.isEmpty) return "";
  value = value.replaceAll(".", "");
  final number = int.tryParse(value);
  if (number == null) return "";
  final s = number.toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
}

class DashboardPage extends StatefulWidget {
  final int initialBalance;

  const DashboardPage({super.key, required this.initialBalance});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Color get primaryPurple => const Color(0xFF5B2ECC);
  Color get lightBackground => const Color(0xFFF6F7FB);

  late int _balance;

  /// list aktivitas (dummy + hasil transfer/tarik)
  /// setiap elemen:
  /// {
  ///   'type': 'kirim'|'terima'|'isi'|'tarik',
  ///   'name': 'Sari',
  ///   'amount': 1000,
  ///   'date': isoString
  /// }
  late List<Map<String, dynamic>> _activities;

  @override
  void initState() {
    super.initState();
    _balance = widget.initialBalance;

    // ====== DATA AWAL AKTIVITAS (mirip contoh gambar) ======
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    final prevMonth = DateTime(now.year, now.month - 1, 1);

    String iso(DateTime dt) => dt.toIso8601String();

    _activities = [
      // Bulan ini
      {
        'type': 'tarik',
        'name': 'Tarik Tunai ATM',
        'amount': 150,
        'date': iso(
          thisMonth.add(const Duration(days: 14, hours: 15, minutes: 15)),
        ),
      },
      {
        'type': 'isi',
        'name': 'Isi saldo rekening',
        'amount': 500,
        'date': iso(
          thisMonth.add(const Duration(days: 1, hours: 19, minutes: 52)),
        ),
      },
      {
        'type': 'kirim',
        'name': 'Kirim ke Sari',
        'amount': 200,
        'date': iso(
          thisMonth.add(const Duration(days: 0, hours: 17, minutes: 55)),
        ),
      },

      // Bulan lalu
      {
        'type': 'terima',
        'name': 'Terima dari Andi',
        'amount': 300,
        'date': iso(
          prevMonth.add(const Duration(days: 28, hours: 10, minutes: 17)),
        ),
      },
      {
        'type': 'isi',
        'name': 'Top up gaji',
        'amount': 800,
        'date': iso(
          prevMonth.add(const Duration(days: 19, hours: 13, minutes: 10)),
        ),
      },
      {
        'type': 'isi',
        'name': 'Isi saldo manual',
        'amount': 250,
        'date': iso(
          prevMonth.add(const Duration(days: 9, hours: 17, minutes: 32)),
        ),
      },
      {
        'type': 'kirim',
        'name': 'Kirim ke Budiono',
        'amount': 100,
        'date': iso(
          prevMonth.add(const Duration(days: 0, hours: 17, minutes: 55)),
        ),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildTopSection(),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildActionRow(context),
                      ),
                      const SizedBox(height: 16),

                      // biar tidak memaksa tinggi fixed (ini sering bikin overflow)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          'assets/images/dasbor.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // isi ruang sisa kalau ada (biar bottom nav ga ketiban)
                      const Spacer(),
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

  // ==================== BAGIAN ATAS UNGU + KARTU ====================

  Widget _buildTopSection() {
    return Container(
      decoration: BoxDecoration(
        color: primaryPurple,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/PP.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hi, Zikkk',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Selamat datang kembali',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                const _NotificationIcon(),
              ],
            ),
          ),

          // ruang lebih besar agar kartu saldo terlihat "besar"
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: _buildCardStack(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    final w = MediaQuery.of(context).size.width;

    // tinggi stack mengikuti layar (biar besar di mobile)
    final double stackH = w * 0.58; // bisa 0.56 - 0.62 sesuai selera

    return SizedBox(
      height: stackH,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // layer merah bawah (lebih panjang)
          Positioned(
            bottom: 2,
            left: 18,
            right: 18,
            child: Container(
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4F6D),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          // layer ungu tengah (lebih besar)
          Positioned(
            bottom: 14,
            left: 10,
            right: 10,
            child: Container(
              height: 125,
              decoration: BoxDecoration(
                color: const Color(0xFF4C2FD1),
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),

          // kartu utama (besar)
          Container(
            height: 165, // bikin kotak saldo besar
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                colors: [Color(0xFF151C62), Color(0xFF2936D2)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // lingkaran biru kanan (lebih besar)
                const Positioned(
                  right: -25,
                  top: -40,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF45C0FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                // bentuk gelap kiri (lebih besar)
                Positioned(
                  left: -55,
                  top: -30,
                  bottom: -30,
                  child: Container(
                    width: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFF15226E),
                      borderRadius: BorderRadius.circular(220),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rizikra',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            '4756   2191   7219   1682',
                            style: TextStyle(
                              color: Colors.white70,
                              letterSpacing: 1.4,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${formatNumber(_balance.toString())}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28, // saldo lebih besar
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // baris kosong biar layout stabil (karena teks "Balance/VISA" kamu hapus)
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================= ROW 3 MENU (Transfer, Tarik Tunai, Bayar Tagihan) ==================

  Widget _buildActionRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TRANSFER
        Expanded(
          child: _ActionItem(
            label: 'Transfer',
            iconColor: const Color(0xFFFF4D73),
            iconData: Icons.flip_to_front,
            onTap: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => TransferPage(currentBalance: _balance),
                ),
              );

              if (result != null) {
                final int remaining =
                    result['remainingBalance'] as int? ?? _balance;
                final Map<String, dynamic>? activity =
                    result['activity'] as Map<String, dynamic>?;

                setState(() {
                  _balance = remaining;
                  if (activity != null) {
                    _activities.insert(0, activity);
                  }
                });
              }
            },
          ),
        ),
        const SizedBox(width: 10),

        // TARIK TUNAI
        Expanded(
          child: _ActionItem(
            label: 'Tarik Tunai',
            iconColor: const Color(0xFF2289FF),
            iconData: Icons.atm,
            onTap: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => TarikTunaiPage(currentBalance: _balance),
                ),
              );

              if (result != null) {
                final int remaining =
                    result['remainingBalance'] as int? ?? _balance;
                final Map<String, dynamic>? activity =
                    result['activity'] as Map<String, dynamic>?;

                setState(() {
                  _balance = remaining;
                  if (activity != null) {
                    _activities.insert(0, activity);
                  }
                });
              }
            },
          ),
        ),
        const SizedBox(width: 10),

        // BAYAR TAGIHAN (pakai alur baru, terima result dari BillPaymentPage)
        Expanded(
          child: _ActionItem(
            label: 'Bayar Tagihan',
            iconColor: const Color(0xFF24C9A8),
            iconData: Icons.receipt_long,
            onTap: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => BillPaymentPage(currentBalance: _balance),
                ),
              );

              if (result != null) {
                final int remaining =
                    result['remainingBalance'] as int? ?? _balance;
                final Map<String, dynamic>? activity =
                    result['activity'] as Map<String, dynamic>?;

                setState(() {
                  _balance = remaining;
                  if (activity != null) {
                    // tampil paling atas di Aktivitas
                    _activities.insert(0, activity);
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  // ======================= BOTTOM NAV ==================

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      color: lightBackground,
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
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HOME
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
                            Icons.home_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // AKTIVITAS
                    IconButton(
                      icon: Icon(
                        Icons.list_alt,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ActivityPage(activities: _activities),
                          ),
                        );
                      },
                    ),

                    // PESAN
                    IconButton(
                      icon: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MessagePage(activities: _activities),
                          ),
                        );
                      },
                    ),

                    // AKUN
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
                            builder: (_) =>
                                AccountPage(activities: _activities),
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

// =====================================================================
// WIDGET KECIL
// =====================================================================

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFFF4E67),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Color(0xFF5B2ECC), width: 1),
            ),
            alignment: Alignment.center,
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String label;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.iconData,
    required this.iconColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 24, color: iconColor),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF707070),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
