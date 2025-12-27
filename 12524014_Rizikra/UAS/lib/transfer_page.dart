import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'transfer_success_page.dart';

// ==================== MODEL KONTAK & FORMAT ====================

class _Contact {
  final String name;
  final String cardNumber;
  _Contact(this.name, this.cardNumber);
}

String formatNumber(String value) {
  if (value.isEmpty) return "";
  value = value.replaceAll(".", "");
  final number = int.tryParse(value);
  if (number == null) return "";
  final s = number.toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
}

// ===============================================================

class TransferPage extends StatefulWidget {
  final int currentBalance; // saldo dari dashboard

  const TransferPage({super.key, required this.currentBalance});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  Color get primaryPurple => const Color(0xFF5B2ECC);
  Color get lightBackground => const Color(0xFFF6F7FB);

  final List<_Contact> _contacts = [
    _Contact('Sari', '0123456789109'),
    _Contact('Budiono', '9876543210123'),
  ];

  int? _selectedIndex;
  bool _isSave = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _confirmAmountController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _amountController.dispose();
    _confirmAmountController.dispose();
    super.dispose();
  }

  void _applyContact(int index) {
    final contact = _contacts[index];
    setState(() {
      _selectedIndex = index;
      _nameController.text = contact.name;
      _cardController.text = contact.cardNumber;
    });
  }

  Future<void> _addContactDialog() async {
    final nameController = TextEditingController();
    final cardController = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Tambah Kontak'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cardController,
                decoration: const InputDecoration(
                  labelText: 'Nomor kartu VISA',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    cardController.text.trim().isEmpty) {
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (ok == true) {
      setState(() {
        _contacts.add(
          _Contact(nameController.text.trim(), cardController.text.trim()),
        );
        _applyContact(_contacts.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transfer',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardSelector(),
              const SizedBox(height: 12),
              const Text(
                'Batas Pengiriman : 10,000\$',
                style: TextStyle(
                  color: Color(0xFF2757D8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Transaksi',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _buildTransactionType(),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Pilih',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    'Cari Kontak',
                    style: TextStyle(
                      color: Color(0xFF2757D8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _buildContactsRow(),

              const SizedBox(height: 24),

              _buildFormSection(),

              const SizedBox(height: 24),

              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: const [
          Text(
            '4762 2191 7219 1682',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Spacer(),
          Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ],
      ),
    );
  }

  Widget _buildTransactionType() {
    return Row(
      children: [
        Container(
          width: 140,
          height: 120,
          decoration: BoxDecoration(
            color: primaryPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.credit_card, color: Colors.white, size: 32),
              SizedBox(height: 12),
              Text(
                'Transfer via\nnomor kartu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactsRow() {
    return SizedBox(
      height: 90,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: _addContactDialog,
              child: Container(
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.add, size: 28, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ...List.generate(_contacts.length, (index) {
              final contact = _contacts[index];
              final isSelected = _selectedIndex == index;
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => _applyContact(index),
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: isSelected ? primaryPurple : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: isSelected
                                ? Colors.white
                                : Colors.grey.shade300,
                            child: Text(
                              contact.name.isNotEmpty ? contact.name[0] : '?',
                              style: TextStyle(
                                color: isSelected
                                    ? primaryPurple
                                    : Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contact.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          _textField(controller: _nameController, hint: 'Nama pengirim'),
          const SizedBox(height: 10),
          _textField(
            controller: _cardController,
            hint: 'Nomor kartu',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          _textField(
            controller: _amountController,
            hint: 'Masukkan jumlah saldo',
            keyboardType: TextInputType.number,
            digitsOnly: true,
            suffix: Transform.translate(
              offset: const Offset(0, 4),
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text(
                  '\$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              final formatted = formatNumber(value);
              if (formatted != value) {
                _amountController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
          ),
          const SizedBox(height: 10),
          _textField(
            controller: _confirmAmountController,
            hint: 'Konfirmasi jumlah saldo',
            keyboardType: TextInputType.number,
            digitsOnly: true,
            suffix: Transform.translate(
              offset: const Offset(0, 4),
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text(
                  '\$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              final formatted = formatNumber(value);
              if (formatted != value) {
                _confirmAmountController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _isSave,
                  onChanged: (v) {
                    setState(() {
                      _isSave = v ?? false;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: primaryPurple,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Simpan', style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    Widget? suffix,
    bool digitsOnly = false,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      inputFormatters: digitsOnly
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryPurple),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () async {
          final amountStr = _amountController.text.trim().replaceAll('.', '');
          final confirmStr = _confirmAmountController.text.trim().replaceAll(
            '.',
            '',
          );

          final amount = int.tryParse(amountStr) ?? 0;
          final confirmAmount = int.tryParse(confirmStr) ?? 0;

          if (amount < 10 || confirmAmount < 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Minimal tarik saldo 10\$')),
            );
            return;
          }

          if (amount != confirmAmount) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Jumlah saldo dan konfirmasi harus sama.'),
              ),
            );
            return;
          }

          if (amount > widget.currentBalance) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saldo tidak mencukupi.')),
            );
            return;
          }

          final remainingBalance = widget.currentBalance - amount;
          final formattedAmount = "\$${formatNumber(amount.toString())}";
          final receiverName = _nameController.text.isEmpty
              ? 'Penerima'
              : _nameController.text;

          // data yang akan dikirim ke Dashboard
          final Map<String, dynamic> resultData = {
            'remainingBalance': remainingBalance,
            'activity': {
              'type': 'kirim',
              'name': receiverName,
              'amount': amount,
              'date': DateTime.now().toIso8601String(),
            },
          };

          // 1) Buka halaman sukses, tunggu tombol "Selesai"
          final bool? done = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => TransferSuccessPage(
                amountText: formattedAmount,
                receiverName: receiverName,
              ),
            ),
          );

          // 2) Kalau user menekan "Selesai", pop lagi ke Dashboard
          if (done == true && mounted) {
            Navigator.pop(context, resultData);
          }
        },
        child: const Text(
          'Konfirmasi',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
