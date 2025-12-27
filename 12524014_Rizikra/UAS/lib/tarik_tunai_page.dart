import 'package:flutter/material.dart';
import 'tarik_tunai_success_page.dart';

class TarikTunaiPage extends StatefulWidget {
  final int currentBalance;

  const TarikTunaiPage({super.key, required this.currentBalance});

  @override
  State<TarikTunaiPage> createState() => _TarikTunaiPageState();
}

class _TarikTunaiPageState extends State<TarikTunaiPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _customAmountController = TextEditingController();

  // akun/kartu yang tersedia
  final List<String> _accounts = ['4756 2191 7219 1682', '2912 2819 7482 5678'];

  // nominal yang ditampilkan di kotak
  final List<int> _amounts = [10, 50, 100, 150, 200];

  String? _selectedAccount;
  int? _selectedAmountIndex; // 0..len-1 = preset, len = Lainnya

  Color get primaryPurple => const Color(0xFF5B2ECC);

  bool get _isCustomSelected => _selectedAmountIndex == _amounts.length;

  /// VALIDASI FORM:
  /// - akun dipilih
  /// - no hp tidak kosong & hanya angka
  /// - nominal dipilih / diisi
  bool get _isFormValid {
    final phone = _phoneController.text.trim();

    if (_selectedAccount == null || phone.isEmpty) {
      return false;
    }

    // WAJIB HANYA ANGKA
    final onlyDigits = RegExp(r'^[0-9]+$');
    if (!onlyDigits.hasMatch(phone)) {
      return false;
    }

    if (_isCustomSelected) {
      final raw = _customAmountController.text.replaceAll('.', '');
      final n = int.tryParse(raw);
      return n != null && n > 0;
    } else {
      return _selectedAmountIndex != null &&
          _selectedAmountIndex! >= 0 &&
          _selectedAmountIndex! < _amounts.length;
    }
  }

  @override
  void initState() {
    super.initState();
    _customAmountController.addListener(_onCustomAmountChanged);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _customAmountController
      ..removeListener(_onCustomAmountChanged)
      ..dispose();
    super.dispose();
  }

  // format angka ribuan
  String _formatNumber(String value) {
    if (value.isEmpty) return "";
    value = value.replaceAll(".", "");
    final number = int.tryParse(value);
    if (number == null) return "";
    final s = number.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  void _onCustomAmountChanged() {
    final text = _customAmountController.text;
    final raw = text.replaceAll('.', '');
    if (raw.isEmpty) {
      setState(() {});
      return;
    }

    final n = int.tryParse(raw);
    if (n == null) {
      _customAmountController.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      setState(() {});
      return;
    }

    final formatted = _formatNumber(raw);
    if (formatted != text) {
      _customAmountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    setState(() {});
  }

  Future<void> _onVerify() async {
    final phone = _phoneController.text.trim();
    final onlyDigits = RegExp(r'^[0-9]+$');

    // CEK NO HP HANYA ANGKA
    if (!onlyDigits.hasMatch(phone)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Nomor tidak valid'),
          content: const Text(
            'Nomor handphone hanya boleh berisi angka (0-9).',
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

    int amount;

    if (_isCustomSelected) {
      final raw = _customAmountController.text.replaceAll('.', '');
      amount = int.tryParse(raw) ?? 0;
    } else {
      final idx = _selectedAmountIndex ?? 0;
      amount = _amounts[idx];
    }

    if (amount <= 0) return;

    // cek saldo cukup
    if (amount > widget.currentBalance) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Saldo tidak cukup'),
          content: Text(
            'Saldo kamu hanya \$${widget.currentBalance}. '
            'Tidak bisa menarik \$$amount.',
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

    // buka halaman sukses, tunggu user menekan "Selesai"
    final bool? isDone = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => TarikTunaiSuccessPage(amount: amount)),
    );

    // jika user tekan "Selesai"
    if (isDone == true) {
      final remaining = widget.currentBalance - amount;
      final now = DateTime.now().toIso8601String();

      final activity = <String, dynamic>{
        'type': 'tarik',
        'name': 'Tarik Tunai ATM',
        'amount': amount,
        'date': now,
      };

      // kirim balik ke dashboard
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
          'Tarik Tunai',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ilustrasi
              Center(
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/gambar2.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildAccountDropdown(),
              const SizedBox(height: 14),
              _buildPhoneField(),
              const SizedBox(height: 22),

              const Text(
                'Pilih Nominal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              _buildAmountGrid(),
              const SizedBox(height: 12),

              if (_isCustomSelected) _buildCustomAmountField(),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _onVerify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    disabledBackgroundColor: const Color(0xFFE3E3F0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Verifikasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              const Center(
                child: Text(
                  'Pastikan nomor handphone aktif untuk menerima kode.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGET KECIL =================

  Widget _buildAccountDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAccount,
          hint: const Text(
            'Pilih Akun/Kartu',
            style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: _accounts
              .map(
                (acc) => DropdownMenuItem(
                  value: acc,
                  child: Text(acc, style: const TextStyle(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedAccount = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          hintText: 'Nomor Handphone',
          hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildAmountGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const int columns = 3;
        const double spacing = 12.0;

        final double itemWidth =
            (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < _amounts.length; i++)
              _buildAmountItem(
                index: i,
                label: '\$${_amounts[i]}',
                width: itemWidth,
              ),
            _buildAmountItem(
              index: _amounts.length,
              label: 'Lainnya',
              width: itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAmountItem({
    required int index,
    required String label,
    required double width,
  }) {
    final bool selected = _selectedAmountIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAmountIndex = index;
          if (_isCustomSelected) {
            _customAmountController.text = '';
          }
        });
      },
      child: Container(
        width: width,
        height: 58,
        decoration: BoxDecoration(
          color: selected ? primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF707070),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: _customAmountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Masukkan nominal lainnya',
          hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
