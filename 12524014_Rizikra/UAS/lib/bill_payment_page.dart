import 'package:flutter/material.dart';
import 'internet_bill_page.dart';
import 'electric_bill_page.dart';

class BillPaymentPage extends StatelessWidget {
  final int currentBalance;

  const BillPaymentPage({super.key, required this.currentBalance});

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
          'Bayar Tagihan',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _BillItem(
              title: 'Tagihan Listrik',
              subtitle: 'Bayar tagihan listrik bulan ini',
              assetPath: 'assets/images/tagihan_listrik.png',
              onTap: () async {
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ElectricBillPage(currentBalance: currentBalance),
                  ),
                );

                // kalau result ada (sisa saldo + activity), teruskan ke Dashboard
                if (result != null) {
                  Navigator.pop(context, result);
                }
              },
            ),
            const SizedBox(height: 16),
            _BillItem(
              title: 'Tagihan Internet',
              subtitle: 'Bayar tagihan internet bulan ini',
              assetPath: 'assets/images/tagihan_internet.png',
              onTap: () async {
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        InternetBillPage(currentBalance: currentBalance),
                  ),
                );

                // kalau result ada (sisa saldo + activity), teruskan ke Dashboard
                if (result != null) {
                  Navigator.pop(context, result);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BillItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final VoidCallback onTap;

  const _BillItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        height: 110,
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            // teks kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFB0B0B0),
                    ),
                  ),
                ],
              ),
            ),
            // gambar kanan
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
