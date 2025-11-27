import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pertemuan9/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscure = true;
  bool _isLoading = false;
  bool _isButtonHovered = false;

  late AnimationController _mainAnimController;
  late AnimationController _buttonAnimController;
  late AnimationController _glowAnimController;
  
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;
  late Animation<double> _buttonScaleAnim;

  @override
  void initState() {
    super.initState();
    
    // Main content animation
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _mainAnimController,
        curve: const Interval(0.2, 1, curve: Curves.easeOutBack),
      ),
    );

    // Button animation
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _buttonScaleAnim = Tween<double>(begin: 1, end: 0.97).animate(
      CurvedAnimation(
        parent: _buttonAnimController,
        curve: Curves.easeInOut,
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

    _mainAnimController.forward();
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    _buttonAnimController.dispose();
    _glowAnimController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _buttonAnimController.forward();

      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      setState(() => _isLoading = false);
      _buttonAnimController.reverse();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Selamat datang, ${_usernameController.text}!",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          elevation: 8,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const DashboardPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
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
                    top: -80,
                    left: -60,
                    child: _animatedBlurCircle(
                      220,
                      Colors.purpleAccent.withOpacity(0.2 * _glowAnim.value),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.15,
                    right: -50,
                    child: _animatedBlurCircle(
                      180,
                      Colors.blueAccent.withOpacity(0.15 * _glowAnim.value),
                    ),
                  ),
                  Positioned(
                    bottom: -70,
                    left: size.width * 0.3,
                    child: _animatedBlurCircle(
                      200,
                      Colors.pinkAccent.withOpacity(0.18 * _glowAnim.value),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    right: -40,
                    child: _animatedBlurCircle(
                      240,
                      Colors.cyanAccent.withOpacity(0.2 * _glowAnim.value),
                    ),
                  ),
                ],
              );
            },
          ),

          /// ---------- MAIN CONTENT WITH ANIMATIONS ----------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: 20,
                ),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height * 0.05),

                          /// ---------- ELEGANT HEADING ----------
                          Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Color(0xFFE0E7FF),
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  "Selamat Datang",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Login untuk melanjutkan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.06),

                          /// ---------- PREMIUM GLASSMORPHISM CARD ----------
                          ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withOpacity(0.25),
                                      Colors.white.withOpacity(0.15),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(32),
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
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: -5,
                                      offset: const Offset(0, -5),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      _buildModernTextField(
                                        controller: _usernameController,
                                        focusNode: _usernameFocus,
                                        label: "Username",
                                        icon: Icons.person_rounded,
                                        validator: (v) =>
                                            v!.isEmpty ? "Isi username" : null,
                                      ),
                                      const SizedBox(height: 24),

                                      _buildModernTextField(
                                        controller: _passwordController,
                                        focusNode: _passwordFocus,
                                        label: "Password",
                                        icon: Icons.lock_rounded,
                                        obscure: _obscure,
                                        suffix: IconButton(
                                          icon: Icon(
                                            _obscure
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.white.withOpacity(0.8),
                                            size: 22,
                                          ),
                                          onPressed: () => setState(
                                              () => _obscure = !_obscure),
                                        ),
                                        validator: (v) => v!.length < 6
                                            ? "Minimal 6 karakter"
                                            : null,
                                      ),

                                      const SizedBox(height: 16),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                          ),
                                          child: Text(
                                            "Lupa Password?",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.95),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 28),

                                      /// ---------- PREMIUM BUTTON WITH GLOW ----------
                                      AnimatedBuilder(
                                        animation: _glowAnim,
                                        builder: (context, child) {
                                          return ScaleTransition(
                                            scale: _buttonScaleAnim,
                                            child: Container(
                                              height: 58,
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFF9D4EDD),
                                                    Color(0xFF5A4AF1),
                                                    Color(0xFF6B73FF),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.purple
                                                        .withOpacity(
                                                            0.4 * _glowAnim.value),
                                                    blurRadius:
                                                        _isLoading ? 15 : 30,
                                                    spreadRadius:
                                                        _isLoading ? 0 : 2,
                                                    offset: const Offset(0, 8),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.blue
                                                        .withOpacity(
                                                            0.3 * _glowAnim.value),
                                                    blurRadius:
                                                        _isLoading ? 10 : 25,
                                                    spreadRadius: 0,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: _isLoading
                                                      ? null
                                                      : _handleLogin,
                                                  onTapDown: (_) =>
                                                      _buttonAnimController
                                                          .forward(),
                                                  onTapUp: (_) =>
                                                      _buttonAnimController
                                                          .reverse(),
                                                  onTapCancel: () =>
                                                      _buttonAnimController
                                                          .reverse(),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: _isLoading
                                                        ? const SizedBox(
                                                            width: 28,
                                                            height: 28,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      Colors
                                                                          .white),
                                                              strokeWidth: 3,
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                "Login",
                                                                style: TextStyle(
                                                                  fontSize: 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      1.2,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_rounded,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.95),
                                                                size: 22,
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.04),

                          Center(
                            child: Text(
                              "© 2025 Mobile Platform",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- PREMIUM MODERN TEXTFIELD ----------
  Widget _buildModernTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    required String? Function(String?) validator,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([focusNode]),
      builder: (context, child) {
        final isFocused = focusNode.hasFocus;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscure,
            validator: validator,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(isFocused ? 0.95 : 0.7),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(isFocused ? 1 : 0.8),
                size: 22,
              ),
              suffixIcon: suffix,
              filled: true,
              fillColor: Colors.white.withOpacity(isFocused ? 0.2 : 0.12),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(isFocused ? 0.4 : 0.25),
                  width: isFocused ? 2 : 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.9),
                  width: 2.2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.redAccent.withOpacity(0.8),
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.redAccent,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------- ANIMATED GLASSMORPHISM ORB ----------
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
