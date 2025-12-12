import 'package:flutter/material.dart';

import 'main.dart';
import 'widgets/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const Color primaryColor = Color(0xFF0057FF);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<_ThemeChoice> _themeChoices = const [
    _ThemeChoice(label: "Biru", color: Color(0xFF0057FF)),
    _ThemeChoice(label: "Ungu", color: Color(0xFF7E22CE)),
    _ThemeChoice(label: "Hijau", color: Color(0xFF22C55E)),
    _ThemeChoice(label: "Oranye", color: Color(0xFFF97316)),
  ];

  String _selectedTheme = "Biru";
  String _selectedLanguage = "Indonesia";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = AppStateScope.of(context);
    if (appState != null) {
      final seed = appState.pageSeedColor ?? SettingsPage.primaryColor;
      _selectedTheme = _themeChoices
          .firstWhere(
            (c) => c.color == seed,
            orElse: () => _themeChoices.first,
          )
          .label;
      final locale = appState.locale ?? const Locale('id');
      _selectedLanguage =
          locale.languageCode == 'en' ? "Inggris" : "Indonesia";
    }
  }

  void _selectTheme(_ThemeChoice choice) {
    final appState = AppStateScope.of(context);
    appState?.updatePageSeedColor(choice.color);
    setState(() {
      _selectedTheme = choice.label;
    });
  }

  void _selectLanguage(String label) {
    final appState = AppStateScope.of(context);
    if (appState == null) return;

    final code = label == "Inggris" ? "en" : "id";
    appState.updateLocale(code);
    setState(() {
      _selectedLanguage = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor =
        AppStateScope.of(context)?.pageSeedColor ?? SettingsPage.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFE9F2FF),
      drawer: AppDrawer(
        activeDestination: DrawerDestination.setting,
        onGoToDashboard: () => Navigator.of(context).maybePop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      icon: Icons.remove_red_eye_outlined,
                      title: "Tema Warna",
                      color: accentColor,
                    ),
                    const SizedBox(height: 12),
                    _buildThemeOptions(),
                    const SizedBox(height: 36),
                    _buildSectionHeader(
                      icon: Icons.public_outlined,
                      title: "Bahasa",
                      color: accentColor,
                    ),
                    const SizedBox(height: 12),
                    _buildLanguageOptions(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOptions() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _themeChoices
            .map(
              (choice) => _StaticThemeRow(
                label: choice.label,
                color: choice.color,
                isSelected: _selectedTheme == choice.label,
                onTap: () => _selectTheme(choice),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLanguageOptions() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LanguageRow(
            label: "Indonesia",
            isSelected: _selectedLanguage == "Indonesia",
            onTap: () => _selectLanguage("Indonesia"),
          ),
          _LanguageRow(
            label: "Inggris",
            isSelected: _selectedLanguage == "Inggris",
            onTap: () => _selectLanguage("Inggris"),
          ),
        ],
      ),
    );
  }
}

class _StaticThemeRow extends StatelessWidget {
  const _StaticThemeRow({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              child: isSelected
                  ? const Icon(
                      Icons.arrow_right_alt,
                      color: Colors.black87,
                      size: 22,
                    )
                  : const SizedBox(), // placeholder to keep dots aligned
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? Colors.black : Colors.black.withOpacity(0.15),
                  width: isSelected ? 2 : 1,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              child: isSelected
                  ? const Icon(
                      Icons.arrow_right_alt,
                      color: Colors.black87,
                      size: 22,
                    )
                  : const SizedBox(), // placeholder to keep text aligned
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChoice {
  const _ThemeChoice({required this.label, required this.color});

  final String label;
  final Color color;
}
