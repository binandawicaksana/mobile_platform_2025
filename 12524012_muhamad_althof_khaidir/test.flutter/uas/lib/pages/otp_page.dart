import 'package:flutter/material.dart';
import 'select_content_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  Widget _otpBox(TextEditingController controller) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                // ===========================
                // JUDUL
                // ===========================
                const Text(
                  "Masukan Kode OTP",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 80),

                // ===========================
                // CARD OTP (2 CONTAINER)
                // ===========================
                Stack(
                  children: [
                    // ===== CONTAINER LUAR (ABU-ABU)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    // ===== CONTAINER DALAM (PUTIH)
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      padding: const EdgeInsets.all(20),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Masukan Kode",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 65),

                          // ===========================
                          // OTP BOX
                          // ===========================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: otpControllers
                                .map((c) => _otpBox(c))
                                .toList(),
                          ),

                          const SizedBox(height: 20),

                          Center(
                            child: GestureDetector(
                              onTap: () {
                                // dummy resend
                              },
                              child: const Text(
                                "kirim ulang?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 180),

                          // ===========================
                          // BUTTON VERIFIKASI
                          // ===========================
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectContentPage(),
                                  ),
                                );
                              },
                              child: const Text("Kirim Kode OTP"),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
