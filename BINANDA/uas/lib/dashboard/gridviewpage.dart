import 'package:flutter/material.dart';

class Gridviewpage extends StatefulWidget {
  const Gridviewpage({super.key});

  @override
  State<Gridviewpage> createState() => _GridviewpageState();
}

class _GridviewpageState extends State<Gridviewpage> {
  final List<IconData> iconDataList = const [
    Icons.home,
    Icons.settings,
    Icons.favorite,
    Icons.person,
    Icons.notifications,
    Icons.email,
    Icons.cloud,
    Icons.camera,
    Icons.phone,
    Icons.wifi,
    Icons.star,
    Icons.music_note,
    Icons.fastfood,
    Icons.directions_car,
    Icons.flight,
    Icons.sports_soccer,
    Icons.shopping_cart,
    Icons.book,
    Icons.palette,
    Icons.lightbulb,
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(10.0), // Padding di sekitar grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, 
          crossAxisSpacing: 10.0, 
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0, 
        ),
        itemCount: iconDataList.length,
        itemBuilder: (context, index) {
          return GridItemIcon(
            icon: iconDataList[index],
            color: Colors.blueAccent,
            size: 50.0,
          );
        },
      );
  }
}
class GridItemIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const GridItemIcon({
    super.key,
    required this.icon,
    this.color = Colors.teal,
    this.size = 60.0, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), 
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: size,
            ),
            const SizedBox(height: 8.0), 
            Text(
              icon.toString().split('.').last, 
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}