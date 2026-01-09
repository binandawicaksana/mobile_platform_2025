import 'package:flutter/material.dart';
import 'notif.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE58888), // Matches the salmon/reddish background
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.undo, color: Colors.black),
                    ),
                  ),
                  // Toggle Switch
                  Container(
                    width: 120, // Approximate width
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD80000), // Darker red for inactive part
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Icon(
                              Icons.nightlight_round,
                              color: Colors.black.withOpacity(0.5),
                              size: 24,
                            ),
                          ),
                        ),
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Info Button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA83232), // Dark red
                      borderRadius: BorderRadius.circular(16), // Rounded square
                    ),
                    child: const Center(
                      child: Text(
                        'i',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Serif', // Looks like a serif 'i'
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            const Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 50),
            // Scanner Box
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  children: [
                    // Corners
                    // Top Left
                    Positioned(
                      left: 0,
                      top: 0,
                      child: _buildCorner(isTop: true, isLeft: true),
                    ),
                    // Top Right
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _buildCorner(isTop: true, isLeft: false),
                    ),
                    // Bottom Left
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: _buildCorner(isTop: false, isLeft: true),
                    ),
                    // Bottom Right
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: _buildCorner(isTop: false, isLeft: false),
                    ),
                    
                    // Internal QR Pattern Simulation (Simplified)
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.white.withOpacity(0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildQrSquare(),
                                _buildQrSquare(),
                              ],
                            ),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildQrSquare(),
                                _buildQrSquare(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Scanning Line
                    Center(
                      child: Container(
                        height: 2,
                        width: 300,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC71585), // Pinkish red line
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFC71585).withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment completion
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotifScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Pembayaran Selesai',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: isTop ? const BorderSide(color: Colors.white70, width: 8) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Colors.white70, width: 8) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Colors.white70, width: 8) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Colors.white70, width: 8) : BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildQrSquare() {
      return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54, width: 4),
          ),
          child: Center(
              child: Container(
                  width: 20,
                  height: 20,
                  color: Colors.white54,
              ),
          ),
      );
  }
}
