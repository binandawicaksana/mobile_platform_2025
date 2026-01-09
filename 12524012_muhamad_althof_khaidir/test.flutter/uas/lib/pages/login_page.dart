import 'package:flutter/material.dart';
import '../pages/main_navigation.dart';
import '../widgets/custom_textfield.dart';
import '../pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // LOGO
                Image.asset('assets/images/Logo_socer.png', height: 130),

                const SizedBox(height: 20),

                // CARD FORM LOGIN
                Container(
                  width: 350,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Google login dummy
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo_google.png',
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text("Lanjutkan dengan Google"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("atau"),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text("Alamat Email"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "Masukkan email",
                        controller: emailController,
                      ),

                      const SizedBox(height: 15),

                      const Text("Password"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "Masukkan password",
                        obscure: true,
                        controller: passController,
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Lupa password?",
                          style: TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ TOMBOL MASUK (SUDAH BENAR)
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainNavigation(),
                              ),
                            );
                          },
                          child: const Text("Masuk"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text("Daftar"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Lewati Progres Login"),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_right_alt),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
