import 'package:flutter/material.dart';
import 'electric_bill_detail_page.dart'; // <-- GANTI INI

class ElectricBillPage extends StatefulWidget {
  final int currentBalance;

  const ElectricBillPage({super.key, required this.currentBalance});

  @override
  State<ElectricBillPage> createState() => _ElectricBillPageState();
}

class _ElectricBillPageState extends State<ElectricBillPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerController = TextEditingController();

  Color get primaryPurple => const Color(0xFF5B2ECC);

  bool get _isFormValid =>
      _customerController.text.trim().isNotEmpty &&
      RegExp(r'^[0-9]+$').hasMatch(_customerController.text.trim());

  @override
  void initState() {
    super.initState();
    // supaya tombol "Periksa" update state ketika user ngetik
    _customerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  Future<void> _onPeriksa() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ElectricBillDetailPage(
          currentBalance: widget.currentBalance,
          billAmount: 480, // TOTAL tagihan listrik (470 + 10)
          customerNumber: _customerController.text.trim(),
        ),
      ),
    );

    // kalau ada hasil dari detail (sisa saldo + activity), teruskan ke Dashboard
    if (result != null) {
      Navigator.pop(context, result);
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
          'Tagihan Listrik',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No Pelanggan',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),

                  // TEXTBOX HANYA ANGKA
                  TextFormField(
                    controller: _customerController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode pelanggan',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Kode pelanggan tidak boleh kosong';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(v.trim())) {
                        return 'Kode pelanggan hanya boleh angka';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Tolong perhatikan kode tagihan listrik\nagar tidak salah!',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _onPeriksa : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        disabledBackgroundColor: const Color(0xFFE3E3F0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Periksa',
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
        ),
      ),
    );
  }
}
