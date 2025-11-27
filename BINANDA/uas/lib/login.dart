import 'package:flutter/material.dart';
import 'package:uas/dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
    // Memberikan latar belakang gradien yang lembut untuk tampilan yang lebih indah
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF2C3E50), // Navy Blue gelap
          Color(0xFF4CA1AF), // Teal/Biru muda
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 🌟 Judul
            const Text(
              'SELAMAT DATANG',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700), // Warna Emas
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black45,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 📇 Form Container (menggunakan Card untuk efek elevasi)
            Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: <Widget>[
                    // 📝 TextFormField Username
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Masukkan Username Anda',
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF2C3E50)), // Icon Navy
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF2C3E50)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2), // Border Emas
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔒 TextFormField Password
                    TextFormField(
                      obscureText: true, // Untuk menyembunyikan input password
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Masukkan Password Anda',
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF2C3E50)), // Icon Navy
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF2C3E50)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2), // Border Emas
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 🚀 Button Login
                    SizedBox(
                      width: double.infinity, // Membuat tombol selebar container
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika ketika tombol Login ditekan
                          print('Tombol Login ditekan!');
                          // TODO: Tambahkan navigasi atau validasi form di sini
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700), // Latar belakang Emas
                          foregroundColor: const Color(0xFF2C3E50), // Teks Navy
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 8,
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}