import 'dart:ui';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimController;
  late AnimationController _glowAnimController;
  late List<AnimationController> _cardAnimControllers;
  
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    // Main animation
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Glow animation
    _glowAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _glowAnimController,
        curve: Curves.easeInOut,
      ),
    );

    // Card animations
    _cardAnimControllers = List.generate(
      4,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _mainAnimController.forward();

    // Stagger card animations
    for (int i = 0; i < _cardAnimControllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: 300 + (i * 150)),
        () => _cardAnimControllers[i].forward(),
      );
    }
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    _glowAnimController.dispose();
    for (var controller in _cardAnimControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          /// ---------- PREMIUM GRADIENT BACKGROUND ----------
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF667EEA),
                  const Color(0xFF764BA2),
                  const Color(0xFF6B73FF),
                  const Color(0xFF9B59B6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          /// ---------- ANIMATED GLASSMORPHISM ORBS ----------
          AnimatedBuilder(
            animation: _glowAnimController,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: -100,
                    right: -60,
                    child: _animatedBlurCircle(
                      250,
                      Colors.purpleAccent.withOpacity(0.2 * _glowAnim.value),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.2,
                    left: -50,
                    child: _animatedBlurCircle(
                      200,
                      Colors.blueAccent.withOpacity(0.15 * _glowAnim.value),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: size.width * 0.2,
                    child: _animatedBlurCircle(
                      220,
                      Colors.pinkAccent.withOpacity(0.18 * _glowAnim.value),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    right: -50,
                    child: _animatedBlurCircle(
                      260,
                      Colors.cyanAccent.withOpacity(0.2 * _glowAnim.value),
                    ),
                  ),
                ],
              );
            },
          ),

          /// ---------- MAIN CONTENT ----------
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: 20,
              ),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      /// ---------- ELEGANT HEADER ----------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFFE0E7FF),
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    "Dashboard",
                                    style: TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Selamat datang kembali!",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.05),

                      /// ---------- PREMIUM GLASSMORPHISM CARDS ----------
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          final cards = [
                            {
                              'icon': Icons.account_circle_rounded,
                              'label': 'Profil',
                              'color': const Color(0xFF9D4EDD),
                              'gradient': [
                                const Color(0xFF9D4EDD),
                                const Color(0xFF5A4AF1),
                              ],
                            },
                            {
                              'icon': Icons.bar_chart_rounded,
                              'label': 'Statistik',
                              'color': const Color(0xFF4A90E2),
                              'gradient': [
                                const Color(0xFF4A90E2),
                                const Color(0xFF357ABD),
                              ],
                            },
                            {
                              'icon': Icons.settings_rounded,
                              'label': 'Pengaturan',
                              'color': const Color(0xFF00C6FF),
                              'gradient': [
                                const Color(0xFF00C6FF),
                                const Color(0xFF0072FF),
                              ],
                            },
                            {
                              'icon': Icons.logout_rounded,
                              'label': 'Logout',
                              'color': const Color(0xFFFF6B6B),
                              'gradient': [
                                const Color(0xFFFF6B6B),
                                const Color(0xFFEE5A6F),
                              ],
                            },
                          ];

                          final card = cards[index];
                          final isLogout = index == 3;

                          return ScaleTransition(
                            scale: Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                parent: _cardAnimControllers[index],
                                curve: Curves.easeOutBack,
                              ),
                            ),
                            child: FadeTransition(
                              opacity: _cardAnimControllers[index],
                              child: _PremiumDashboardCard(
                                icon: card['icon'] as IconData,
                                label: card['label'] as String,
                                gradient: card['gradient'] as List<Color>,
                                glowAnim: _glowAnim,
                                onTap: isLogout
                                    ? () {
                                        Navigator.of(context).pop();
                                      }
                                    : () {},
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: size.height * 0.04),

                      /// ---------- BOTTOM STATS CARD ----------
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.25),
                                  Colors.white.withOpacity(0.15),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 30,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  Icons.trending_up_rounded,
                                  "Aktif",
                                  "12",
                                  Colors.greenAccent,
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildStatItem(
                                  Icons.access_time_rounded,
                                  "Hari ini",
                                  "8",
                                  Colors.blueAccent,
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                _buildStatItem(
                                  Icons.star_rounded,
                                  "Rating",
                                  "4.8",
                                  Colors.amberAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _animatedBlurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.3),
            color.withOpacity(0),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 100,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}

class _PremiumDashboardCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final Animation<double> glowAnim;
  final VoidCallback onTap;

  const _PremiumDashboardCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.glowAnim,
    required this.onTap,
  });

  @override
  State<_PremiumDashboardCard> createState() => _PremiumDashboardCardState();
}

class _PremiumDashboardCardState extends State<_PremiumDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.glowAnim,
      builder: (context, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 1, end: 0.95).animate(
            CurvedAnimation(
              parent: _pressController,
              curve: Curves.easeInOut,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  onTapDown: (_) {
                    setState(() => _isPressed = true);
                    _pressController.forward();
                  },
                  onTapUp: (_) {
                    setState(() => _isPressed = false);
                    _pressController.reverse();
                  },
                  onTapCancel: () {
                    setState(() => _isPressed = false);
                    _pressController.reverse();
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.gradient[0]
                              .withOpacity(0.3 * widget.glowAnim.value),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: widget.gradient[0]
                                    .withOpacity(0.4 * widget.glowAnim.value),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

