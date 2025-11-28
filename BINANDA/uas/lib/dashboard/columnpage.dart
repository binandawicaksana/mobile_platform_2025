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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.dashboard, color: Colors.black, size: 50,),
                Icon(Icons.dashboard, color: Colors.black, size: 50,),
                Icon(Icons.dashboard, color: Colors.black, size: 50,),
              ],
            ),
          )
    );
  }
}