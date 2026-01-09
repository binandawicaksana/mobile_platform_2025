import 'package:flutter/material.dart';

class LiveTVPage extends StatefulWidget {
  const LiveTVPage({super.key});
  @override
  State<LiveTVPage> createState() => _LiveTVPageState();
}
class _LiveTVPageState extends State<LiveTVPage> {
  int selectedDayIndex = 0; // 0 = Kamis

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1024),

      body: SafeArea(
        child: Column(
          children: [
            // ===========================
            // 🎥 HEADER VIDEO (IMAGE)
            // ===========================
            Stack(
              children: [
                Image.asset(
                  "assets/images/rmtv.png",
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.contain,
                ),

                // Overlay controls (fake)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // ===========================
            // 🔵 TITLE BAR
            // ===========================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xff003b7a),
              child: const Text(
                "RMTV INTERNATIONAL",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ===========================
            // 🕒 CURRENT TIME
            // ===========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      "04:30",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Liga 25/26 : Levante VS Real Madrid",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            // ===========================
            // 📢 IKLAN
            // ===========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  "assets/images/iklan.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),
            // ===========================
            // 📅 TAB HARI
            // ===========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xff1a1b3a),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DayChip(
                      "Kamis",
                      active: selectedDayIndex == 0,
                      onTap: () {
                        setState(() {
                          selectedDayIndex = 0;
                        });
                      },
                    ),
                    _DayChip(
                      "Jum'at",
                      active: selectedDayIndex == 1,
                      onTap: () {
                        setState(() {
                          selectedDayIndex = 1;
                        });
                      },
                    ),
                    _DayChip(
                      "Sabtu",
                      active: selectedDayIndex == 2,
                      onTap: () {
                        setState(() {
                          selectedDayIndex = 2;
                        });
                      },
                    ),
                    _DayChip(
                      "Minggu",
                      active: selectedDayIndex == 3,
                      onTap: () {
                        setState(() {
                          selectedDayIndex = 3;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            // ===========================
            // 📋 LIST JADWAL
            // ===========================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  _ScheduleItem(),
                  _ScheduleItem(),
                  _ScheduleItem(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// =================================================
// 📅 DAY CHIP
// =================================================
class _DayChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _DayChip(this.label, {required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xff5c7cff) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// =================================================
// 🕒 SCHEDULE ITEM
// =================================================
class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        children: const [
          SizedBox(
            width: 60,
            child: Text(
              "04:30",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Liga 25/26 : Levante VS Real Madrid",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
