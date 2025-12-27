import 'package:flutter/material.dart';
import 'internet_bill_success_page.dart';

class InternetBillDetailPage extends StatefulWidget {
  final int currentBalance;
  final int billAmount; // contoh: 60

  // nomor pelanggan opsional
  final String? customerNumber;

  const InternetBillDetailPage({
    super.key,
    required this.currentBalance,
    required this.billAmount,
    this.customerNumber,
  });

  @override
  State<InternetBillDetailPage> createState() => _InternetBillDetailPageState();
}

class _InternetBillDetailPageState extends State<InternetBillDetailPage> {
  final TextEditingController _otpController = TextEditingController(
    text: '281921',
  );

  final List<String> _cards = ['1268 9218 9219', '4756 2191 7219 1682'];
  String? _selectedCard;

  Color get primaryPurple => const Color(0xFF5B2ECC);
  Color get blueText => const Color(0xFF3B4FFF);
  Color get redText => const Color(0xFFFF3B3B);

  bool get _isFormValid =>
      _selectedCard != null && _otpController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _onBayar() async {
    if (!_isFormValid) return;

    // cek saldo cukup
    if (widget.billAmount > widget.currentBalance) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Saldo tidak cukup'),
          content: Text(
            'Saldo kamu hanya \$${widget.currentBalance}. '
            'Tidak bisa membayar \$${widget.billAmount}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // ke halaman sukses
    final bool? isDone = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => InternetBillSuccessPage(paidAmount: widget.billAmount),
      ),
    );

    // kalau di success page menekan "Selesai"
    if (isDone == true) {
      final remaining = widget.currentBalance - widget.billAmount;
      final activity = <String, dynamic>{
        'type': 'bayar_internet', // tipe untuk Aktivitas
        'name': 'Tagihan Internet', // judul di Aktivitas
        'amount': widget.billAmount, // 60
        'date': DateTime.now().toIso8601String(),
      };

      Navigator.pop(context, {
        'remainingBalance': remaining,
        'activity': activity,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7FB);

    return Scaffold(
      backgroundColor: bg,
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
          'Tagihan Internet',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================== KARTU DETAIL TAGIHAN ==================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Semua Tagihan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildInfoRow('Nama', 'Rizikra Apri'),
                    _buildInfoRow('Alamat', 'Gang Dukuh'),
                    _buildInfoRow('Nomor Handphone', '0851-2912-2910'),
                    _buildInfoRow(
                      'No Pelanggan',
                      widget.customerNumber ?? '261238123',
                    ),
                    _buildInfoRow('Dari', '01/10/2025'),
                    _buildInfoRow('Sampai', '01/11/2025'),

                    const SizedBox(height: 8),
                    const Divider(height: 24, color: Color(0xFFEFEFEF)),

                    _buildPriceRow(
                      label: 'Biaya Internet',
                      value: '\$50',
                      color: blueText,
                    ),
                    _buildPriceRow(
                      label: 'Pajak',
                      value: '\$10',
                      color: blueText,
                    ),

                    const SizedBox(height: 4),
                    const Divider(height: 24, color: Color(0xFFEFEFEF)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '\$${widget.billAmount}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: redText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================== DROPDOWN KARTU ==================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCard,
                    hint: const Text(
                      '1268 9218 9219',
                      style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    items: _cards
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCard = value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ================== OTP ==================
              const Text(
                'Dapatkan OTP untuk transaksi',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Kirim',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ================== BUTTON BAYAR ==================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _onBayar : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    disabledBackgroundColor: const Color(0xFFE3E3F0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Bayar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================== WIDGET KECIL ==================

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                fontWeight: FontWeight.w600, // kanan lebih tebal
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
