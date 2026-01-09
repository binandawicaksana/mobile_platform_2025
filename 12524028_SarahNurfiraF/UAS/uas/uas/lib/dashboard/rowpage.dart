import 'package:flutter/material.dart';

class Rowpage extends StatefulWidget {
  const Rowpage({super.key});

  @override
  State<Rowpage> createState() => _RowpageState();
}

class _RowpageState extends State<Rowpage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard, color: Color(0xFFB45F4B), size: 50),
            const SizedBox(width: 12),
            const Icon(Icons.dashboard, color: Color(0xFFB45F4B), size: 50),
            const SizedBox(width: 12),
            const Icon(Icons.dashboard, color: Color(0xFFB45F4B), size: 50),
          ],
        ),
      ),
    );
  }
}
