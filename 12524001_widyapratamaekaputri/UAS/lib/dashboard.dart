import 'package:flutter/material.dart';
import 'dashboard/pulsadatapage.dart';
import 'dashboard/shoppaypage.dart';
import 'dashboard/keranjangpage.dart';
import 'dashboard/detailbarang.dart';
import 'dashboard/akun.dart';
import 'dashboard/cart_store.dart';
import 'dashboard/qris_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final searchC = TextEditingController();

  final products = const [
    {
      "name": "Gantungan Kunci\nKucing Lucu",
      "price": "Rp13.552",
      "sold": "10rb+ Terjual",
      "eta": "2-3 Hari",
      "img":
          "https://down-id.img.susercontent.com/file/id-11134207-8224v-mh66huaryfwue1.webp",
    },
    {
      "name": "Boneka Beruang We\nBare Bears Panda",
      "price": "Rp87.768",
      "sold": "10rb+ Terjual",
      "eta": "2-3 Hari",
      "img":
          "https://down-id.img.susercontent.com/file/12aa430c74514f137967e5f26774b5d4.webp",
    },
    {
      "name": "Magnificent Life\nParfum Wanita",
      "price": "Rp124.552",
      "sold": "10rb+ Terjual",
      "eta": "2-3 Hari",
      "img":
          "https://down-id.img.susercontent.com/file/id-11134207-7rbka-mazq9drf8s0pa5.webp",
    },
    {
      "name": "Tumbler Bottle\nStainless Steel 800ML",
      "price": "Rp129.908",
      "sold": "10rb+ Terjual",
      "eta": "2-3 Hari",
      "img":
          "https://down-id.img.susercontent.com/file/id-11134207-82250-mgdxk3uoygi17d.webp",
    },
  ];

  late List<Map<String, Object?>> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = List<Map<String, Object?>>.from(products);
  }

  @override
  Widget build(BuildContext context) {
    final cartQty = CartStore.items.fold<int>(0, (sum, it) => sum + it.qty);
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E8),
      body: SafeArea(
        child: Column(
          children: [
            // ===================== TOP SEARCH BAR =====================
            Container(
              color: const Color(0xFFD9A679),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchC,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: "Cari produk...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchC.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchC.clear();
                                  _onSearch('');
                                },
                              )
                            : const Icon(Icons.mic_none),
                        filled: true,
                        fillColor: const Color(0xFFBFA07A),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KeranjangPage(),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 26),
                        if (cartQty > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                cartQty > 99 ? '99+' : '$cartQty',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AkunPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.person_outline, size: 26),
                  ),
                ],
              ),
            ),

            // ===================== MENU BULAT =====================
            Container(
              color: const Color(0xFFF4E0C8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _CircleMenu(
                    icon: Icons.qr_code_2_outlined,
                    label: "Qris",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QrisPage()),
                      ).then((_) => setState(() {}));
                    },
                  ),
                  _CircleMenu(
                    icon: Icons.phone_android_outlined,
                    label: "Pulsa & Data",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PulsaDataPage(),
                        ),
                      );
                    },
                  ),
                  _CircleMenu(
                    icon: Icons.account_balance_wallet_outlined,
                    label: "ShopPay",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShopPayPage(),
                        ),
                      );
                    },
                  ),
                  _CircleMenu(
                    icon: Icons.grid_view_outlined,
                    label: "Semua Kategori",
                    onTap: () => _openCategoryMenu(context),
                  ),
                ],
              ),
            ),

            // (Section 'Jelajah Layanan' dihapus sesuai permintaan)

            // ===================== GRID PRODUK =====================
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('Tidak ada hasil'))
                  : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _filtered.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.66,
                ),
                itemBuilder: (_, i) {
                  final p = _filtered[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailBarangPage(
                            name: p["name"] as String,
                            price: p["price"] as String,
                            sold: p["sold"] as String,
                            eta: p["eta"] as String,
                            imgUrl: p["img"] as String,
                          ),
                        ),
                      );
                    },
                    child: _ProductCard(
                      name: p["name"] as String,
                      price: p["price"] as String,
                      sold: p["sold"] as String,
                      eta: p["eta"] as String,
                      imgUrl: p["img"] as String,
                      onAddToCart: () => setState(() {}),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }
}

void _noop() {}

extension _Search on _DashboardState {
  void _onSearch(String q) {
    final query = q.trim();
    if (query.isEmpty) {
      setState(() => _filtered = List<Map<String, Object?>>.from(products));
      return;
    }
    final res = products.where((p) {
      final name = (p['name'] as String).toLowerCase();
      final price = (p['price'] as String).toLowerCase();
      return name.contains(query.toLowerCase()) || price.contains(query.toLowerCase());
    }).toList();
    setState(() => _filtered = res);
  }
}

extension _Burger on _DashboardState {
  void _openCategoryMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: const Color(0xFFFFFBF5),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: const Text('Produk'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_2),
                title: const Text('QRIS'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const QrisPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_android_outlined),
                title: const Text('Pulsa & Data'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PulsaDataPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const Text('ShopPay'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPayPage()));
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}


// ===================== MENU BULAT =====================
class _CircleMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CircleMenu({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBF5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

// ===================== CARD PRODUK =====================
class _ProductCard extends StatelessWidget {
  final String name, price, sold, eta, imgUrl;
  final VoidCallback? onAddToCart;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.sold,
    required this.eta,
    required this.imgUrl,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF4E0C8),
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.black.withOpacity(0.35),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        CartStore.add(CartItem(
                          name: name,
                          price: price,
                          imgUrl: imgUrl,
                          eta: eta,
                          qty: 1,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ditambahkan ke keranjang')),
                        );
                        onAddToCart?.call();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
            child: Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.local_offer_outlined,
                  size: 14,
                  color: Colors.red,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
            child: Text(
              sold,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 14,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  eta,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _DescRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
