import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // biar kelihatan gradasi di body
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "🍪 Form Login Gemoy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFD9A679), // latte brown
        elevation: 0,
      ),

      body: Container(
        // background gradasi coklat gemes
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E8), // cream
              Color(0xFFF4E0C8), // beige
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFF3D3B3), // soft brown
                child: Text(
                  "🧸✨",
                  style: TextStyle(fontSize: 32),
                ),
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 320,
                  child: Card(
                    elevation: 10,
                    shadowColor: const Color(0xFFDEB79C).withOpacity(0.6),
                    color: const Color(0xFFFFFBF5), // putih krem
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 26,
                        horizontal: 22,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "✨ Login Yuk ✨",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB45F4B), // coffee brown
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // garis dekor cantik
                          Center(
                            child: Container(
                              width: 60,
                              height: 3,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE9C7A3),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          const Text(
                            "Username 🍪",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45F4B),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),

                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Masukkan Username… 🤎",
                              filled: true,
                              fillColor: const Color(0xFFFFF9F2),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 18,
                              ),
                              hintStyle: const TextStyle(
                                color: Colors.black38,
                                fontSize: 13.5,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE3C3A3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xFFC37A55),
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            "Password 🍫",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45F4B),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),

                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Masukkan Password… 🔐🍯",
                              filled: true,
                              fillColor: const Color(0xFFFFF9F2),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 18,
                              ),
                              hintStyle: const TextStyle(
                                color: Colors.black38,
                                fontSize: 13.5,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE3C3A3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xFFC37A55),
                                  width: 1.4,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                elevation: 3,
                                backgroundColor: Colors.transparent,
                                shadowColor: const Color(0xFFC46B4E),
                              ).copyWith(
                                // pakai dekorasi gradien lewat ButtonStyle
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "🧸✨ Login berhasil ditekan! 🤎",
                                    ),
                                  ),
                                );
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFC46B4E),
                                      Color(0xFFB25A40),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: const Center(
                                  child: Text(
                                    "LOGIN 🤎✨",
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
