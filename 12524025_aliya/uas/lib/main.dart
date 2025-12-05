import 'package:flutter/material.dart';
import 'package:uas/login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // memastikan binding siap
  configLoading(); // konfigurasi EasyLoading
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.blue.shade900
    ..textColor = Colors.blue.shade900
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..maskColor = Colors.black.withOpacity(0.3)
    ..userInteractions = true
    ..dismissOnTap = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyPresence UNBIN',
      builder: EasyLoading.init(), // wajib agar popup bisa muncul di seluruh halaman
      home: const LoginScreen(),
    );
  }
}
