import 'package:flutter/material.dart';
import 'package:uas/widgets/money_logo_painter.dart';
import 'package:flutter/services.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController contactController = TextEditingController();
  bool isLoading = false;
  late _Country _selectedCountry;
  final List<_Country> _countries = const [
    _Country(flag: "🇮🇩", code: "+62", name: "Indonesia"),
    _Country(flag: "🇲🇾", code: "+60", name: "Malaysia"),
    _Country(flag: "🇸🇬", code: "+65", name: "Singapore"),
    _Country(flag: "🇹🇭", code: "+66", name: "Thailand"),
    _Country(flag: "🇨🇳", code: "+86", name: "Tiongkok"),
    _Country(flag: "🇰🇷", code: "+82", name: "Korea Selatan"),
    _Country(flag: "🇺🇸", code: "+1", name: "United States"),
    _Country(flag: "🇬🇧", code: "+44", name: "United Kingdom"),
    _Country(flag: "🇮🇳", code: "+91", name: "India"),
    _Country(flag: "🇦🇺", code: "+61", name: "Australia"),
    _Country(flag: "🇯🇵", code: "+81", name: "Japan"),
  ];

  Color get _primaryBlue => const Color(0xFF0D8BFF);
  Color get _secondaryBlue => const Color(0xFF4EC8FF);

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.first;
  }

  void _login() {
    if (isLoading) return;
    FocusScope.of(context).unfocus();

    final contact = contactController.text.trim();
    if (contact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nomor telepon wajib diisi"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (contact.length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nomor telepon harus minimal 12 digit"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(
            contact: contact,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: _primaryBlue,
      body: Stack(
        children: [
          if (!isWide)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _primaryBlue,
                      _primaryBlue.withOpacity(0.9),
                      _primaryBlue,
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 520 : 430),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: isWide ? 32 : 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildBranding(textTheme),
                            SizedBox(height: isWide ? 32 : 28),
                            _buildLoginCard(textTheme),
                            const SizedBox(height: 12),
                            _buildConsentText(textTheme),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomAction(textTheme),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranding(TextTheme textTheme) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 24,
                  child: CustomPaint(
                    painter: const MoneyLogoPainter(Color(0xFF0D8BFF), waveHeightFactor: 0.13),
                    size: const Size(30, 24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "DANA",
              style: textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          "Masukan nomor HP kamu untuk lanjut",
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginCard(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          child: Row(
            children: [
              const SizedBox(
                width: 140,
                child: Text(
                  "Negara",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Nomor",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<_Country>(
                            value: _selectedCountry,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: _primaryBlue, width: 1.4),
                              ),
                            ),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                            items: _countries
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Row(
                                      children: [
                                        Text(c.flag, style: const TextStyle(fontSize: 16)),
                                        const SizedBox(width: 6),
                                        Text(
                                          c.code,
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _selectedCountry = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: contactController,
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            hintText: "812 3456 7890",
                            prefixIcon: Icon(Icons.phone_android, color: _primaryBlue),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: _primaryBlue, width: 1.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConsentText(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        "Kami akan menggunakan nomor HP ini sebagai ID kamu dan untuk menggunakan akun kamu. "
        "Dengan menindaklanjutkan, kami setuju dengan S&K serta Kebijakan Privasi kami.",
        style: textTheme.bodySmall?.copyWith(
          color: Colors.white.withOpacity(0.9),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBottomAction(TextTheme textTheme) {
    return Container(
      color: _primaryBlue,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(TextTheme textTheme) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildActionButton(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _primaryBlue,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: _primaryBlue.withOpacity(0.35)),
          ),
        ),
        onPressed: isLoading ? null : _login,
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(_primaryBlue),
                ),
              )
            : const Text(
                "Lanjutkan",
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
              ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(90, 48),
        side: BorderSide(color: color.withOpacity(0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Country {
  final String flag;
  final String code;
  final String name;

  const _Country({
    required this.flag,
    required this.code,
    required this.name,
  });
}
