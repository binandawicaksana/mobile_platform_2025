import 'package:flutter/material.dart';
import 'auth_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _logout(BuildContext context) {
    AuthService.instance.logout(); // kosongkan user
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false, // bersihkan semua route sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = AuthService.instance.currentUser ?? 'User';

    final categories = [
      {'icon': Icons.flight, 'label': 'Pesawat'},
      {'icon': Icons.train, 'label': 'Kereta'},
      {'icon': Icons.directions_bus_filled, 'label': 'Bus'},
      {'icon': Icons.hotel, 'label': 'Hotel'},
      {'icon': Icons.movie, 'label': 'Entertainment'},
      {'icon': Icons.restaurant, 'label': 'Restoran'},
      {'icon': Icons.local_gas_station, 'label': 'SPBU'},
      {'icon': Icons.apps, 'label': 'Lainnya'},
    ];

    final destinations = [
      {
        'title': 'Mt Agung',
        'distance': '1.050 km',
        'image':
            'https://images.pexels.com/photos/1434608/pexels-photo-1434608.jpeg?auto=compress&cs=tinysrgb&w=800',
      },
      {
        'title': 'Mt GedePangrango',
        'distance': '37 km',
        'image':
            'https://images.pexels.com/photos/2404370/pexels-photo-2404370.jpeg?auto=compress&cs=tinysrgb&w=800',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEAFBFF),
      body: SafeArea(
        child: Column(
          children: [
            // ====== SCROLL CONTENT ======
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER =================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kiri: Hi, username + lokasi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, $username',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Bogor, Indonesia',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Kanan: notif + avatar + LOGOUT (pojok kanan atas)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.notifications_none,
                                size: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(
                                'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg?auto=compress&cs=tinysrgb&w=200',
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              tooltip: 'Logout',
                              onPressed: () => _logout(context),
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // SEARCH BAR
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Mau kemana...',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // KATEGORI
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(categories.length, (index) {
                        final cat = categories[index];
                        final width =
                            (MediaQuery.of(context).size.width - 16 * 2) / 4 -
                                12;
                        return SizedBox(
                          width: width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFB0B0B0),
                                ),
                                child: Icon(
                                  cat['icon'] as IconData,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat['label'] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // DESTINASI POPULER TITLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Destinasi Populer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // LIST CARD DESTINASI
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: destinations.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final dest = destinations[index];
                          return _DestinationCard(
                            title: dest['title'] as String,
                            distance: dest['distance'] as String,
                            imageUrl: dest['image'] as String,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ====== BOTTOM NAV (tanpa logout lagi) ======
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.home, color: Colors.white),
                    Icon(Icons.receipt_long, color: Colors.white70),
                    // tombol search tengah
                    _CenterSearchButton(),
                    Icon(Icons.favorite_border, color: Colors.white70),
                    Icon(Icons.settings, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterSearchButton extends StatelessWidget {
  const _CenterSearchButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Icon(
        Icons.search,
        color: Colors.black87,
        size: 26,
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String title;
  final String distance;
  final String imageUrl;

  const _DestinationCard({
    required this.title,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO + LOVE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // TEKS & AVATAR
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  distance,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 8,
                      backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100',
                      ),
                    ),
                    SizedBox(width: 4),
                    CircleAvatar(
                      radius: 8,
                      backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=100',
                      ),
                    ),
                    SizedBox(width: 4),
                    CircleAvatar(
                      radius: 8,
                      backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=100',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
