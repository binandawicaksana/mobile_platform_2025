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
            Icon(Icons.dashboard, color: Colors.black, size: 50),
            Icon(Icons.dashboard, color: Colors.black, size: 50),
            Icon(Icons.dashboard, color: Colors.black, size: 50),
          ],
        ),
      ),
    );
  }
}
