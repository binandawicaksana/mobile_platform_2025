import 'package:flutter/material.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'settings.dart';

// Runtime activity logs
final List<String> activityLogs = <String>[];

// Fallback logs when runtime is empty
const List<String> logs = <String>[
  'Welcome to Premium Inventory',
  'You added 3 new products',
  'Stock updated: Mug +5 pcs',
  'Removed: Old Backpack (discontinued)',
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  List<Product> products = [
    const Product(name: 'T-shirt', category: 'Apparel', stock: 12, status: 'In Stock'),
    const Product(name: 'Backpack', category: 'Bag', stock: 3, status: 'Running Low'),
    const Product(name: 'Desk Lamp', category: 'Electronics', stock: 5, status: 'In Stock'),
    const Product(name: 'Mug', category: 'Kitchen', stock: 0, status: 'Out of Stock'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardHomePage(
        products: products,
        onProductTap: (product) async {
          final result = await Navigator.push<Product>(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
          );
          if (result != null) {
            final idx = products.indexOf(product);
            if (idx != -1) {
              final old = products[idx];
              setState(() => products[idx] = result);
              if (old.stock != result.stock) {
                activityLogs.insert(0, 'Updated stock: ${result.name} to ${result.stock} pcs');
              }
            }
          }
        },
      ),
      const StockReportPage(),
      const ActivityLogPage(),
      const ProfilePage(),
    ];

    final titles = ['Premium Inventory', 'Reports', 'Activity Log', 'Profile'];

    return Scaffold(
      backgroundColor: const Color(0xFFFFE0ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE0ED),
        elevation: 0,
        centerTitle: true,
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF5B2B3A)),
        ),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF5B2B3A)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage())),
              tooltip: 'Chat',
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF5B2B3A)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
            tooltip: 'Pengaturan',
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF4F8C),
        unselectedItemColor: const Color(0xFFB889A1),
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class Product {
  final String name; final String category; final int stock; final String status;
  const Product({required this.name, required this.category, required this.stock, required this.status});
}

class DashboardHomePage extends StatelessWidget {
  final List<Product> products; final void Function(Product) onProductTap;
  const DashboardHomePage({super.key, required this.products, required this.onProductTap});
  @override
  Widget build(BuildContext context) {
    final totalStock = products.fold<int>(0, (s, p) => s + p.stock);
    final runningLow = products.where((p) => p.stock > 0 && p.stock < 5).length;
    const newArrivals = 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: SummaryCard(title: 'All My Cute Stocks', value: '$totalStock', emoji: '\u{1F496}', color: const Color(0xFFFFF0F6))),
          const SizedBox(width: 8),
          Expanded(child: SummaryCard(title: 'Oops! Running Low', value: '$runningLow', emoji: '\u26A0\uFE0F', color: const Color(0xFFFFF4E6))),
          const SizedBox(width: 8),
          Expanded(child: SummaryCard(title: 'New Arrivals', value: '$newArrivals', emoji: '\u2728', color: const Color(0xFFEFF7FF))),
        ]),
        const SizedBox(height: 24),
        const Text('Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5B2B3A))),
        const SizedBox(height: 8),
        ListView.separated(
          itemCount: products.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final p = products[index];
            return GestureDetector(
              onTap: () => onProductTap(p),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [
                  BoxShadow(color: Colors.pink.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6)),
                ]),
                child: Row(children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFFFE4EF), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.inventory_2_rounded, color: Color(0xFFFF5E8D))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF5B2B3A))),
                    const SizedBox(height: 2),
                    Text(p.category, style: const TextStyle(fontSize: 12, color: Color(0xFF9C6E86))),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${p.stock} pcs', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF5B2B3A))),
                    const SizedBox(height: 4),
                    StatusChip(status: p.status),
                  ]),
                ]),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title; final String value; final String emoji; final Color color;
  const SummaryCard({super.key, required this.title, required this.value, required this.emoji, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF5B2B3A))),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF9C6E86))),
      ]),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status; const StatusChip({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    late final Color bg; late final Color text;
    switch (status) {
      case 'In Stock': bg = const Color(0xFFE3FCE3); text = const Color(0xFF2C7A3F); break;
      case 'Running Low': bg = const Color(0xFFFFF4D8); text = const Color(0xFFB88900); break;
      case 'Out of Stock': bg = const Color(0xFFFFE1E2); text = const Color(0xFFB3261E); break;
      default: bg = const Color(0xFFEAE2FF); text = const Color(0xFF4B3F72);
    }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)), child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: text)));
  }
}

class ProductDetailPage extends StatefulWidget {
  final Product product; const ProductDetailPage({super.key, required this.product});
  @override State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late String _name; late String _category; late int _stock; late String _status;
  @override void initState() { super.initState(); _name = widget.product.name; _category = widget.product.category; _stock = widget.product.stock; _status = widget.product.status; }

  Widget _buildProductIcon() {
    final n = _name.toLowerCase(); const pink = Color(0xFFFF4F8C);
    if (n.contains('shirt') || n.contains('t-shirt') || n.contains('tshirt')) return _TShirtIcon(color: pink, size: 120);
    if (n.contains('backpack') || n.contains('bag')) return Icon(Icons.backpack_rounded, size: 110, color: pink);
    if (n.contains('lamp')) return Icon(Icons.lightbulb_rounded, size: 110, color: pink);
    if (n.contains('mug') || n.contains('cup')) return Icon(Icons.local_cafe_rounded, size: 110, color: pink);
    return const Icon(Icons.emoji_emotions_rounded, size: 80, color: Colors.white);
  }

  void _showEditSheet() {
    final primary = const Color(0xFFFF4F8C);
    final nameCtrl = TextEditingController(text: _name);
    final catCtrl = TextEditingController(text: _category);
    final statusCtrl = TextEditingController(text: _status);
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, top: 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.edit_rounded, color: Color(0xFFFF4F8C)), const SizedBox(width: 8), Text('Edit Product', style: TextStyle(fontWeight: FontWeight.w700, color: primary))]),
          const SizedBox(height: 12),
          _pinkTextField(controller: nameCtrl, label: 'Name'),
          const SizedBox(height: 8),
          _pinkTextField(controller: catCtrl, label: 'Category'),
          const SizedBox(height: 8),
          _pinkTextField(controller: statusCtrl, label: 'Status'),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, height: 44, child: ElevatedButton(onPressed: () { setState(() { _name = nameCtrl.text.trim().isEmpty ? _name : nameCtrl.text.trim(); _category = catCtrl.text.trim().isEmpty ? _category : catCtrl.text.trim(); _status = statusCtrl.text.trim().isEmpty ? _status : statusCtrl.text.trim(); }); Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Perubahan tersimpan'), backgroundColor: primary, behavior: SnackBarBehavior.floating)); }, style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Simpan'))),
        ]),
      ),
    );
  }

  void _showUpdateStockSheet() {
    final primary = const Color(0xFFFF4F8C);
    final stockCtrl = TextEditingController(text: _stock.toString());
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, top: 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.inventory_2_rounded, color: Color(0xFFFF4F8C)), const SizedBox(width: 8), Text('Update Stock', style: TextStyle(fontWeight: FontWeight.w700, color: primary))]),
          const SizedBox(height: 12),
          Row(children: [
            _roundIconButton(icon: Icons.remove_rounded, onTap: () { final current = int.tryParse(stockCtrl.text) ?? _stock; final next = (current - 1).clamp(0, 9999); stockCtrl.text = next.toString(); }),
            const SizedBox(width: 8),
            Expanded(child: _pinkTextField(controller: stockCtrl, label: 'Stock', keyboardType: TextInputType.number)),
            const SizedBox(width: 8),
            _roundIconButton(icon: Icons.add_rounded, onTap: () { final current = int.tryParse(stockCtrl.text) ?? _stock; final next = (current + 1).clamp(0, 9999); stockCtrl.text = next.toString(); }),
          ]),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, height: 44, child: ElevatedButton(onPressed: () { final value = int.tryParse(stockCtrl.text); if (value == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan angka yang valid'), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating)); return; } setState(() => _stock = value); Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stock diperbarui: $_stock pcs'), backgroundColor: primary, behavior: SnackBarBehavior.floating)); }, style: ElevatedButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Simpan'))),
        ]),
      ),
    );
  }

  Widget _roundIconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(12),
      child: Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFFFF3F9), shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFFFF4F8C))),
    );
  }

  Widget _pinkTextField({required TextEditingController controller, required String label, TextInputType? keyboardType}) {
    return TextField(
      controller: controller, keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Color(0xFFFF4F8C)), filled: true, fillColor: const Color(0xFFFFF3F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: const Color(0xFFFF4F8C).withOpacity(0.25))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFFF4F8C), width: 1.5)),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF9C6E86), fontWeight: FontWeight.w600))),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF5B2B3A)))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFE0ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFE0ED), elevation: 0, centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF5B2B3A)), onPressed: () {
            final updated = Product(name: _name, category: _category, stock: _stock, status: _status); Navigator.pop(context, updated);
          }),
          title: const Text('Product Details', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF5B2B3A))),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFF5B2B3A)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
              tooltip: 'Pengaturan',
            ),
          ],
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(children: [
          Container(height: 160, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFFA4C6), Color(0xFFFFD1E3)], begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(26)), child: ClipRRect(borderRadius: BorderRadius.circular(26), child: Center(child: _buildProductIcon()))),
          const SizedBox(height: 18),
          Text(_name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF5B2B3A))),
          const SizedBox(height: 4),
          const Text('Cute T-Shirt', style: TextStyle(fontSize: 13, color: Color(0xFF9C6E86))),
          const SizedBox(height: 24),
          _detailRow('Category', _category),
          _detailRow('Stock', '$_stock pcs'),
          _detailRow('Price', '\$20.00'),
          _detailRow('Status', _status),
          const SizedBox(height: 16),
          _detailRow('Description', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, height: 46, child: ElevatedButton(onPressed: _showEditSheet, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4F8C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))), child: const Text('Edit'))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, height: 46, child: ElevatedButton(onPressed: _showUpdateStockSheet, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4F8C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))), child: const Text('Update Stock'))),
        ]),
      ),
    );
  }
}

class ChatMessage {
  final String text; final String time; final bool isMe;
  ChatMessage({required this.text, required this.time, required this.isMe});
}

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});
  @override
  Widget build(BuildContext context) {
    final source = activityLogs.isNotEmpty ? activityLogs : logs;
    return Container(color: const Color(0xFFFFE0ED), child: Column(children: [
      const SizedBox(height: 8),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
        _FilterChipLabel('All', isActive: true), _FilterChipLabel('Added'), _FilterChipLabel('Updated'), _FilterChipLabel('Removed'),
      ]))),
      const SizedBox(height: 16),
      Expanded(child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), itemCount: source.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (context, i) {
        final log = source[i];
        return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(children: [
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFFFFE4EF), child: Icon(Icons.history, color: Color(0xFFFF4F8C), size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(log, style: const TextStyle(fontSize: 13, color: Color(0xFF5B2B3A)))),
          const SizedBox(width: 8),
          const Text('2h ago', style: TextStyle(fontSize: 10, color: Color(0xFF9C6E86))),
        ]));
      }))
    ]));
  }
}

class _FilterChipLabel extends StatelessWidget {
  final String text; final bool isActive; const _FilterChipLabel(this.text, {this.isActive = false});
  @override Widget build(BuildContext context) { return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: isActive ? const Color(0xFFFF4F8C) : Colors.transparent, borderRadius: BorderRadius.circular(999)), child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? Colors.white : const Color(0xFF9C6E86)))); }
}

class _TShirtIcon extends StatelessWidget {
  final Color color; final double size; const _TShirtIcon({required this.color, this.size = 96});
  @override Widget build(BuildContext context) => Semantics(label: 'T-shirt icon', child: CustomPaint(size: Size(size, size), painter: _TShirtPainter(color)));
}

class _TShirtPainter extends CustomPainter {
  final Color color; _TShirtPainter(this.color);
  @override void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final body = Path()..moveTo(w * 0.35, h * 0.15)..lineTo(w * 0.25, h * 0.18)
      ..quadraticBezierTo(w * 0.15, h * 0.22, w * 0.18, h * 0.35)
      ..quadraticBezierTo(w * 0.22, h * 0.38, w * 0.28, h * 0.40)
      ..lineTo(w * 0.28, h * 0.85)
      ..quadraticBezierTo(w * 0.50, h * 0.95, w * 0.72, h * 0.85)
      ..lineTo(w * 0.72, h * 0.40)
      ..quadraticBezierTo(w * 0.78, h * 0.38, w * 0.82, h * 0.35)
      ..quadraticBezierTo(w * 0.85, h * 0.22, w * 0.75, h * 0.18)
      ..lineTo(w * 0.65, h * 0.15)
      ..quadraticBezierTo(w * 0.50, h * 0.22, w * 0.35, h * 0.15)
      ..close();
    canvas.drawPath(body, fill);
    final collar = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.50, h * 0.20), h * 0.07, collar);
  }
  @override bool shouldRepaint(covariant _TShirtPainter oldDelegate) => oldDelegate.color != color;
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFFBBD3), Color(0xFFFFE7EF)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Column(children: [
        const SizedBox(height: 24),
        const CircleAvatar(radius: 45, backgroundImage: AssetImage('assets/profile_placeholder.png')),
        const SizedBox(height: 12),
        const Text('Araa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF5B2B3A))),
        const SizedBox(height: 4),
        const Text('araa@example.com', style: TextStyle(fontSize: 13, color: Color(0xFF9C6E86))),
        const SizedBox(height: 4),
        const Text('Admin', style: TextStyle(fontSize: 12, color: Color(0xFF9C6E86))),
        const SizedBox(height: 20),
        const ProfileActionButton(text: 'Edit Profile'),
        const ProfileActionButton(text: 'Change Email'),
        const ProfileActionButton(text: 'Change Password'),
        const ProfileActionButton(text: 'Log Out'),
      ]),
    );
  }
}

class ProfileActionButton extends StatelessWidget {
  final String text; const ProfileActionButton({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
      child: SizedBox(width: double.infinity, height: 44, child: ElevatedButton(
        onPressed: () async {
          if (text == 'Log Out') {
            final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Confirm Log Out'), content: const Text('Are you sure you want to log out?'), actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
            ]));
            if (confirmed == true) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
            }
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text tapped'), behavior: SnackBarBehavior.floating, backgroundColor: const Color(0xFFFF4F8C)));
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF5B2B3A), elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22))),
        child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      )),
    );
  }
}

class StockReportPage extends StatelessWidget {
  const StockReportPage({super.key});
  @override Widget build(BuildContext context) {
    return Container(color: const Color(0xFFFFE0ED), child: Column(children: [
      const SizedBox(height: 16),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Container(height: 180, decoration: BoxDecoration(color: const Color(0xFFFFC8E0), borderRadius: BorderRadius.circular(20)), child: CustomPaint(painter: _LineChartPainter(), child: const SizedBox.expand()))),
      const SizedBox(height: 24),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: const [
        Expanded(child: ReportInfoCard(title: 'Total Stock', value: '120')), SizedBox(width: 8), Expanded(child: ReportInfoCard(title: 'Sold', value: '38')), SizedBox(width: 8), Expanded(child: ReportInfoCard(title: 'In Stock', value: '82')),
      ])),
    ]));
  }
}

class ReportInfoCard extends StatefulWidget {
    final String title; final String value; const ReportInfoCard({super.key, required this.title, required this.value});
    @override
    State<ReportInfoCard> createState() => _ReportInfoCardState();
}

class _ReportInfoCardState extends State<ReportInfoCard> {
  bool _pressed = false;

  List<Color> _bgFor(String title) {
    switch (title) {
      case 'Sold':
        return const [Color(0xFFFFF4E6), Colors.white];
      case 'In Stock':
        return const [Color(0xFFEFF7FF), Colors.white];
      default:
        return const [Color(0xFFFFF0F6), Colors.white];
    }
  }

  IconData _iconFor(String title) {
    switch (title) {
      case 'Sold':
        return Icons.trending_up_rounded;
      case 'In Stock':
        return Icons.check_circle_outline;
      default:
        return Icons.inventory_2_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgFor(widget.title);
    final icon = _iconFor(widget.title);
    final shadow = _pressed ? 4.0 : 12.0;
    return Tooltip(
      message: 'Tap untuk detail, tahan untuk salin',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onHighlightChanged: (v) => setState(() => _pressed = v),
          onTap: () {
            HapticFeedback.selectionClick();
            _showInfo(context, widget.title, widget.value);
          },
          onLongPress: () async {
            HapticFeedback.lightImpact();
            await Clipboard.setData(ClipboardData(text: widget.value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.title}: ${widget.value} disalin')),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: bg,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.18),
                  blurRadius: shadow,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 120),
              scale: _pressed ? 0.98 : 1.0,
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8AB5), Color(0xFFFF4F8C)],
                      ),
                    ),
                    child: Icon(icon, size: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5B2B3A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF9C6E86)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

  void _showInfo(BuildContext context, String title, String value) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF5B2B3A))),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF5B2B3A)),
                ),
                const SizedBox(height: 12),
                Text(
                  _explain(title),
                  style: const TextStyle(color: Color(0xFF8A5640)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: '$title: $value'));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Nilai disalin')),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded),
                      label: const Text('Salin'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _explain(String title) {
    switch (title) {
      case 'Total Stock':
        return 'Jumlah total stok barang Anda saat ini.';
      case 'Sold':
        return 'Estimasi barang terjual pada periode terkini.';
      case 'In Stock':
        return 'Jumlah barang yang tersedia untuk dijual.';
      default:
        return 'Informasi metrik.';
    }
  }

class _LineChartPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = Colors.white.withOpacity(0.25)..strokeWidth = 1..style = PaintingStyle.stroke;
    for (var i = 1; i <= 4; i++) { final y = size.height * (i / 5); canvas.drawLine(Offset(0, y), Offset(size.width, y), grid); }
    for (var i = 1; i <= 6; i++) { final x = size.width * (i / 7); canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid); }
    final values = <double>[0.70, 0.55, 0.60, 0.40, 0.45, 0.30];
    final points = List.generate(values.length, (i) => Offset(size.width * (i / (values.length - 1)), size.height * values[i]));
    final line = Paint()..color = Colors.white..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) { final p0 = points[i], p1 = points[i + 1]; final c = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2); path.quadraticBezierTo(p0.dx, p0.dy, c.dx, c.dy); path.quadraticBezierTo(c.dx, c.dy, p1.dx, p1.dy); }
    final area = Path.from(path)..lineTo(points.last.dx, size.height)..lineTo(points.first.dx, size.height)..close();
    final shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white70, Colors.white24, Colors.transparent], stops: [0, .5, 1]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final fill = Paint()..shader = shader..style = PaintingStyle.fill; canvas.drawPath(area, fill); canvas.drawPath(path, line);
    final dot = Paint()..color = Colors.white; for (final p in points) { canvas.drawCircle(p, 3.5, dot); }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    final messages = [
      ChatMessage(text: 'Hi, any update for cute mug restock?', isMe: true, time: '09:20 AM'),
      ChatMessage(text: 'Yes! New batch will arrive tomorrow \u2728', isMe: false, time: '09:22 AM'),
      ChatMessage(text: 'Yay, thank you so much!', isMe: true, time: '09:23 AM'),
    ];
      return Scaffold(
        backgroundColor: const Color(0xFFFFE0ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFE0ED),
          elevation: 0,
          title: const Text(
            'Chat with Supplier',
            style: TextStyle(color: Color(0xFF5B2B3A), fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFF5B2B3A)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
              tooltip: 'Pengaturan',
            ),
          ],
        ),
      body: Column(children: [
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), itemCount: messages.length, itemBuilder: (context, i) { final m = messages[i]; return Align(alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.symmetric(vertical: 6), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: m.isMe ? const Color(0xFFFF8AB5) : Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: m.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [ Text(m.text, style: TextStyle(color: m.isMe ? Colors.white : const Color(0xFF5B2B3A))), const SizedBox(height: 4), Text(m.time, style: TextStyle(fontSize: 10, color: m.isMe ? Colors.white70 : const Color(0xFF9C6E86))), ]))); })),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), color: Colors.white, child: Row(children: const [ Icon(Icons.emoji_emotions_outlined, color: Color(0xFFB889A1)), SizedBox(width: 8), Icon(Icons.image_outlined, color: Color(0xFFB889A1)), SizedBox(width: 8), Expanded(child: TextField(decoration: InputDecoration(hintText: 'Message...', hintStyle: TextStyle(fontSize: 13, color: Color(0xFFB889A1)), border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(22)), borderSide: BorderSide.none), filled: true, fillColor: Color(0xFFFFF3F9), contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10)))), SizedBox(width: 8), SizedBox(width: 40, height: 40, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFFF4F8C), shape: BoxShape.circle), child: Icon(Icons.send_rounded, color: Colors.white, size: 20))), ])),
      ]),
    );
  }
}
