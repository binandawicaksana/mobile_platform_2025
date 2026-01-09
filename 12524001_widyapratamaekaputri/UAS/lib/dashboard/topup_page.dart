import 'package:flutter/material.dart';
import 'wallet_store.dart';
import 'package:flutter/services.dart';
import '../widgets/rupiah_formatter.dart';
import 'qris_page.dart';
import 'dart:math';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final amountC = TextEditingController();
  int selectedMethod = 0;
  final methods = const ['Bank Transfer', 'QRIS', 'E-Wallet', 'Indomaret', 'Alfamart', 'Virtual Account'];
  String? paymentCode;
  String? vaNumber;
  int selectedBank = 0;
  final banks = const ['BCA', 'BRI', 'BNI', 'Mandiri'];

  int _parseAmt() => int.tryParse(amountC.text.replaceAll('.', '').replaceAll(',', '').trim()) ?? 0;

  @override
  void dispose() {
    amountC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text('Top Up ShopPay'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 14 + bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
            const Text('Metode Top Up', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBF5), Color(0xFFF4E0C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: List.generate(methods.length, (i) {
                  final active = selectedMethod == i;
                  return ChoiceChip(
                    label: Text(methods[i]),
                    selected: active,
                    onSelected: (_) => setState(() { selectedMethod = i; paymentCode = null; }),
                    selectedColor: const Color(0xFFB45F4B),
                    labelStyle: TextStyle(color: active ? Colors.white : Colors.black),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Nominal Top Up (Rp)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: amountC,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RupiahInputFormatter(),
              ],
              decoration: InputDecoration(
                hintText: 'Contoh: 100.000',
                prefixIcon: const Icon(Icons.payments_outlined),
                prefixText: 'Rp ',
                filled: true,
                fillColor: const Color(0xFFFFFBF5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildMethodSection(context),
            const SizedBox(height: 12),
            _buildDefaultAction(context),
          ],
        ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMethodSection(BuildContext context) {
    if (selectedMethod == 1) {
      return SizedBox(
        width: double.infinity,
        height: 46,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
          icon: const Icon(Icons.qr_code_2),
          label: const Text('Top Up via QRIS'),
          onPressed: () async {
            final amt = _parseAmt();
            if (amt <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid')));
              return;
            }
            final paid = await Navigator.push<int>(
              context,
              MaterialPageRoute(builder: (_) => QrisPage(initialAmount: amt, initialTab: 0)),
            );
            if (paid == amt) {
              WalletStore.credit(amt, note: 'Top up QRIS');
              if (!mounted) return;
              Navigator.pop(context, amt);
            }
          },
        ),
      );
    } else if (selectedMethod == 3 || selectedMethod == 4) {
      if (paymentCode == null) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB45F4B),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              final amt = _parseAmt();
              if (amt <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid')));
                return;
              }
              final rnd = Random();
              final code = List.generate(12, (_) => rnd.nextInt(10)).join();
              setState(() {
                paymentCode = (selectedMethod == 3 ? 'IND' : 'ALF') + '-$code';
              });
            },
            child: const Text('Buat Kode Pembayaran'),
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBF5), Color(0xFFF4E0C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kode Pembayaran ' + (selectedMethod == 3 ? 'Indomaret' : 'Alfamart'), style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  SelectableText(paymentCode!),
                  const SizedBox(height: 6),
                  Text('Tunjukkan kode ini ke kasir ' + (selectedMethod == 3 ? 'Indomaret' : 'Alfamart') + ' untuk melakukan pembayaran. Berlaku 24 jam.'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: paymentCode!));
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kode disalin')));
                    },
                    style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text('Salin Kode'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45F4B),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      final amt = _parseAmt();
                      if (amt <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid')));
                        return;
                      }
                      final note = 'Top up ' + (selectedMethod == 3 ? 'Indomaret' : 'Alfamart');
                      WalletStore.credit(amt, note: note);
                      Navigator.pop(context, amt);
                    },
                    child: const Text('Konfirmasi Pembayaran'),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    } else if (selectedMethod == 5) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Pilih Bank: '),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: selectedBank,
                items: List.generate(banks.length, (i) => DropdownMenuItem(value: i, child: Text(banks[i]))),
                onChanged: (v) => setState(() { selectedBank = v ?? 0; vaNumber = null; }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          (vaNumber == null)
              ? SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45F4B),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      final amt = _parseAmt();
                      if (amt <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid')));
                        return;
                      }
                      final rnd = Random();
                      final prefix = {
                        'BCA': '014',
                        'BRI': '002',
                        'BNI': '009',
                        'Mandiri': '008',
                      }[banks[selectedBank]]!;
                      final code = List.generate(10, (_) => rnd.nextInt(10)).join();
                      setState(() { vaNumber = '$prefix$code'; });
                    },
                    child: const Text('Buat Nomor VA'),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFFBF5), Color(0xFFF4E0C8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Virtual Account ${banks[selectedBank]}', style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          SelectableText(vaNumber!),
                          const SizedBox(height: 6),
                          const Text('Transfer ke nomor VA di atas melalui bank pilihan Anda.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: vaNumber!));
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor VA disalin')));
                            },
                            style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                            child: const Text('Salin VA'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB45F4B),
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              final amt = _parseAmt();
                              if (amt <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid')));
                                return;
                              }
                              WalletStore.credit(amt, note: 'Top up VA ${banks[selectedBank]}');
                              Navigator.pop(context, amt);
                            },
                            child: const Text('Konfirmasi Pembayaran'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDefaultAction(BuildContext context) {
    if (selectedMethod == 1 || selectedMethod == 3 || selectedMethod == 4 || selectedMethod == 5) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB45F4B),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          final amt = _parseAmt();
          if (amt <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid')));
            return;
          }
          final method = methods[selectedMethod];
          WalletStore.credit(amt, note: 'Top up $method');
          Navigator.pop(context, amt);
        },
        child: const Text('Top Up'),
      ),
    );
  }
}
