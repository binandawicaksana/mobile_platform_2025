import 'package:flutter/material.dart';

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  bool showPopup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1023),
      body: Stack(
        children: [
          _buildMainContent(context),

          // POPUP SUCCESS
          if (showPopup) _buildPopup(),
        ],
      ),
    );
  }

  // MAIN UI
  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.greenAccent),
            onPressed: () => Navigator.pop(context),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "Check your inbox",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          const Center(
            child: Text(
              "we have sent you a verification code by email",
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),

          const SizedBox(height: 25),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Ismail@gmail.com",
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.edit, size: 16, color: Colors.white70),
              ],
            ),
          ),

          const SizedBox(height: 35),

          // Dummy OTP Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: const Center(
                  child: Text(
                    '•••',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "Resend again",
              style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // BUTTON VERIFY EMAIL
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  showPopup = true; // Tampilkan popup
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: const BorderSide(color: Colors.greenAccent, width: 2),
              ),
              child: const Text(
                "Verif email",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const Spacer(),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Already have an account? ",
                    style: TextStyle(color: Colors.white60)),
                Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // POPUP UI
  Widget _buildPopup() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showPopup = false; // Klik layar → hilang
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.65), // background gelap

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ICON CHECK
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.redAccent,
                  size: 90,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Verification success",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
