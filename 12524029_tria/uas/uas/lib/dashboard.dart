import 'package:flutter/material.dart';
import 'theme_const.dart';
import 'bottom_nav.dart';
import 'ticket.dart';
import 'login.dart';

class DashboardPenerbanganScreen extends StatefulWidget {
  const DashboardPenerbanganScreen({super.key});

  @override
  State<DashboardPenerbanganScreen> createState() => _DashboardPenerbanganScreenState();
}

class _DashboardPenerbanganScreenState extends State<DashboardPenerbanganScreen> {
  bool isRoundTrip = false; // false = Satu Arah, true = Pulang Pergi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      bottomNavigationBar: const MainBottomNav(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                  const Text(
                    'Hi, Tria',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2FBFF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => setState(() => isRoundTrip = false),
                                child: isRoundTrip
                                    ? _chipUnselected('Satu Arah')
                                    : _chipSelected('Satu Arah'),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => setState(() => isRoundTrip = true),
                                child: isRoundTrip
                                    ? _chipSelected('Pulang Pergi')
                                    : _chipUnselected('Pulang Pergi'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Tanggal Pergi',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text('Sen, 10 Des',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              if (isRoundTrip)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: const [
                                    Text('Tanggal Pulang',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    SizedBox(height: 4),
                                    Text('Rab, 12 Des',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.calendar_today, size: 20),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Awal',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text('Jakarta',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Tujuan',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text('Bali',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TicketScreen()),
                                  );
                                },
                                child: const Text(
                                  'Cari Penerbangan',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipSelected(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      );

  Widget _chipUnselected(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: kPrimaryColor)),
      );
}
