import 'package:flutter/material.dart';
import 'wallet_store.dart';
import 'package:flutter/services.dart';
import '../widgets/rupiah_formatter.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final targetC = TextEditingController();
  final amountC = TextEditingController();

  @override
  void dispose() {
    targetC.dispose();
    amountC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text('Transfer ShopPay'),
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
            const Text('Tujuan (ID/No. HP)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: targetC,
              decoration: InputDecoration(
                hintText: 'Contoh: 081234567890 / @username',
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: const Color(0xFFFFFBF5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Nominal (Rp)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: amountC,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RupiahInputFormatter(),
              ],
              decoration: InputDecoration(
                hintText: 'Contoh: 75.000',
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB45F4B),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  final to = targetC.text.trim();
                  final amt = int.tryParse(amountC.text.replaceAll('.', '').replaceAll(',', '').trim()) ?? 0;
                  if (to.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tujuan tidak boleh kosong')));
                    return;
                  }
                  if (amt <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid')));
                    return;
                  }
                  final ok = WalletStore.debit(amt, note: 'Transfer ke $to');
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saldo ShopPay tidak cukup')));
                    return;
                  }
                  Navigator.pop(context, amt);
                },
                child: const Text('Kirim'),
              ),
            ),
          ],
        ),
              ),
            );
          },
        ),
      ),
    );
  }
}
