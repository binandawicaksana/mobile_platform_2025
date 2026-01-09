import 'package:flutter/material.dart';
import 'checkoutpage.dart';
import 'cart_store.dart';

class DetailBarangPage extends StatefulWidget {
  final String name;
  final String price;
  final String sold;
  final String eta;
  final String imgUrl;

  const DetailBarangPage({
    super.key,
    required this.name,
    required this.price,
    required this.sold,
    required this.eta,
    required this.imgUrl,
  });

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  int qty = 1;

  void inc() => setState(() => qty++);
  void dec() => setState(() {
        if (qty > 1) qty--;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFA07A),

      appBar: AppBar(
        backgroundColor: const Color(0xFFBFA07A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Icon(Icons.shopping_cart_outlined, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.image_outlined, color: Colors.black),
          SizedBox(width: 12),
          Icon(Icons.send_outlined, color: Colors.black),
          SizedBox(width: 10),
        ],
      ),

      // ✅ BODY DIBUAT LISTVIEW BIAR SCROLL, ANTI OVERFLOW
      body: ListView(
        children: [
          // gambar produk
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              widget.imgUrl,
              fit: BoxFit.cover,
              // kalau network error -> tetap ada box placeholder
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF4E0C8),
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  widget.price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.local_offer_outlined,
                    color: Colors.red, size: 18),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.sold,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.local_shipping_outlined,
                    size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  widget.eta,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80), // ruang supaya gak ketutup bottom bar
        ],
      ),

      // ✅ BOTTOM BAR PINDAH KE SINI BIAR AMAN
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: const Color(0xFFBFA07A),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  CartStore.add(CartItem(
                    name: widget.name,
                    price: widget.price,
                    imgUrl: widget.imgUrl,
                    eta: widget.eta,
                    qty: qty,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ditambahkan ke keranjang')),
                  );
                },
                child: Container(
                  height: 44,
                  width: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E0C8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4E0C8),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(
                            name: widget.name,
                            price: widget.price,
                            eta: widget.eta,
                            imgUrl: widget.imgUrl,
                            qty: qty,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Beli Sekarang",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: dec,
                      icon: const Icon(Icons.remove),
                      iconSize: 18,
                    ),
                    Text(
                      "$qty",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: inc,
                      icon: const Icon(Icons.add),
                      iconSize: 18,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
