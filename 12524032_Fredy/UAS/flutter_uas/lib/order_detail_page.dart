import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  int selectedPayment = 0; // 0 = Credit Card, 1 = Cash

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pesanan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= ALAMAT =================
            Row(
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xffEDEAFF),
                  child: Icon(Icons.location_on, color: Colors.deepPurple),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jl. ABC sampai Z",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "Kec. Bogor",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            // ================= WAKTU =================
            Row(
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xffEDEAFF),
                  child: Icon(Icons.access_time, color: Colors.deepPurple),
                ),
                SizedBox(width: 12),
                Text(
                  "6:00 Pagi, Minggu 20",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),

            const SizedBox(height: 25),

            // ================= ORDER SUMMARY BOX =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _row("Layanan", "1"),
                  _row("Harga Sebelum Diskon", "Rp200.000"),
                  _row("Diskon", "Rp25.000"),
                  _row("Biaya Kunjungan", "Rp2.000"),
                  const Divider(),
                  _row(
                    "Total",
                    "Rp177.000",
                    bold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ================= METODE PEMBAYARAN =================
            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _paymentOption(
              title: "Credit Card",
              icon: "💳",
              index: 0,
            ),

            const SizedBox(height: 8),

            _paymentOption(
              title: "Cash",
              icon: "💰",
              index: 1,
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tambah Metode Pembayaran",
                  style: TextStyle(fontSize: 15),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.deepPurple,
                  child: const Icon(Icons.add, color: Colors.white),
                )
              ],
            ),

            const SizedBox(height: 40),

            // ================= BUTTON CHECKOUT =================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Check Out",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Row item in summary
  Widget _row(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(fontSize: 14)),
          Text(
            right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Payment Option Widget
  Widget _paymentOption({required String title, required String icon, required int index}) {
    bool selected = selectedPayment == index;

    return GestureDetector(
      onTap: () => setState(() => selectedPayment = index),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? Colors.deepPurple : Colors.grey,
          )
        ],
      ),
    );
  }
}