import 'package:flutter/material.dart';
import 'internet_bill_detail_page.dart';

class InternetBillPage extends StatefulWidget {
  final int currentBalance;

  const InternetBillPage({super.key, required this.currentBalance});

  @override
  State<InternetBillPage> createState() => _InternetBillPageState();
}

class _InternetBillPageState extends State<InternetBillPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerController = TextEditingController();

  final List<String> _operators = [
    'Indihome',
    'Biznet',
    'First Media',
    'MyRepublic',
  ];

  String? _selectedOperator;

  Color get primaryPurple => const Color(0xFF5B2ECC);

  bool get _isFormValid =>
      _selectedOperator != null && _customerController.text.trim().isNotEmpty;

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
        builder: (_) => InternetBillDetailPage(
          currentBalance:
              widget.currentBalance, // ✅ pakai widget.currentBalance
          billAmount: 60, // TOTAL yang mau dibayar
        ),
      ),
    );

    // kalau result != null, teruskan ke Dashboard (sama seperti transfer/tarik tunai)
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
          'Tagihan Internet',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // dropdown operator
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedOperator,
                            hint: const Text(
                              'Pilih Operator',
                              style: TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 13,
                              ),
                            ),
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                            ),
                            items: _operators
                                .map(
                                  (op) => DropdownMenuItem(
                                    value: op,
                                    child: Text(
                                      op,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedOperator = value);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'No Pelanggan',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),

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
                        'Tolong perhatikan kode tagihan internet\nagar tidak salah!',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
