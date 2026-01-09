import 'package:flutter/material.dart';

class Columnpage extends StatefulWidget {
  const Columnpage({super.key});

  @override
  State<Columnpage> createState() => _ColumnpageState();
}

class _ColumnpageState extends State<Columnpage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF4E0C8), // krem/beige kayak gambar
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _MenuItem(icon: Icons.home_outlined, label: "Home"),
              _MenuItem(icon: Icons.local_fire_department_outlined, label: "Terlaris"),
              _MenuItem(icon: Icons.notifications_none, label: "Notifikasi"),
              _MenuItem(icon: Icons.person_outline, label: "Akun"),
            ],
          ),
        ),
      ),
    );
  }
}

// widget kecil biar rapi
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 30, color: Colors.black),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
