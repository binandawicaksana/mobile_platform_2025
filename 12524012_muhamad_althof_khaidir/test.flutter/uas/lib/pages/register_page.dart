import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import 'input_email_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final tanggalController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Text(
                  "Isi Data Diri anda",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

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
                        "Informasi Diri",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Informasi harus sesuai!",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text("Alamat Email"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "Alamat Email",
                        controller: emailController,
                      ),

                      const SizedBox(height: 15),

                      const Text("Password"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "Password",
                        obscure: true,
                        controller: passwordController,
                      ),

                      const SizedBox(height: 15),

                      const Text("Tanggal Lahir"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "Tanggal Lahir",
                        controller: tanggalController,
                      ),

                      const SizedBox(height: 15),

                      const Text("No HP"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "No HP",
                        controller: phoneController,
                      ),

                      const SizedBox(height: 15),

                      const Text("Jenis Kelamin"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "Jenis Kelamin",
                        controller: genderController,
                      ),

                      const SizedBox(height: 15),

                      const Text("Kota"),
                      const SizedBox(height: 5),
                      CustomTextField(
                        hint: "Kota",
                        controller: cityController,
                      ),

                      const SizedBox(height: 20),

                      // ===========================
                      // TOMBOL LANJUT → INPUT EMAIL
                      // ===========================
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const InputEmailPage(),
                              ),
                            );
                          },
                          child: const Text("Lanjut"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ===========================
                      // KEMBALI KE LOGIN
                      // ===========================
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Kembali ke Login"),
                        ),
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