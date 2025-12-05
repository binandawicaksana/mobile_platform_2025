import 'package:flutter/material.dart';

class DeskripsiPage extends StatelessWidget {
  final String namaGunung;
  final String lokasi;
  final String deskripsi;
  final bool isAgung; // biar bisa bedain foto agung / pangrango

  const DeskripsiPage({
    super.key,
    required this.namaGunung,
    required this.lokasi,
    required this.deskripsi,
    required this.isAgung,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = isAgung ? 'assets/images/f.jpg' : 'assets/images/g.jpg';
    final gallery = isAgung
        ? ['assets/images/f.jpg', 'assets/images/g.jpg']
        : ['assets/images/g.jpg', 'assets/images/f.jpg'];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _HeroImage(imagePath: imagePath),
                    Transform.translate(
                      offset: const Offset(0, -36),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, -6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4DF),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Text(
                                  '5.5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB88736),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              namaGunung,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    lokasi,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              deskripsi,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Container(
                  height: 82,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _AvatarThumbnail(
                              imagePath: gallery.first,
                              left: 0,
                            ),
                            _AvatarThumbnail(
                              imagePath: gallery.last,
                              left: 28,
                            ),
                            Positioned(
                              left: 56,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: const Text('Pesan sekarang'),
                        ),
                      ),
                    ],
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

class _HeroImage extends StatelessWidget {
  final String imagePath;

  const _HeroImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 420,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: _CircularIconButton(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),
        ),
      ],
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _AvatarThumbnail extends StatelessWidget {
  final String imagePath;
  final double left;

  const _AvatarThumbnail({
    required this.imagePath,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }
}

class AvatarList extends StatefulWidget {
  const AvatarList({super.key});

  @override
  _AvatarListState createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  List<String> avatars = [
    'assets/images/f.jpg',
    'assets/images/g.jpg',
    'assets/images/f.jpg',
  ];

  void addAvatar() {
    // contoh: tambahkan gambar statis
    // kalau mau buka gallery/camera tinggal ganti fungsi ini nantinya
    setState(() {
      // tambahkan gambar default lain saat ini
      avatars.add('assets/images/g.jpg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          for (int i = 0; i < avatars.length; i++)
            _AvatarThumbnail(
              imagePath: avatars[i],
              left: i * 40,
            ),

          // tombol tambah (+)
          Positioned(
            left: avatars.length * 40,
            child: GestureDetector(
              onTap: addAvatar,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
