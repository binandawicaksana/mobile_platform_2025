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
      backgroundColor: const Color(0xFFFFF5FA), 
      appBar: AppBar(
        title: const Text(
          "🍓 Form Login Gemoy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC6E0),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            const CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFFFD7EB),
              child: Text(
                "🐰✨",
                style: TextStyle(fontSize: 32),
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ Card BENERAN kecil
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 300, // ⬅️ ukuran card (bisa diganti 250, 280, dll)
                child: Card(
                  elevation: 6,
                  shadowColor: Colors.pink.shade100,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Center(
                          child: Text(
                            "✨ Login Yuk ✨",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Username 🧁",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD81B60),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),

                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Masukkan Username… 💕",
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                            hintStyle: const TextStyle(color: Colors.black38),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFFFFB6D5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFFE91E63)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          "Password 🍬",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD81B60),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),

                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Masukkan Password… 🔐✨",
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                            hintStyle: const TextStyle(color: Colors.black38),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFFFFB6D5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFFE91E63)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E63),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () {
                              // 🔥 LOGIKA MASIH SAMA
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("🐰✨ Login berhasil ditekan! 🎀"),
                                ),
                              );
                            },
                            child: const Text(
                              "LOGIN 💞",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
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
    );
  }
}