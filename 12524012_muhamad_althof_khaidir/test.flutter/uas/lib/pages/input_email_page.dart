import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import 'otp_page.dart';

class InputEmailPage extends StatefulWidget {
  const InputEmailPage({super.key});

  @override
  State<InputEmailPage> createState() => _InputEmailPageState();
}

class _InputEmailPageState extends State<InputEmailPage> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),

              // ===========================
              // JUDUL ATAS (AGAK KE ATAS)
              // ===========================
              const Text(
                "Masukan email",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 100),

              // ===========================
              // STACK 2 CONTAINER
              // ===========================
              Stack(
                children: [
                  // ===== CONTAINER LUAR (ABU-ABU)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 460, // ⬅️ PENTING: tinggi memanjang
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  // ===== CONTAINER DALAM (PUTIH)
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    padding: const EdgeInsets.all(20),
                    height: 460, // ⬅️ SAMA TINGGINYA
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // ===========================
                        // TEKS DALAM CARD
                        // ===========================
                        const Text(
                          "Masukan email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 50), // ⬅️ JARAK JAUH

                        const Text("Alamat Email"),
                        const SizedBox(height: 10),

                        CustomTextField(
                          hint: "Alamat Email",
                          controller: emailController,
                        ),

                        const SizedBox(height: 150), // ⬅️ JARAK KE BUTTON

                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OtpPage(),
                                ),
                              );
                            },
                            child: const Text("Minta Kode OTP"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
