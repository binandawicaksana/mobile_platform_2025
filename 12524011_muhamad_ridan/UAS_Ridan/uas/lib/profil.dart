import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background gradient seperti desain
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6FFF2), Color(0xFFE7FFF5)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // back + menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // profile header
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: Offset(0,4))
                            ],
                          ),
                          child: const Center(
                            child: Text('R', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 4)],
                            ),
                            child: const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Ridan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8),
                          _StatsRow()
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBFF2A8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text('Kirim Pesan', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        child: const Text('Mengikuti', style: TextStyle(color: Colors.black54)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // grid preview
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: List.generate(4, (i) => i).map((index) {
                      final gradients = [
                        const LinearGradient(colors: [Color(0xFFB85C5C), Color(0xFF8C3E3E)]),
                        const LinearGradient(colors: [Color(0xFFFFD6A5), Color(0xFFBFE7FF)]),
                        const LinearGradient(colors: [Color(0xFFB08BFF), Color(0xFF2BD1FF)]),
                        const LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFF00C2FF)]),
                      ];
                      return Container(
                        decoration: BoxDecoration(
                          gradient: gradients[index % gradients.length],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: Offset(0,4))],
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    Widget stat(String value, String label) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      );
    }

    return Row(
      children: [
        stat('1,532', 'Postingan'),
        stat('4,310', 'Pengikut'),
        stat('1,310', 'Mengikuti'),
      ],
    );
  }
}
