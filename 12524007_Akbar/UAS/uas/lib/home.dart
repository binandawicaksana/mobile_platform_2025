import 'dart:math' as math;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uas/widgets/money_logo_painter.dart';

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
  final String _incomingAmount = "Rp 12.500";
  final String _outgoingAmount = "Rp 7.800";
  Uint8List? _profileImage;
  static const List<_QuickAction> _quickActions = [
    _QuickAction("Pulsa & Data", Icons.signal_cellular_alt, Color(0xFFEAF4FF)),
    _QuickAction("A+ Rewards", Icons.emoji_events_outlined, Color(0xFFFFF3E6)),
    _QuickAction("Google Play Zone", Icons.games_outlined, Color(0xFFEFF5E8)),
    _QuickAction("Travel", Icons.flight_takeoff_outlined, Color(0xFFE7F5FF)),
    _QuickAction("Hadiah Harian", Icons.card_giftcard_outlined, Color(0xFFFFEEF3)),
    _QuickAction("Listrik", Icons.bolt_outlined, Color(0xFFEFF3FF)),
    _QuickAction("Dana Deals", Icons.local_offer_outlined, Color(0xFFE9F7F2)),
    _QuickAction("Lihat semua", Icons.more_horiz, Color(0xFFF3F4F6)),
  ];

  final List<_Promo> _promos = const [
    _Promo("Cashback 30% di merchant pilihan", "Cek detail promo dan klaim voucher sekarang."),
    _Promo("Gratis transfer bank 10x/bulan", "Aktifkan premium untuk nikmati bebas admin."),
    _Promo("Bayar tagihan jadi lebih mudah", "Simpan favorit dan bayar lebih cepat setiap bulan."),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          setState(() => _currentIndex = index);
        },
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
          const BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: "Aktivitas"),
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
                        _isBalanceHidden ? "Rp ••••••" : "Rp 2.500.000",
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
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: action.backgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(action.icon, color: primaryBlue, size: 24),
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

class _Bank {
  final String name;
  final String code;

  const _Bank(this.name, this.code);
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color backgroundColor;

  const _QuickAction(this.label, this.icon, this.backgroundColor);
}

extension on _HomePageState {
  Widget _buildBody(Color primaryBlue, Color secondaryBlue) {
    switch (_currentIndex) {
      case 0:
        final topInset = MediaQuery.of(context).padding.top;
        final headerHeight = topInset + (MediaQuery.of(context).size.width > 600 ? 330 : 300);
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryBlue,
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                _buildBalanceCard(primaryBlue, secondaryBlue),
                const SizedBox(height: 18),
                _wrapMobile(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildQuickActions(primaryBlue),
                  ),
                ),
                const SizedBox(height: 18),
                _wrapMobile(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildPromoList(),
                  ),
                ),
              ],
            ),
          ],
        );
      case 1:
        return _wrapMobile(
          _placeholderPage(
            icon: Icons.receipt_long_outlined,
            title: "Aktivitas",
            subtitle: "Transaksi terbaru akan tampil di sini.",
          ),
        );
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

  Widget _buildProfilePage(Color primaryBlue) {
    final displayContact = widget.contact.isEmpty ? "Nomor belum diisi" : widget.contact;
    final deepBlue = const Color(0xFF0A6ED1);
    final lightBlue = const Color(0xFF4EC8FF);

    return Container(
    color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(color: Colors.white),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryBlue,
                    deepBlue,
                    deepBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 1, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: _pickProfileImage,
                                    child: CircleAvatar(
                                      radius: 42,
                                      backgroundColor: Colors.white,
                                      backgroundImage: _profileImage != null ? MemoryImage(_profileImage!) : null,
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
                                            style: TextStyle(
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
                                  const SizedBox(width: 12),
                                  OutlinedButton(
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
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _moneySection(primaryBlue),
                        const SizedBox(height: 16),
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
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
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
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.center,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _quickFeatureCard(
                      iconWidget: _balanceLogoIcon(primaryBlue),
                      title: "Saldo",
                      subtitle: "Rp 2.500.000",
                      color: primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    _quickFeatureCard(
                      iconWidget: _emasBagIcon(),
                      title: "eMAS",
                      subtitle: "Mulai INves Yuk",
                      color: primaryBlue,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _quickFeatureCard(
                      iconWidget: _goalsTargetIcon(),
                      title: "DANA Goals",
                      subtitle: "Buat impian",
                      color: primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    _quickFeatureCard(
                      iconWidget: _kioskDanaIcon(primaryBlue),
                      title: "Rekan DANA",
                      subtitle: "Get Profits!",
                      color: primaryBlue,
                    ),
                  ],
                ),
                _quickFeatureCard(
                  iconWidget: _familyCircleIcon(),
                  title: "Rek. Keluarga",
                  subtitle: "Aktivitas Yuk!",
                  color: primaryBlue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
                  amount: _outgoingAmount,
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
  }

  Widget _quickFeatureCard({
    IconData? icon,
    Widget? iconWidget,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 160,
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
