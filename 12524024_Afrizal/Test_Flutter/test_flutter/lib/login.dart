import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  bool isLoggedIn = false; // <-- status login

  String registeredUsername = "aaa";
  String registeredPassword = "aaa";

  void doLogin() {
    String user = usernameC.text.trim();
    String pass = passwordC.text.trim();

    if (user == registeredUsername && pass == registeredPassword) {
      // LOGIN BERHASIL
      setState(() {
        isLoggedIn = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login berhasil!"),
          backgroundColor: Colors.green,
        ),
      );

    } else {
      // LOGIN GAGAL
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username atau Password salah!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void doLogout() {
    setState(() {
      isLoggedIn = false;
      usernameC.clear();
      passwordC.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berhasil logout"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2FF),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: isLoggedIn == false
                  ? buildLoginForm()
                  : buildWelcomeScreen(),
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // WIDGET FORM LOGIN
  // ======================================================
  Widget buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3A3D98),
          ),
        ),
        const SizedBox(height: 40),

        // Username
        TextFormField(
          controller: usernameC,
          decoration: InputDecoration(
            labelText: "Username",
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Password
        TextFormField(
          controller: passwordC,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(Icons.lock),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Tombol Login
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A3D98),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: doLogin,
            child: const Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ======================================================
  // WIDGET HALAMAN SETELAH LOGIN
  // ======================================================
  Widget buildWelcomeScreen() {
    return Column(
      children: [
        Text(
          "Selamat datang, $registeredUsername!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),

        const Icon(Icons.emoji_emotions, size: 100, color: Colors.orange),

        const SizedBox(height: 30),

        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: doLogout,
            child: const Text(
              "LOGOUT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
