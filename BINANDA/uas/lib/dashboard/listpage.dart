import 'package:flutter/material.dart';

class Listpage extends StatefulWidget {
  const Listpage({super.key});
  

  @override
  State<Listpage> createState() => _ListpageState();
}

class _ListpageState extends State<Listpage> {
  final List<IconData> iconDataList = const [
    Icons.home,
    Icons.settings,
    Icons.favorite,
    Icons.person,
    Icons.notifications,
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: iconDataList.length,
        itemBuilder: (context, index) {
          return ListItemIcon(
            icon: iconDataList[index],
            color: Colors.black, 
            size: 40.0,
          );
        },
      );
  }
}

class ListItemIcon extends StatelessWidget {
  // Atribut yang wajib diterima (Required)
  final IconData icon;

  // Atribut opsional (diberi nilai default jika tidak diisi)
  final Color color;
  final double size;

  const ListItemIcon({
    super.key,
    required this.icon,
    this.color = Colors.black, // Default color
    this.size = 30.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: size,
          ),
          const SizedBox(width: 16.0),
          Text(
            'Icon: ${icon.toString().split('.').last}', 
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}