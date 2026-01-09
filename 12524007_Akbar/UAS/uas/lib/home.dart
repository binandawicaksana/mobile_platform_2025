import 'dart:math' as math;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uas/widgets/electronic_money_logo_painter.dart';
import 'package:uas/widgets/money_logo_painter.dart';

String _formatRupiah(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }
  return "Rp ${buffer.toString()}";
}

int _parseAmount(String text) {
  final digits = text.replaceAll(RegExp(r"[^0-9]"), "");
  if (digits.isEmpty) {
    return 0;
  }
  return int.tryParse(digits) ?? 0;
}

String _maskPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r"[^0-9]"), "");
  if (digits.length <= 6) {
    return phone;
  }
  final start = digits.substring(0, 4);
  final end = digits.substring(digits.length - 4);
  return "$start **** $end";
}

class HomePage extends StatefulWidget {
  final String contact;

  const HomePage({super.key, required this.contact});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isScanning = true;
  bool _isBalanceHidden = false;
  String? _lastScan;
  String _profileName = "Pengguna";
  int _balanceAmount = 2500000;
  bool _hasActivityNotification = false;
  final List<_ActivityItem> _activityItems = [];
  final String _incomingAmount = "Rp 12.500";
  int _outgoingAmount = 7800;
  Uint8List? _profileImage;
  final ScrollController _homeScrollController = ScrollController();
  final ScrollController _profileScrollController = ScrollController();
  bool _showHomeScrollToTop = false;
  bool _showProfileScrollToTop = false;
  static Widget _phoneRpIcon(Color color) {
    return SizedBox(
      width: 5,
      height: 10,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Positioned(
            top: 1,
            child: Container(
              width: 4,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            top: 3.5,
            left: 1,
            right: 1,
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            child: Container(
              width: 2.5,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Positioned(
            bottom: 3.5,
            left: 1,
            right: 1,
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            "Rp",
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityNavIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.receipt_long_outlined),
        if (_hasActivityNotification)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D4F),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }

  Widget _activityMoneyLogo() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF0D8BFF), width: 1),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF0D8BFF),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  String _formatActivityDate(DateTime dateTime) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    final day = dateTime.day.toString().padLeft(2, "0");
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, "0");
    final minute = dateTime.minute.toString().padLeft(2, "0");
    return "$day $month $year . $hour.$minute";
  }

  Widget _buildActivityPage(Color primaryBlue) {
    final showActivity = _activityItems.isNotEmpty;
    if (!showActivity) {
      return _placeholderPage(
        icon: Icons.receipt_long_outlined,
        title: "Aktivitas",
        subtitle: "Transaksi terbaru akan tampil di sini.",
      );
    }

    final now = DateTime.now();
    final monthTotal = _activityItems
        .where((item) => item.timestamp.month == now.month && item.timestamp.year == now.year)
        .fold<int>(0, (sum, item) => sum + item.amount);
    final monthTotalLabel = "-${_formatRupiah(monthTotal)}";

    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          Container(
            color: primaryBlue,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                        onPressed: () {
                          setState(() => _currentIndex = 0);
                        },
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Aktivitas",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5F2FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: primaryBlue, width: 1),
                          ),
                          child: Icon(Icons.search, color: primaryBlue, size: 16),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Cari aktivitas",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bulan ini",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(
                        monthTotalLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _activityItems.length,
                      separatorBuilder: (_, __) => Divider(color: Colors.grey[200], height: 24),
                      itemBuilder: (context, index) {
                        final item = _activityItems[index];
                        final amountLabel = "-${_formatRupiah(item.amount)}";
                        final dateLabel = _formatActivityDate(item.timestamp);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Color(0xFFE5F2FF),
                                    child: Icon(Icons.person, color: Color(0xFF0D8BFF)),
                                  ),
                                  Positioned(
                                    right: -2,
                                    bottom: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0D8BFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.arrow_forward, size: 10, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Kirim uang",
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dateLabel,
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    amountLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  _activityMoneyLogo(),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _electronicMoneyIcon() {
    return SizedBox(
      width: 32,
      height: 22,
      child: CustomPaint(
        painter: const ElectronicMoneyLogoPainter(),
      ),
    );
  }

  static Widget _seeAllDotsIcon() {
    const dotColor = Color(0xFF9CA3AF);
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned(
            top: 10,
            left: 10,
            child: _Dot(dotColor),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _Dot(dotColor),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: _Dot(dotColor),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: _Dot(dotColor),
          ),
        ],
      ),
    );
  }

  static Widget _danaDealsTicketIcon() {
    return SizedBox(
      width: 36,
      height: 26,
      child: CustomPaint(
        painter: _DanaDealsTicketPainter(),
      ),
    );
  }
  final List<_QuickAction> _quickActions = [
    _QuickAction(
      "Pulsa & Data",
      Icons.signal_cellular_alt,
      const Color(0xFFEAF4FF),
      iconWidget: _phoneRpIcon(const Color(0xFFE53935)),
    ),
    const _QuickAction(
      "Listrik",
      Icons.lightbulb_outline,
      Colors.transparent,
      iconColor: Color(0xFFFF8A00),
    ),
    _QuickAction(
      "Uang\nElektronik",
      Icons.account_balance_wallet_outlined,
      const Color(0xFFEFF5E8),
      iconWidget: _electronicMoneyIcon(),
    ),
    const _QuickAction("Travel", Icons.flight_takeoff_outlined, Colors.transparent),
    const _QuickAction("Hadiah Harian", Icons.card_giftcard_outlined, Colors.transparent),
    const _QuickAction(
      "Cicilan",
      Icons.calendar_month_outlined,
      Colors.transparent,
      iconColor: Color(0xFFE53935),
    ),
    _QuickAction(
      "Dana Deals",
      Icons.local_offer_outlined,
      const Color(0xFFE9F7F2),
      iconWidget: _danaDealsTicketIcon(),
    ),
    _QuickAction(
      "Lihat semua",
      Icons.more_horiz,
      Colors.transparent,
      iconWidget: _seeAllDotsIcon(),
    ),
  ];

  final List<_Promo> _promos = const [
    _Promo("Cashback 30% di merchant pilihan", "Cek detail promo dan klaim voucher sekarang."),
    _Promo("Gratis transfer bank 10x/bulan", "Aktifkan premium untuk nikmati bebas admin."),
    _Promo("Bayar tagihan jadi lebih mudah", "Simpan favorit dan bayar lebih cepat setiap bulan."),
  ];

  @override
  void initState() {
    super.initState();
    _homeScrollController.addListener(() {
      final shouldShow = _homeScrollController.offset > 120;
      if (_showHomeScrollToTop != shouldShow) {
        setState(() => _showHomeScrollToTop = shouldShow);
      }
    });
    _profileScrollController.addListener(() {
      final shouldShow = _profileScrollController.offset > 120;
      if (_showProfileScrollToTop != shouldShow) {
        setState(() => _showProfileScrollToTop = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    _profileScrollController.dispose();
    super.dispose();
  }

  void _scrollToTop(ScrollController controller) {
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  final List<_Bank> _banks = const [
    _Bank("Bank BRI", "Kode bank 002"),
    _Bank("Bank BCA", "Kode bank 014"),
    _Bank("CIMB Niaga", "Kode bank 022"),
    _Bank("PaninBank", "Kode bank 019"),
    _Bank("Permata Bank", "Kode bank 013"),
    _Bank("Maybank", "Kode bank 016"),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0D8BFF);
    const secondaryBlue = Color(0xFF4EC8FF);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      body: _buildBody(primaryBlue, secondaryBlue),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _openPayScanner();
            setState(() => _currentIndex = index);
            return;
          }
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              _hasActivityNotification = false;
            }
          });
        },
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
          BottomNavigationBarItem(icon: _activityNavIcon(), label: "Aktivitas"),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [primaryBlue, secondaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),
            label: "Pay",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: "Dompet"),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Saya"),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(Color primaryBlue, Color secondaryBlue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 18),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomPaint(
                    painter: MoneyLogoPainter(primaryBlue, waveHeightFactor: 0.13),
                    size: const Size(24, 20),
                  ),
                ),
              ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _isBalanceHidden ? "Rp ••••••" : _formatRupiah(_balanceAmount),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _isBalanceHidden = !_isBalanceHidden),
                        child: Icon(
                          _isBalanceHidden ? Icons.visibility : Icons.visibility_off_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: _balanceShortcutButton(
                    label: "Isi Saldo",
                    icon: _arrowOverlayIcon(
                      base: _topUpSquareIcon(
                        borderColor: Colors.white.withOpacity(0.85),
                        plusColor: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                    onTap: _showTopUpBanks,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _balanceShortcutButton(
                    label: "Minta",
                    icon: _curvedDownOverlayIcon(
                      base: _rpSquareIcon(
                        borderColor: Colors.white.withOpacity(0.85),
                        textColor: Colors.white,
                      ),
                      iconColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _balanceShortcutButton(
                    label: "Kirim",
                    icon: _planeOverlayIcon(
                      base: _rpSquareIcon(
                        borderColor: Colors.white.withOpacity(0.85),
                        textColor: Colors.white,
                      ),
                      badgeIconColor: Colors.white,
                    ),
                    onTap: _showQuickSend,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _balanceShortcutButton(
                    label: "Pesan",
                    icon: const Icon(Icons.mail_outline, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesRow(Color primaryBlue) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: _serviceButton(
                      color: primaryBlue,
                      icon: _arrowOverlayIcon(
                        base: _topUpSquareIcon(
                          borderColor: const Color(0xFF0D8BFF),
                          plusColor: const Color(0xFF0D8BFF),
                        ),
                        color: primaryBlue,
                      ),
                      label: "Isi Saldo",
                      onTap: _showTopUpBanks,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: _serviceButton(
                      color: primaryBlue,
                      icon: _curvedDownOverlayIcon(
                        base: _rpSquareIcon(
                          borderColor: primaryBlue,
                          textColor: primaryBlue,
                        ),
                        iconColor: primaryBlue,
                      ),
                      label: "Minta",
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                  child: _serviceButton(
                    color: primaryBlue,
                    icon: _planeOverlayIcon(
                      base: _rpSquareIcon(
                        borderColor: primaryBlue,
                        textColor: primaryBlue,
                      ),
                      badgeIconColor: Colors.white,
                    ),
                    label: "Kirim",
                    onTap: _showQuickSend,
                  ),
                ),
                ),
                Expanded(
                  child: Center(
                    child: _serviceButton(
                      color: primaryBlue,
                      icon: const Icon(Icons.mail_outline, color: Color(0xFF0D8BFF), size: 26),
                      label: "Pesan",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Promo untukmu",
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        ..._promos.map(
          (promo) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_offer_outlined, color: Color(0xFF0D8BFF)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        promo.description,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(Color primaryBlue) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final int columns = maxWidth >= 760
              ? 6
              : maxWidth >= 520
                  ? 5
                  : 4;
          const spacing = 12.0;
          final itemWidth = (maxWidth - (spacing * (columns - 1))) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fitur",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: spacing,
                runSpacing: 14,
                children: _quickActions
                    .map((action) => _quickActionTile(action, primaryBlue, itemWidth))
                    .toList(growable: false),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _quickActionTile(_QuickAction action, Color primaryBlue, double width) {
    final normalizedLabel = action.label.replaceAll("\n", " ");
    final bool isPulsaData = normalizedLabel == "Pulsa & Data";
    final bool isElectronicMoney = normalizedLabel == "Uang Elektronik";
    final bool isDanaDeals = normalizedLabel == "Dana Deals";
    final bool isCicilan = normalizedLabel == "Cicilan";
    const double iconBoxSize = 46;
    final double iconWidth = isPulsaData
        ? 28
        : isElectronicMoney
            ? 36
            : isDanaDeals
                ? 36
                : 46;
    final double iconHeight = isPulsaData
        ? 46
        : isElectronicMoney
            ? 25
            : isDanaDeals
                ? 24
                : 46;
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${action.label} dipilih."),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: iconBoxSize,
              height: iconBoxSize,
              child: Center(
                child: Container(
                  width: iconWidth,
                  height: iconHeight,
                  decoration: BoxDecoration(
                    color: action.backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: action.iconWidget ??
                      Icon(
                        action.icon,
                        color: action.iconColor ?? primaryBlue,
                        size: isCicilan ? 30 : 24,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
                fontSize: 11.5,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayPage(Color primaryBlue, Color secondaryBlue) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, secondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Scan kode QR",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Aktifkan kamera dan arahkan ke QR untuk membayar.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.qr_code_scanner, color: Colors.white, size: 64),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        backgroundColor: Colors.white.withOpacity(0.15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _openPayScanner,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text("Buka kamera"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_lastScan != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Terakhir dipindai",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  _lastScan ?? "",
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _iconText(Color color, IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _serviceButton({
    required Color color,
    required Widget icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topUpSquareIcon({
    required Color borderColor,
    required Color plusColor,
  }) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          Icons.add,
          size: 18,
          color: plusColor,
        ),
      ),
    );
  }

  Widget _rpSquareIcon({
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "Rp",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _planeOverlayIcon({
    required Widget base,
    required Color badgeIconColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        base,
        Positioned(
          top: -10,
          right: -8,
          child: Transform.rotate(
            angle: -0.25,
            child: Icon(
              Icons.send_rounded,
              size: 16,
              color: badgeIconColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _arrowOverlayIcon({
    required Widget base,
    required Color color,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        base,
        Positioned(
          top: -11,
          right: -9,
          child: SizedBox(
            width: 20,
            height: 20,
            child: ClipRect(
              child: Transform.translate(
                offset: const Offset(1.2, -0.6),
                child: Stack(
                  children: [
                    Icon(
                      Icons.north_rounded,
                      size: 20,
                      color: color.withOpacity(0.45),
                    ),
                    Icon(
                      Icons.north_rounded,
                      size: 20,
                      color: color,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _curvedDownOverlayIcon({
    required Widget base,
    required Color iconColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        base,
        Positioned(
          top: -10,
          right: -9,
          child: Transform.rotate(
            angle: 1.6,
            child: Stack(
              children: [
                Icon(
                  Icons.redo_rounded,
                  size: 20,
                  color: iconColor.withOpacity(0.45),
                ),
                Icon(
                  Icons.redo_rounded,
                  size: 20,
                  color: iconColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _balanceShortcutButton({
    required Widget icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickSend() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _QuickSendPage(
          onPaid: (amount) {
            if (amount <= 0) {
              return;
            }
            setState(() {
              _balanceAmount = math.max(0, _balanceAmount - amount);
              _outgoingAmount += amount;
              _hasActivityNotification = true;
              _activityItems.insert(0, _ActivityItem(amount: amount, timestamp: DateTime.now()));
            });
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _voucherPromoIcon() {
    const waveColor = Color(0xFFFF8A00);
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(
        painter: _WavyCirclePainter(waveColor),
        child: const Center(
          child: Text(
            "%",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  void _showTopUpBanks() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520, maxHeight: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Isi saldo via transfer bank",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Pilih bank tujuan untuk melihat instruksi transfer.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _banks.length,
                      itemBuilder: (context, index) {
                        final bank = _banks[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                          leading: CircleAvatar(
                            backgroundColor: Colors.lightBlue[50],
                            child: const Icon(Icons.account_balance, color: Color(0xFF0D8BFF)),
                          ),
                          title: Text(bank.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(bank.code),
                          trailing: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Instruksi transfer ke ${bank.name} ditampilkan."),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text("Pilih"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Promo {
  final String title;
  final String description;
  const _Promo(this.title, this.description);
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _QuickSendPage extends StatelessWidget {
  final ValueChanged<int> onPaid;

  const _QuickSendPage({required this.onPaid});

  static const List<_QuickSendContact> _contacts = [
    _QuickSendContact(name: "Jule", phone: "0812 3456 7890"),
    _QuickSendContact(name: "Ayah Jule", phone: "0813 1111 2222"),
    _QuickSendContact(name: "Ibu Jule", phone: "0813 3333 4444"),
    _QuickSendContact(name: "Kakak Jule", phone: "0812 5555 6666"),
    _QuickSendContact(name: "Adik Jule", phone: "0812 7777 8888"),
    _QuickSendContact(name: "Pacar 1 Jule", phone: "0813 9999 0001"),
    _QuickSendContact(name: "Pacar 2 Jule", phone: "0813 0000 1112"),
    _QuickSendContact(name: "Pacar 3 Jule", phone: "0812 1212 1313"),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0D8BFF);
    const secondaryBlue = Color(0xFF4EC8FF);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topHeight = constraints.maxHeight * 0.3;
          const double overlap = 48;
          const EdgeInsets sidePadding = EdgeInsets.fromLTRB(20, 0, 20, 0);
          final contactCard = Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kirim cepat",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: _contacts
                      .map(
                        (contact) => _QuickSendChip(
                          label: contact.name,
                          icon: Icons.person_outline,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => _QuickSendContactPage(
                                  contact: contact,
                                  onPaid: onPaid,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );

          return Container(
            color: primaryBlue,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: topHeight,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Text(
                                    "Kirim uang",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 72, 20, 110),
                        color: Colors.white,
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: topHeight - overlap,
                  left: sidePadding.left,
                  right: sidePadding.right,
                  child: contactCard,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickSendContactPage extends StatefulWidget {
  final _QuickSendContact contact;
  final ValueChanged<int> onPaid;

  const _QuickSendContactPage({required this.contact, required this.onPaid});

  @override
  State<_QuickSendContactPage> createState() => _QuickSendContactPageState();
}

class _QuickSendContactPageState extends State<_QuickSendContactPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) {
      return "U";
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : "U";
    if (parts.length == 1) {
      return first.toUpperCase();
    }
    final last = parts.last.isNotEmpty ? parts.last[0] : "";
    return (first + last).toUpperCase();
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0D8BFF)),
      ),
    );
  }

  Widget _buildContinueButton(Color primaryBlue) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: primaryBlue,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: primaryBlue.withOpacity(0.35)),
          ),
        ),
        onPressed: () {
          final amountText = _amountController.text.trim();
          final amount = _parseAmount(amountText);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _QuickSendPayPage(
                contact: widget.contact,
                amount: amount,
                onPaid: widget.onPaid,
              ),
            ),
          );
        },
        child: const Text(
          "Lanjut",
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0D8BFF);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final topHeight = constraints.maxHeight * 0.28;
          const double overlap = 28;
          const EdgeInsets sidePadding = EdgeInsets.fromLTRB(20, 0, 20, 0);
          final contactCard = Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFE5F2FF),
                  child: Text(
                    _initials(widget.contact.name),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D8BFF),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contact.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.contact.phone,
                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          return Container(
            color: primaryBlue,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: topHeight,
                      width: double.infinity,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Text(
                                "Kirim ke teman",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 72, 20, 24),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jumlah kirim saldo",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: _amountController,
                              decoration: _fieldDecoration("0").copyWith(prefixText: "Rp "),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Catatan",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              maxLines: 3,
                              controller: _noteController,
                              decoration: _fieldDecoration("Tulis catatan untuk penerima"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: topHeight - overlap,
                  left: sidePadding.left,
                  right: sidePadding.right,
                  child: contactCard,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: _buildContinueButton(primaryBlue),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickSendPayPage extends StatelessWidget {
  final _QuickSendContact contact;
  final int amount;
  final ValueChanged<int> onPaid;

  const _QuickSendPayPage({
    required this.contact,
    required this.amount,
    required this.onPaid,
  });

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) {
      return "U";
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : "U";
    if (parts.length == 1) {
      return first.toUpperCase();
    }
    final last = parts.last.isNotEmpty ? parts.last[0] : "";
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0D8BFF);
    final amountLabel = _formatRupiah(amount);

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              color: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    "Pay",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: primaryBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Informasi pembayaran",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: const Color(0xFFE5F2FF),
                          child: Text(
                            _initials(contact.name),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D8BFF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Kirim uang",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    contact.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    contact.phone,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total harga",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                amountLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                onPaid(amount);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => _QuickSendSuccessPage(
                                      contact: contact,
                                      amount: amount,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "BAYAR",
                                    style: TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    amountLabel,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickSendSuccessPage extends StatelessWidget {
  final _QuickSendContact contact;
  final int amount;

  const _QuickSendSuccessPage({required this.contact, required this.amount});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0D8BFF);
    final amountLabel = _formatRupiah(amount);
    final maskedPhone = _maskPhone(contact.phone);

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              color: Colors.white,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D8BFF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomPaint(
                          painter: MoneyLogoPainter(Colors.white, waveHeightFactor: 0.13),
                          size: const Size(18, 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Pay",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: primaryBlue,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Pembayaran Sukses",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD54F),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD54F),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFB7791F), width: 2.5),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Color(0xFFB7791F),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Kirim Uang Ke",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${contact.name} • $maskedPhone",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          amountLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 18),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text(
                            "Bagikan",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    color: Colors.white,
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Kamu bisa cek di Riwayat Transaksi",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: primaryBlue,
                                    side: const BorderSide(color: Color(0xFF0D8BFF)),
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                  },
                                  child: const Text(
                                    "Tutup",
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                  },
                                  child: const Text(
                                    "Cek Detail",
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickSendChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _QuickSendChip({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 93,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(icon, size: 26, color: Colors.grey[700]),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickSendContact {
  final String name;
  final String phone;

  const _QuickSendContact({required this.name, required this.phone});
}

class _ActivityItem {
  final int amount;
  final DateTime timestamp;

  const _ActivityItem({required this.amount, required this.timestamp});
}

class _Bank {
  final String name;
  final String code;

  const _Bank(this.name, this.code);
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color? iconColor;
  final Widget? iconWidget;

  const _QuickAction(
    this.label,
    this.icon,
    this.backgroundColor, {
    this.iconColor,
    this.iconWidget,
  });
}

extension on _HomePageState {
  Widget _buildBody(Color primaryBlue, Color secondaryBlue) {
    switch (_currentIndex) {
      case 0:
        final topInset = MediaQuery.of(context).padding.top;
        final headerHeight = topInset + (MediaQuery.of(context).size.width > 600 ? 260 : 230);
        return Container(
          color: Colors.grey[50],
          child: Stack(
            children: [
              CustomScrollView(
                controller: _homeScrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: headerHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryBlue,
                                primaryBlue.withOpacity(0.92),
                                primaryBlue,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: _buildBalanceCard(primaryBlue, secondaryBlue),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: -160,
                          child: _wrapMobile(
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: _buildQuickActions(primaryBlue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 200)),
                  SliverToBoxAdapter(
                    child: _wrapMobile(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildPromoList(),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: _scrollToTopButton(
                  visible: _showHomeScrollToTop,
                  onTap: () => _scrollToTop(_homeScrollController),
                ),
              ),
            ],
          ),
        );
      case 1:
        return _buildActivityPage(primaryBlue);
      case 2:
        return _wrapMobile(
          _buildPayPage(primaryBlue, secondaryBlue),
        );
      case 3:
        return _wrapMobile(
          _placeholderPage(
            icon: Icons.account_balance_wallet_outlined,
            title: "Dompet & Kartu",
            subtitle: "Kelola kartu, tabungan, dan dompet digital Anda.",
          ),
        );
      case 4:
      default:
        return _buildProfilePage(primaryBlue);
    }
  }

  Widget _scrollToTopButton({required bool visible, required VoidCallback onTap}) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 1.4),
      duration: const Duration(milliseconds: 180),
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: EdgeInsets.only(bottom: 12 + bottomInset),
          child: FloatingActionButton.small(
            heroTag: null,
            backgroundColor: const Color(0xFF0D8BFF),
            onPressed: onTap,
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePage(Color primaryBlue) {
    final displayContact = widget.contact.isEmpty ? "Nomor belum diisi" : widget.contact;
    final topInset = MediaQuery.of(context).padding.top;
    const moneySectionOverlap = 30.0;
    final profileHeaderHeight = topInset + (MediaQuery.of(context).size.width > 600 ? 260 : 230);

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _profileScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: profileHeaderHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryBlue,
                                primaryBlue.withOpacity(0.92),
                                primaryBlue,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 12),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: _pickProfileImage,
                                          child: CircleAvatar(
                                            radius: 42,
                                            backgroundColor: Colors.white,
                                            backgroundImage:
                                                _profileImage != null ? MemoryImage(_profileImage!) : null,
                                            child: _profileImage == null
                                                ? const Icon(Icons.person, color: Color(0xFF0D8BFF), size: 38)
                                                : null,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: _showProfileDetails,
                                                child: Text(
                                                  _profileName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                displayContact,
                                                style: const TextStyle(color: Colors.white70),
                                              ),
                                              const SizedBox(height: 10),
                                              Wrap(
                                                spacing: 10,
                                                runSpacing: 8,
                                                children: [
                                                  _profilePill(Icons.qr_code_2_outlined, "QR Saya >"),
                                                  _proteksiXtraPill(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Transform.translate(
                                      offset: const Offset(-8, moneySectionOverlap),
                                      child: _moneySection(primaryBlue),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: OutlinedButton(
                                    onPressed: _editProfileName,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(color: Colors.white.withOpacity(0.7)),
                                      backgroundColor: Colors.white.withOpacity(0.12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text("Edit"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 24 + moneySectionOverlap)),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileSection(
                        title: "Layanan & Bantuan",
                        items: [
                          _ProfileItem(
                            Icons.receipt_long_outlined,
                            "My Bills",
                            "Kelola dan bayar tagihan kamu.",
                            leading: const Icon(Icons.receipt_long_outlined, color: Colors.orange),
                          ),
                          _ProfileItem(
                            Icons.percent,
                            "Voucher Promo",
                            "Lihat dan gunakan promo yang tersedia.",
                            leading: _voucherPromoIcon(),
                          ),
                          _ProfileItem(
                            Icons.settings_outlined,
                            "Pengaturan",
                            "Bahasa, notifikasi, dan preferensi lainnya.",
                          ),
                          _ProfileItem(
                            Icons.info_outline,
                            "Info Umum",
                            "Informasi akun dan perangkat terhubung.",
                            leading: const Icon(Icons.info_outline, color: Colors.green),
                          ),
                          _ProfileItem(
                            Icons.headset_mic_outlined,
                            "DIANA siap membantu!",
                            "Butuh bantuan? Hubungi kami.",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: _scrollToTopButton(
              visible: _showProfileScrollToTop,
              onTap: () => _scrollToTop(_profileScrollController),
            ),
          ),
        ],
      ),
    );
  }

  Widget _proteksiXtraPill() {
    const labelColor = Colors.white;
    final shieldRed = Colors.red.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.shield, color: shieldRed, size: 20),
              const Text(
                "!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          const Text(
            "Proteksi Xtra",
            style: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profilePill(IconData icon, String label) {
    const pillPrimary = Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: pillPrimary, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: pillPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileSection({required String title, required List<_ProfileItem> items}) {
    final hasTitle = title.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.grey.shade900,
              ),
            ),
          if (hasTitle) const SizedBox(height: 10),
          ...items.map((item) => Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                    leading: item.leading ?? Icon(item.icon ?? Icons.circle, color: const Color(0xFF0D8BFF)),
                    title: Text(
                      item.title,
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade900),
                    ),
                    subtitle: Text(item.subtitle, style: TextStyle(color: Colors.grey.shade600)),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
                    onTap: () {},
                  ),
                  if (item != items.last)
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _moneySection(Color primaryBlue) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final spacing = maxWidth < 360 ? 6.0 : 10.0;
        const columns = 3;
        const leftPadding = 14.0;
        const rightPadding = 30.0;
        const keluargaOffset = 8.0;
        final contentWidth = math.max(0, maxWidth - (leftPadding + rightPadding + 4.0 + keluargaOffset));
        final cardWidth = (contentWidth - (spacing * (columns - 1))) / columns;

        final saldoCard = _quickFeatureCard(
          width: cardWidth,
          iconWidget: _balanceLogoIcon(primaryBlue),
          title: "Saldo",
          subtitle: _formatRupiah(_balanceAmount),
          color: primaryBlue,
        );
        final emasCard = _quickFeatureCard(
          width: cardWidth,
          iconWidget: _emasBagIcon(),
          title: "eMAS",
          subtitle: "Mulai INves Yuk",
          color: primaryBlue,
        );
        final goalsCard = _quickFeatureCard(
          width: cardWidth,
          iconWidget: _goalsTargetIcon(),
          title: "DANA Goals",
          subtitle: "Buat impian",
          color: primaryBlue,
        );
        final rekanDanaCard = _quickFeatureCard(
          width: cardWidth,
          iconWidget: _kioskDanaIcon(primaryBlue),
          title: "Rekan DANA",
          subtitle: "Get Profits!",
          color: primaryBlue,
        );
        final keluargaCard = _quickFeatureCard(
          width: cardWidth,
          iconWidget: _familyCircleIcon(),
          title: "Rek. Keluarga",
          subtitle: "Aktivitas Yuk!",
          color: primaryBlue,
        );

        return Container(
          padding: const EdgeInsets.fromLTRB(leftPadding, 14, rightPadding, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        saldoCard,
                        SizedBox(width: spacing),
                        goalsCard,
                        SizedBox(width: spacing + keluargaOffset),
                        keluargaCard,
                      ],
                    ),
                    SizedBox(height: spacing),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        emasCard,
                        SizedBox(width: spacing),
                        rekanDanaCard,
                        SizedBox(width: spacing),
                        SizedBox(width: cardWidth),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _moneySummaryCard(
                      title: "Uang Masuk",
                      amount: _incomingAmount,
                      subtitle: "",
                      iconColor: Colors.green,
                      amountColor: Colors.black,
                      iconData: Icons.arrow_upward,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Detail uang masuk ditampilkan."),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _moneySummaryCard(
                      title: "Uang Keluar",
                      amount: _formatRupiah(_outgoingAmount),
                      subtitle: "",
                      iconColor: Colors.orange,
                      amountColor: Colors.black,
                      iconData: Icons.arrow_downward,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Detail uang keluar ditampilkan."),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _quickFeatureCard({
    IconData? icon,
    Widget? iconWidget,
    required String title,
    required String subtitle,
    required Color color,
    required double width,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconWidget ??
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade100,
                    child: Icon(icon, color: color),
                  ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _balanceLogoIcon(Color primaryBlue) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CircleAvatar(
        backgroundColor: primaryBlue,
        radius: 18,
        child: SizedBox(
          width: 24,
          height: 20,
          child: CustomPaint(
            painter: const MoneyLogoPainter(Colors.white, waveHeightFactor: 0.13),
            size: const Size(24, 20),
          ),
        ),
      ),
    );
  }

  Widget _kioskDanaIcon(Color primaryBlue) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _KioskDanaPainter(primaryBlue),
      ),
    );
  }

  Widget _familyCircleIcon() {
    return SizedBox(
      width: 36,
      height: 36,
      child: CircleAvatar(
        backgroundColor: Colors.orange,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person, color: Colors.white, size: 15),
            SizedBox(width: 2),
            Icon(Icons.person_outline, color: Colors.white, size: 15),
          ],
        ),
      ),
    );
  }

  Widget _emasBagIcon() {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _EmasBagPainter(),
      ),
    );
  }

  Widget _goalsTargetIcon() {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.red.shade600,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneySummaryCard({
    required String title,
    required String amount,
    required String subtitle,
    required Color iconColor,
    required Color amountColor,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconColor.withOpacity(0.12),
              child: Icon(iconData, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: amountColor,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Future<void> _editProfileName() async {
    final controller = TextEditingController(text: _profileName);
    final result = await showDialog<_ProfileEditResult>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ubah profil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _profileImage != null ? MemoryImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt_outlined, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Masukkan nama baru",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(
                _ProfileEditResult(name: controller.text.trim(), image: _profileImage),
              ),
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );

    if (result == null) return;
    if (result.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama tidak boleh kosong"),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _profileName = result.name;
      _profileImage = result.image ?? _profileImage;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profil diperbarui menjadi \"${result.name}\""),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (!_isScanning || capture.barcodes.isEmpty) return;
    final barcode = capture.barcodes.first;
    final value = barcode.rawValue ?? '';
    if (value.isEmpty) return;

    setState(() {
      _isScanning = false;
      _lastScan = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("QR terbaca: $value"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isScanning = true);
    });
  }

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final bytes = result.files.first.bytes;
    if (bytes == null) return;
    setState(() {
      _profileImage = bytes;
    });
  }

  Widget _placeholderPage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Colors.grey[500]),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _wrapMobile(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width > 1000
              ? 1100
              : MediaQuery.of(context).size.width > 600
                  ? 760
                  : 430,
        ),
        child: child,
      ),
    );
  }

  String _profileQrData() {
    final contactValue = widget.contact.isEmpty ? "nomor-belum-diisi" : widget.contact;
    return "pay:${_profileName.trim()}|$contactValue";
  }

  void _openPayScanner() {
    final sheetController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      autoStart: false,
    );
    bool showMyQr = false;
    bool scannerStarted = false;
    final qrData = _profileQrData();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        final padding = MediaQuery.of(context).viewPadding;
        final height = MediaQuery.of(context).size.height * 0.8;
        return SafeArea(
          child: SizedBox(
            height: height,
            child: StatefulBuilder(
              builder: (context, modalSetState) {
                Future.microtask(() async {
                  if (!scannerStarted && !showMyQr) {
                    try {
                      await sheetController.start();
                      scannerStarted = true;
                    } catch (_) {}
                  }
                });
                return Padding(
                  padding: EdgeInsets.only(bottom: padding.bottom > 0 ? padding.bottom : 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 48),
                          const Text(
                            "Bayar via QR",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ToggleButtons(
                          isSelected: [!showMyQr, showMyQr],
                          borderRadius: BorderRadius.circular(12),
                          selectedColor: Colors.white,
                          color: Colors.white70,
                          fillColor: Colors.white.withOpacity(0.08),
                          onPressed: (index) async {
                            modalSetState(() => showMyQr = index == 1);
                            try {
                              if (showMyQr) {
                                await sheetController.stop();
                                scannerStarted = false;
                              } else {
                                await sheetController.start();
                                scannerStarted = true;
                              }
                            } catch (_) {}
                          },
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: Text("Pindai"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              child: Text("QR Saya"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: showMyQr
                                ? Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        QrImageView(
                                          data: qrData,
                                          size: 220,
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _profileName,
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.contact.isEmpty ? "Nomor belum diisi" : widget.contact,
                                          style: const TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  )
                                : Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      MobileScanner(
                                        controller: sheetController,
                                        onDetect: _handleBarcode,
                                        errorBuilder: (context, error) {
                                          return Container(
                                            color: Colors.black.withOpacity(0.6),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Kamera tidak tersedia: $error",
                                              style: const TextStyle(color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white.withOpacity(0.7), width: 2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(showMyQr ? Icons.qr_code : Icons.qr_code_scanner, color: Colors.white70, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  showMyQr ? "Tunjukkan QR ini untuk menerima pembayaran" : "Arahkan ke QR untuk bayar",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            if (!showMyQr)
                              TextButton.icon(
                                onPressed: () {
                                  sheetController.toggleTorch();
                                },
                                icon: const Icon(Icons.flash_on, color: Colors.white),
                                label: const Text("Torch", style: TextStyle(color: Colors.white)),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).whenComplete(() {
      sheetController.dispose();
    });
  }

  void _showProfileDetails() {
    final displayContact = widget.contact.isEmpty ? "Nomor belum diisi" : widget.contact;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profil saya",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Informasi personal",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.person_outline),
                    title: Text(_profileName),
                    subtitle: const Text("Nama pengguna"),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.phone_iphone_outlined),
                    title: Text(displayContact),
                    subtitle: const Text("Nomor terdaftar"),
                  ),
                  const Divider(height: 24),
                  const Text(
                    "Informasi tambahan",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  const ListTile(
                    dense: true,
                    leading: Icon(Icons.email_outlined),
                    title: Text("Belum diisi"),
                    subtitle: Text("Email"),
                  ),
                  const ListTile(
                    dense: true,
                    leading: Icon(Icons.home_work_outlined),
                    title: Text("Belum diisi"),
                    subtitle: Text("Alamat/Kota"),
                  ),
                  const Divider(height: 24),
                  const Text(
                    "Akun terhubung",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.link, color: Colors.grey[700]),
                    title: const Text("Belum ada akun terhubung"),
                    subtitle: const Text("Hubungkan akun bank atau dompet lain."),
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: const Text("Hubungkan"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileItem {
  final IconData? icon;
  final String title;
  final String subtitle;
  final Widget? leading;

  const _ProfileItem(this.icon, this.title, this.subtitle, {this.leading});
}

class _ProfileEditResult {
  final String name;
  final Uint8List? image;

  const _ProfileEditResult({required this.name, this.image});
}

class _DanaDealsTicketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ticketRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(6),
    );
    final ticketPaint = Paint()..color = const Color(0xFFFF9A3D);
    canvas.drawRRect(ticketRect, ticketPaint);

    final percentCenter = Offset(size.width * 0.28, size.height * 0.5);
    final textPainter = TextPainter(
      text: TextSpan(
        text: "%",
        style: TextStyle(
          color: Colors.white,
          fontSize: size.height * 0.42,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      percentCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    final dotPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final lineTop = size.height * 0.14;
    final lineBottom = size.height * 0.86;
    final lineX = size.width * 0.82;
    final totalHeight = lineBottom - lineTop;
    final spacing = totalHeight / 4;
    final dotRadius = size.height * 0.07;
    for (int i = 0; i < 5; i++) {
      final y = lineTop + (i * spacing);
      canvas.drawCircle(Offset(lineX, y), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MoneyBillPainter extends CustomPainter {
  final Color color;

  _MoneyBillPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final outline = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final waveHeight = size.height * 0.15;

    path.moveTo(0, waveHeight);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, waveHeight);
    path.quadraticBezierTo(size.width * 0.75, waveHeight * 2, size.width, waveHeight);
    path.lineTo(size.width, size.height - waveHeight);
    path.quadraticBezierTo(size.width * 0.75, size.height, size.width * 0.5, size.height - waveHeight);
    path.quadraticBezierTo(size.width * 0.25, size.height - (waveHeight * 2), 0, size.height - waveHeight);
    path.close();

    canvas.drawPath(path, background);
    canvas.drawPath(path, outline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BalanceMoneyPainter extends CustomPainter {
  final Color color;

  _BalanceMoneyPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final squareSize = size.shortestSide * 0.8;
    final topLeft = Offset(
      (size.width - squareSize) / 2,
      (size.height - squareSize) / 2,
    );

    final border = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = squareSize * 0.12
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(topLeft.dx, topLeft.dy, squareSize, squareSize),
      const Radius.circular(4),
    );
    canvas.drawRRect(rrect, border);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = squareSize * 0.14
      ..strokeCap = StrokeCap.round;

    final firstLineY = topLeft.dy + squareSize * 0.42;
    final secondLineY = topLeft.dy + squareSize * 0.65;
    final horizontalPadding = squareSize * 0.2;

    canvas.drawLine(
      Offset(topLeft.dx + horizontalPadding, firstLineY),
      Offset(topLeft.dx + squareSize - horizontalPadding, firstLineY),
      linePaint,
    );

    canvas.drawLine(
      Offset(topLeft.dx + horizontalPadding, secondLineY),
      Offset(topLeft.dx + squareSize * 0.6, secondLineY),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WavyCirclePainter extends CustomPainter {
  final Color color;

  _WavyCirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.shortestSide / 2.2;
    final waveAmplitude = baseRadius * 0.14;
    const waves = 8;
    const segments = 64;

    final path = Path();
    for (int i = 0; i <= segments; i++) {
      final theta = (2 * math.pi * i) / segments;
      final ripple = math.sin(theta * waves) * waveAmplitude;
      final radius = baseRadius + ripple;
      final point = Offset(
        center.dx + radius * math.cos(theta),
        center.dy + radius * math.sin(theta),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _KioskDanaPainter extends CustomPainter {
  final Color bodyColor;

  _KioskDanaPainter(this.bodyColor);

  @override
  void paint(Canvas canvas, Size size) {
    final roofHeight = 10.0;
    final stripeColors = [
      Colors.red.shade600,
      Colors.white,
      Colors.red.shade600,
      Colors.white,
      Colors.red.shade600,
    ];
    final stripeWidth = size.width / stripeColors.length;

    for (int i = 0; i < stripeColors.length; i++) {
      final rect = Rect.fromLTWH(i * stripeWidth, 0, stripeWidth, roofHeight);
      canvas.drawRect(rect, Paint()..color = stripeColors[i]);
    }

    final roofLine = Paint()
      ..color = Colors.red.shade700
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, roofHeight), Offset(size.width, roofHeight), roofLine);

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, roofHeight, size.width - 8, size.height - roofHeight),
      const Radius.circular(5),
    );
    canvas.drawRRect(bodyRect, Paint()..color = bodyColor);

    final circleRadius = 9.0;
    final circleCenter = Offset(
      bodyRect.left + bodyRect.width / 2,
      bodyRect.top + bodyRect.height / 2,
    );
    canvas.drawCircle(circleCenter, circleRadius, Paint()..color = Colors.white);

    final moneyPainter = MoneyLogoPainter(bodyColor, waveHeightFactor: 0.13);
    canvas.save();
    canvas.translate(circleCenter.dx - 7, circleCenter.dy - 5);
    moneyPainter.paint(canvas, const Size(14, 10));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EmasBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final orange = const Color(0xFFFFA726);
    final orangeDark = const Color(0xFFE08B00);
    final bagRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 12, size.width - 8, size.height - 16),
      const Radius.circular(6),
    );

    final bagPaint = Paint()..color = orange;
    canvas.drawRRect(bagRect, bagPaint);

    final rimPaint = Paint()
      ..color = orangeDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final rimY = bagRect.top + 3;
    canvas.drawLine(Offset(bagRect.left + 4, rimY), Offset(bagRect.right - 4, rimY), rimPaint);

    final midLinePaint = Paint()
      ..color = orangeDark
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final lineTop = bagRect.top + 4;
    final lineBottom = bagRect.bottom - 4;
    final lineX1 = bagRect.left + (bagRect.width * 0.35);
    final lineX2 = bagRect.left + (bagRect.width * 0.65);
    canvas.drawLine(Offset(lineX1, lineTop), Offset(lineX1, lineBottom), midLinePaint);
    canvas.drawLine(Offset(lineX2, lineTop), Offset(lineX2, lineBottom), midLinePaint);

    final handlePaint = Paint()
      ..color = orangeDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final handlePath = Path()
      ..moveTo(size.width * 0.32, 10)
      ..quadraticBezierTo(size.width * 0.5, 4, size.width * 0.68, 10);
    canvas.drawPath(handlePath, handlePaint);

    final moundBaseY = bagRect.top + 2;
    final moundPeakY = bagRect.top - 6;
    final mound = Path()
      ..moveTo(bagRect.left + 4, moundBaseY)
      ..quadraticBezierTo(size.width * 0.5, moundPeakY, bagRect.right - 4, moundBaseY)
      ..close();
    canvas.drawPath(mound, Paint()..color = orange);
    canvas.drawPath(
      mound,
      Paint()
        ..color = orangeDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final shine = Path()
      ..moveTo(size.width * 0.48, moundPeakY + 4)
      ..quadraticBezierTo(size.width * 0.6, moundPeakY + 6, size.width * 0.68, moundBaseY - 1)
      ..lineTo(size.width * 0.62, moundBaseY - 1)
      ..quadraticBezierTo(size.width * 0.52, moundPeakY + 6, size.width * 0.48, moundPeakY + 5)
      ..close();
    canvas.drawPath(shine, Paint()..color = Colors.yellow.shade200);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
