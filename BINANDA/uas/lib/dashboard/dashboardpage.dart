import 'package:flutter/material.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(10),
          // child:Text("Ini Halaman Dashboard"),
          child: Column(
            children: [
              Text("Ini Halaman Dashboard"),
              Image.asset('assets/images/logo.png', fit: BoxFit.fitWidth),
              CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/logo.png',
                ), // Ganti dengan path gambar Anda
                radius: 30,
              ),
            ],
          ),
    );
  }
}