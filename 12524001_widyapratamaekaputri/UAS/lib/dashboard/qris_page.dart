import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'wallet_store.dart';
import 'package:flutter/services.dart';
import '../widgets/rupiah_formatter.dart';

class QrisPage extends StatefulWidget {
  final int? initialAmount;
  final int initialTab;
  const QrisPage({super.key, this.initialAmount, this.initialTab = 0});

  @override
  State<QrisPage> createState() => _QrisPageState();
}

class _QrisPageState extends State<QrisPage> with SingleTickerProviderStateMixin {
  late TabController tabC;
  String? lastScan;
  final amountC = TextEditingController();
  late final MobileScannerController _scannerController;
  bool _torchOn = false;
  CameraFacing _facing = CameraFacing.back;

  @override
  void initState() {
    super.initState();
    tabC = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    if (widget.initialAmount != null && widget.initialAmount! > 0) {
      amountC.text = widget.initialAmount!.toString();
    }
    _scannerController = MobileScannerController(
      facing: _facing,
      torchEnabled: _torchOn,
      detectionSpeed: DetectionSpeed.normal,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    tabC.dispose();
    amountC.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD9A679),
        title: const Text('QRIS'),
        centerTitle: true,
        bottom: TabBar(
          controller: tabC,
          tabs: const [
            Tab(text: 'Bayar (Scan)'),
            Tab(text: 'Tampilkan QR'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabC,
        children: [
          _buildScan(),
          _buildShowQr(),
        ],
      ),
    );
  }

  Widget _buildScan() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _scannerController,
                    onDetect: (capture) {
                      final barcodes = capture.barcodes;
                      if (barcodes.isEmpty) return;
                      final val = barcodes.first.rawValue;
                      if (val == null) return;
                      setState(() => lastScan = val);
                    },
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            _torchOn = !_torchOn;
                            await _scannerController.toggleTorch();
                            setState(() {});
                          },
                          icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            _facing = _facing == CameraFacing.back
                                ? CameraFacing.front
                                : CameraFacing.back;
                            await _scannerController.switchCamera();
                            setState(() {});
                          },
                          icon: const Icon(Icons.cameraswitch),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFBF5),
            border: Border(top: BorderSide(color: Colors.black12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hasil Scan: ${lastScan ?? '-'}'),
              const SizedBox(height: 6),
              TextField(
                controller: amountC,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RupiahInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: 'Masukkan nominal',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: const Color(0xFFFFFBF5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB45F4B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text('Bayar pakai ShopPay'),
                  onPressed: () {
                    final amt = int.tryParse(amountC.text.replaceAll('.', '').replaceAll(',', '').trim()) ?? 0;
                    if (lastScan == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QR belum discan.')));
                      return;
                    }
                    if (amt <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal tidak valid.')));
                      return;
                    }
                    final ok = WalletStore.debit(amt, note: 'QRIS ${lastScan!.substring(0, lastScan!.length > 12 ? 12 : lastScan!.length)}');
                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saldo ShopPay tidak cukup')));
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembayaran berhasil')));
                    Navigator.pop(context, amt);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShowQr() {
    final myId = 'ShopPay:WP-0015';
    final data = 'shop:$myId';
    final amtC = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                QrImageView(data: data, version: QrVersions.auto, size: 200),
                const SizedBox(height: 8),
                const Text('Tunjukkan QR ini ke pembayar'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amtC,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              RupiahInputFormatter(),
            ],
            decoration: InputDecoration(
              hintText: 'Opsional: tetapkan nominal',
              prefixText: 'Rp ',
              filled: true,
              fillColor: const Color(0xFFFFFBF5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Catatan: QR ini hanya contoh (static). Integrasi QRIS dinamis memerlukan backend/payment gateway.'),
        ],
      ),
    );
  }
}
