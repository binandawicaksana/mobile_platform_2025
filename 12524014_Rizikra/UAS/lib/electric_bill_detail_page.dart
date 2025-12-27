import 'package:flutter/material.dart';

class ElectricBillDetailPage extends StatelessWidget {
  final int currentBalance;
  final int billAmount; // contoh: 480
  final String customerNumber;

  const ElectricBillDetailPage({
    super.key,
    required this.currentBalance,
    required this.billAmount,
    required this.customerNumber,
  });

  Color get primaryPurple => const Color(0xFF5B2ECC);
  Color get blueText => const Color(0xFF3B4FFF);
  Color get redText => const Color(0xFFFF3B3B);

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7FB);
    const listrikAmount = 470;
    const pajakAmount = 10;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ================== ILUSTRASI ATAS ==================
              SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/images/gambar2.png', // ilustrasi listrikmu
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '01/10/2025 – 01/11/2025',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 18),

              // ================== KARTU DETAIL TAGIHAN ==================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Semua Tagihan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildInfoRow('Nama', 'Rizikra Apri'),
                    _buildInfoRow('Alamat', 'Gang Dukuh'),
                    _buildInfoRow('Nomor Handphone', '0851-2912-2910'),
                    _buildInfoRow('No Pelanggan', customerNumber),
                    _buildInfoRow('Dari', '01/10/2025'),
                    _buildInfoRow('Sampai', '01/11/2025'),

                    const SizedBox(height: 8),
                    const Divider(height: 24, color: Color(0xFFEFEFEF)),

                    // Baris harga dengan style seperti contoh
                    _buildPriceRow(
                      label: 'Biaya Listrik',
                      value: '\$$listrikAmount',
                      color: blueText,
                    ),
                    _buildDashedDivider(),
                    _buildPriceRow(
                      label: 'Pajak',
                      value: '\$$pajakAmount',
                      color: blueText,
                    ),

                    const SizedBox(height: 4),
                    const Divider(height: 24, color: Color(0xFFEFEFEF)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '\$$billAmount',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: redText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================== BUTTON BAYAR TAGIHAN ==================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // LOGIKA TETAP: cek saldo, buat activity, kirim ke atas
                    if (billAmount > currentBalance) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Saldo tidak cukup'),
                          content: Text(
                            'Saldo kamu hanya \$$currentBalance.\n'
                            'Tidak bisa membayar \$$billAmount.',
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

                    final remaining = currentBalance - billAmount;
                    final activity = <String, dynamic>{
                      'type': 'bayar_listrik',
                      'name': 'Tagihan Listrik',
                      'amount': billAmount,
                      'date': DateTime.now().toIso8601String(),
                    };

                    Navigator.pop(context, {
                      'remainingBalance': remaining,
                      'activity': activity,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Bayar Tagihan',
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
    );
  }

  // ================== WIDGET KECIL ==================

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
                fontWeight: FontWeight.w600, // kanan lebih tebal
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // garis putus-putus tipis di antara Biaya Listrik & Pajak
  Widget _buildDashedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashWidth = 4.0;
          final dashSpace = 4.0;
          final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
              .floor();

          return Row(
            children: List.generate(dashCount, (_) {
              return Padding(
                padding: EdgeInsets.only(right: dashSpace),
                child: SizedBox(
                  width: dashWidth,
                  height: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
