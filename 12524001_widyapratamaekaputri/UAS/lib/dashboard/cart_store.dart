class CartItem {
  final String name;
  final String price; // formatted Rp
  final String imgUrl;
  final String eta;
  int qty;

  CartItem({
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.eta,
    this.qty = 1,
  });
}

class CartStore {
  static final List<CartItem> items = [
    CartItem(
      name: 'Gantungan Kunci\nKucing Lucu',
      price: 'Rp13.552',
      eta: '2-3 Hari',
      imgUrl:
          'https://down-id.img.susercontent.com/file/id-11134207-8224v-mh66huaryfwue1.webp',
      qty: 1,
    ),
    CartItem(
      name: 'Magnificent Life\nParfum Wanita',
      price: 'Rp124.552',
      eta: '2-3 Hari',
      imgUrl:
          'https://down-id.img.susercontent.com/file/id-11134207-7rbka-mazq9drf8s0pa5.webp',
      qty: 1,
    ),
  ];

  static void add(CartItem item) {
    // merge by name + price
    final idx = items.indexWhere((e) => e.name == item.name && e.price == item.price);
    if (idx >= 0) {
      items[idx].qty += item.qty;
    } else {
      items.add(item);
    }
  }

  static void clear() => items.clear();
}
