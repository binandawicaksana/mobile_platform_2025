import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'order_store.dart';
import 'pulsa_selesai.dart';
import 'qris_page.dart';

class PulsaPembayaranPage extends StatefulWidget {
  final String phoneNumber;
  final String provider;
  final String nominal; // e.g. "10.000"
  final String? paketLabel; // optional: when buying data package

  const PulsaPembayaranPage({
    super.key,
    required this.phoneNumber,
    required this.provider,
    required this.nominal,
    this.paketLabel,
  });

  @override
  State<PulsaPembayaranPage> createState() => _PulsaPembayaranPageState();
}

class _PulsaPembayaranPageState extends State<PulsaPembayaranPage> {
  int selectedMethod = 0;
  final methods = const ['QRIS', 'Transfer Bank', 'E-Wallet'];

  // VA
  String? vaNumber;
  int selectedBank = 0;
  final banks = const ['BCA', 'BRI', 'BNI', 'Mandiri'];

  int _parseNominal(String n) => int.tryParse(n.replaceAll('.', '').trim()) ?? 0;

  String _formatRp(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write('.');
    }
    return 'Rp${b.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final nominalInt = _parseNominal(widget.nominal);
    final admin = 1000;
    final total = nominalInt + admin;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text('Pembayaran'),
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
            // Detail pembelian
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
                  const Text('Detail Pembelian', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  _row('Nomor', widget.phoneNumber),
                  _row('Provider', widget.provider),
                  if (widget.paketLabel != null) _row('Paket Data', widget.paketLabel!),
                  _row('Nominal', _formatRp(nominalInt)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Metode
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
                  const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(methods.length, (i) {
                      final active = selectedMethod == i;
                      return ChoiceChip(
                        label: Text(methods[i]),
                        selected: active,
                        onSelected: (_) => setState(() { selectedMethod = i; vaNumber = null; }),
                        selectedColor: const Color(0xFFB45F4B),
                        labelStyle: TextStyle(color: active ? Colors.white : Colors.black),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tips: Pilih metode yang paling nyaman. Pembayaran diproses aman dan cepat seperti pengalaman checkout Shopee.',
                    style: TextStyle(fontSize: 12.5, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Detail tambahan per metode
            if (selectedMethod == 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('QR Pembayaran (Scan untuk membayar)', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Center(
                      child: QrImageView(
                        data: 'QRIS:${widget.phoneNumber}:${widget.provider}:$nominalInt',
                        version: QrVersions.auto,
                        size: 180,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text('Gunakan aplikasi e-wallet/bank untuk scan QR di atas. Atau gunakan tombol QRIS ShopPay di bawah.'),
                  ],
                ),
              )
            else if (selectedMethod == 1)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Transfer Bank', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
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
                    if (vaNumber == null)
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            final prefix = {
                              'BCA': '014',
                              'BRI': '002',
                              'BNI': '009',
                              'Mandiri': '008',
                            }[banks[selectedBank]]!;
                            final rnd = Random();
                            final code = List.generate(10, (_) => rnd.nextInt(10)).join();
                            setState(() { vaNumber = '$prefix$code'; });
                          },
                          child: const Text('Buat Nomor Pembayaran (VA)'),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText('Nomor VA ${banks[selectedBank]}: $vaNumber'),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(text: vaNumber!));
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor VA disalin')));
                                  },
                                  child: const Text('Salin'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Transfer ke nomor VA melalui bank Anda')),
                                    );
                                  },
                                  child: const Text('Lihat cara bayar'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB45F4B),
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                final isData = widget.paketLabel != null;
                                final productName = isData
                                    ? 'Paket Data ${widget.provider} ${widget.paketLabel!}'
                                    : 'Pulsa ${widget.provider} ${_formatRp(nominalInt)}';
                                OrderStore.diproses.add(
                                  OrderItem(
                                    name: productName,
                                    price: _formatRp(nominalInt),
                                    eta: 'Instan',
                                    imgUrl: isData ? 'icon:data' : 'icon:pulsa',
                                    qty: 1,
                                    shipping: 0,
                                    paymentMethod: 'Transfer Bank - ${banks[selectedBank]} (VA: $vaNumber)',
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PulsaSelesaiPage(
                                      phoneNumber: widget.phoneNumber,
                                      provider: widget.provider,
                                      nominal: _formatRp(nominalInt),
                                      method: 'Transfer Bank - ${banks[selectedBank]} (VA: $vaNumber)',
                                      total: _formatRp(total),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Konfirmasi Pembayaran Transfer'),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Total + aksi
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
                children: [
                  _row('Harga', _formatRp(nominalInt)),
                  _row('Biaya Admin', _formatRp(admin)),
                  const Divider(),
                  _row('Total', _formatRp(total), isBold: true, color: Colors.red),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text('Bayar via QRIS (ShopPay)'),
                      onPressed: () async {
                        final paid = await Navigator.push<int>(
                          context,
                          MaterialPageRoute(builder: (_) => QrisPage(initialAmount: total, initialTab: 0)),
                        );
                        if (paid != null && paid == total) {
                          final isData = widget.paketLabel != null;
                          final productName = isData
                              ? 'Paket Data ${widget.provider} ${widget.paketLabel!}'
                              : 'Pulsa ${widget.provider} ${_formatRp(nominalInt)}';
                          OrderStore.diproses.add(
                            OrderItem(
                              name: productName,
                              price: _formatRp(nominalInt),
                              eta: 'Instan',
                              imgUrl: isData ? 'icon:data' : 'icon:pulsa',
                              qty: 1,
                              shipping: 0,
                              paymentMethod: 'QRIS (ShopPay)',
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PulsaSelesaiPage(
                                phoneNumber: widget.phoneNumber,
                                provider: widget.provider,
                                nominal: _formatRp(nominalInt),
                                method: 'QRIS (ShopPay)',
                                total: _formatRp(total),
                              ),
                            ),
                          );
                        } else if (paid != null && paid != total) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nominal QR tidak sesuai total')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB45F4B),
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                      label: const Text('Bayar', style: TextStyle(fontWeight: FontWeight.w600)),
                      onPressed: () {
                        final isData = widget.paketLabel != null;
                        final productName = isData
                            ? 'Paket Data ${widget.provider} ${widget.paketLabel!}'
                            : 'Pulsa ${widget.provider} ${_formatRp(nominalInt)}';
                        String method = methods[selectedMethod];
                        if (selectedMethod == 1 && vaNumber == null) {
                          final prefix = {
                            'BCA': '014',
                            'BRI': '002',
                            'BNI': '009',
                            'Mandiri': '008',
                          }[banks[selectedBank]]!;
                          final rnd = Random();
                          final code = List.generate(10, (_) => rnd.nextInt(10)).join();
                          vaNumber = '$prefix$code';
                        }
                        if (selectedMethod == 1 && vaNumber != null) {
                          method = 'Transfer Bank - ${banks[selectedBank]} (VA: $vaNumber)';
                        }
                        OrderStore.diproses.add(
                          OrderItem(
                            name: productName,
                            price: _formatRp(nominalInt),
                            eta: 'Instan',
                            imgUrl: isData ? 'icon:data' : 'icon:pulsa',
                            qty: 1,
                            shipping: 0,
                            paymentMethod: method,
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PulsaSelesaiPage(
                              phoneNumber: widget.phoneNumber,
                              provider: widget.provider,
                              nominal: _formatRp(nominalInt),
                              method: method,
                              total: _formatRp(total),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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

  Widget _row(String left, String right, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(left)),
          Text(
            right,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
