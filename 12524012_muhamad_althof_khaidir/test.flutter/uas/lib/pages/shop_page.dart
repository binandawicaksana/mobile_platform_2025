import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===========================
      // 🔵 APP BAR
      // ===========================
      appBar: AppBar(
        backgroundColor: const Color(0xff003b7a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Belanja",
          style: TextStyle(color: Colors.white),
        ),
      ),

      // ===========================
      // 🧱 BODY
      // ===========================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===========================
              // 🏪 OFFICIAL STORE
              // ===========================
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade200,
                    child: Image.asset(
                      "assets/images/Logo_RM.png",
                      width: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Official",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        "Store",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 14),
                  Stack(
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ===========================
              // 🔍 SEARCH BAR
              // ===========================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===========================
              // 🖼️ ETALASE / IKLAN
              // ===========================
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/etalase.png",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              // ===========================
              // 🛍️ PRODUK TITLE
              // ===========================
              const Text(
                "Produk",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // ===========================
              // 🧥 PRODUK HORIZONTAL (FIX)
              // ===========================
              SizedBox(
                height: 180, // 🔑 WAJIB agar tidak overflow
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final products = [
                      {
                        "image": "assets/images/jaket1.png",
                        "name": "Real Madrid UBP Track Top",
                        "price": "960.000 IDR",
                      },
                      {
                        "image": "assets/images/jaket2.png",
                        "name": "Jersey Real Madrid",
                        "price": "1.600.000 IDR",
                      },
                      {
                        "image": "assets/images/jaket1.png",
                        "name": "Training Jacket Madrid",
                        "price": "1.200.000 IDR",
                      },
                    ];

                    return SizedBox(
                      width: 170,
                      child: _ProductCard(
                        image: products[index]["image"]!,
                        name: products[index]["name"]!,
                        price: products[index]["price"]!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================================================
// 🧥 PRODUCT CARD
// =================================================
class _ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;

  const _ProductCard({
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ IMAGE (HEIGHT DIKUNCI)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              image,
              height: 110,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          // 📦 CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NAMA PRODUK
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // HARGA + CART
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xffffb703),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

