import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int selectedMonth = 0;

  final List<String> months = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _startOffset(int year, int month) {
    final firstDay = DateTime(year, month + 1, 1).weekday;
    return firstDay % 7; // Sunday = 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b0f2f),
      appBar: AppBar(
        backgroundColor: const Color(0xff003b7a),
        title: const Text("Kalender", style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // ===========================
            // MONTH SELECTOR
            // ===========================
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final isActive = selectedMonth == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedMonth = index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            months[index],
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 3,
                            width: isActive ? 48 : 0,
                            decoration: BoxDecoration(
                              color: const Color(0xff8ea2ff),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ===========================
            // 🗓️ CALENDAR (DAY + DATE)
            // ===========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Builder(
                builder: (context) {
                  final year = DateTime.now().year;
                  final daysInMonth = _daysInMonth(year, selectedMonth);
                  final startOffset = _startOffset(year, selectedMonth);
                  final totalItem = startOffset + daysInMonth;

                  return Column(
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 7,
                        childAspectRatio: 1.2,
                        children: const [
                          _DayLabel("S"),
                          _DayLabel("M"),
                          _DayLabel("T"),
                          _DayLabel("W"),
                          _DayLabel("T"),
                          _DayLabel("F"),
                          _DayLabel("S"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: totalItem,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 0,
                            ),
                        itemBuilder: (context, index) {
                          if (index < startOffset) {
                            return const SizedBox();
                          }

                          final day = index - startOffset + 1;
                          final isSelected = day == 12;

                          return Center(
                            child: Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xff4da3ff),
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Text(
                                "$day",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ===========================
            // MATCH CARD
            // ===========================
            SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Container(
                    width: 260,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff141a3a),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        // ===========================
                        // JUDUL KECIL
                        // ===========================
                        const Text(
                          "Football · First Team",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "Sunday 3 Nov · 03:00",
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),

                        const SizedBox(height: 12),

                        // ===========================
                        // MATCH ROW
                        // ===========================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _teamColumn(
                              "assets/images/Logo_RM.png",
                              "Real Madrid",
                            ),

                            Column(
                              children: [
                                const Text(
                                  "4 - 0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Finished",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            _teamColumn(
                              "assets/images/Logo_Val.png",
                              "Valencia",
                            ),
                          ],
                        ),

                        const Spacer(),

                        // ===========================
                        // BUTTON
                        // ===========================
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Game Center",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ===========================
                        // SUBTEXT
                        // ===========================
                        const Text(
                          "La Liga, Game day 11",
                          style: TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                        const Text(
                          "Stadion Bernabeu",
                          style: TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  const _DayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Widget _teamColumn(String logo, String name) {
  return Column(
    children: [
      Image.asset(logo, width: 36),
      const SizedBox(height: 6),
      Text(name, style: const TextStyle(color: Colors.white, fontSize: 11)),
    ],
  );
}
