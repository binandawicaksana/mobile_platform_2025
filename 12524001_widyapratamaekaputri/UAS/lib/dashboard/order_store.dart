class OrderItem {
  final String name;
  final String price;
  final String eta;
  final String imgUrl;
  final int qty;
  final int shipping;
  final String paymentMethod;

  OrderItem({
    required this.name,
    required this.price,
    required this.eta,
    required this.imgUrl,
    required this.qty,
    required this.shipping,
    required this.paymentMethod,
  });
}

// global store (simple)
class OrderStore {
  static final List<OrderItem> dikemas = [];
  static final List<OrderItem> diproses = [];
  static final List<OrderItem> dikirim = [];
  static final List<OrderItem> selesai = [];
}
