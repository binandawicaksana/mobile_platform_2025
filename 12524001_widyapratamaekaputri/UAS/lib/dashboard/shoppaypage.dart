import 'package:flutter/material.dart';
import 'wallet_store.dart';
import 'topup_page.dart';
import 'transfer_page.dart';

class ShopPayPage extends StatefulWidget {
  const ShopPayPage({super.key});

  @override
  State<ShopPayPage> createState() => _ShopPayPageState();
}

class _ShopPayPageState extends State<ShopPayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text("ShopPay"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const SizedBox.shrink(),

            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBF5), Color(0xFFF4E0C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Column(
                children: [
                  const Text("Saldo ShopPay", style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${_fmt(WalletStore.balance)}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final amt = await Navigator.push<int>(
                        context,
                        MaterialPageRoute(builder: (_) => const TopUpPage()),
                      );
                      if (amt != null) setState(() {});
                    },
                    style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text("Top Up"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final amt = await Navigator.push<int>(
                        context,
                        MaterialPageRoute(builder: (_) => const TransferPage()),
                      );
                      if (amt != null) setState(() {});
                    },
                    style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text("Transfer"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Riwayat Transaksi",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 6),

            Expanded(
              child: ListView.builder(
                itemCount: WalletStore.history.length,
                itemBuilder: (_, i) => ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(color: Color(0xFFF4E0C8), shape: BoxShape.circle),
                    child: const Icon(Icons.receipt_long_outlined, color: Color(0xFFB45F4B)),
                  ),
                  title: Text(WalletStore.history[i], style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write('.');
    }
    return b.toString();
  }
}
