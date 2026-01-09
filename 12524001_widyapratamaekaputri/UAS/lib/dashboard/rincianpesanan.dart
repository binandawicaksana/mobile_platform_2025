import 'package:flutter/material.dart';
import 'profile_store.dart';

class RincianPesananPage extends StatelessWidget {
  final String name, price, eta, imgUrl;
  final int qty, shipping, subtotal, total;
  final String subtotalStr, shippingStr, totalStr;
  final String paymentMethod;

  const RincianPesananPage({
    super.key,
    required this.name,
    required this.price,
    required this.eta,
    required this.imgUrl,
    required this.qty,
    required this.shipping,
    required this.subtotal,
    required this.total,
    required this.subtotalStr,
    required this.shippingStr,
    required this.totalStr,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFA07A),
      appBar: AppBar(
        backgroundColor: const Color(0xFFBFA07A),
        elevation: 0,
        title: const Text(
          "Rincian Pesanan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // alamat
          _Box(
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ProfileStore.address,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 8),

          // produk
          _Box(
            child: Row(
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(imgUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text("x$qty"),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // pembayaran
          _Box(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Metode Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(paymentMethod, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // subtotal
          _Box(
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text("Subtotal")),
                    Text(subtotalStr,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text("Pengiriman")),
                    Text(shippingStr,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    const Expanded(
                        child: Text("Total",
                            style: TextStyle(fontWeight: FontWeight.w800))),
                    Text(totalStr,
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // estimasi
          _Box(
            child: Row(
              children: [
                const Icon(Icons.local_shipping_outlined),
                const SizedBox(width: 6),
                Text("Estimasi sampai: $eta"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final Widget child;
  const _Box({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E0C8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black26),
      ),
      child: child,
    );
  }
}
