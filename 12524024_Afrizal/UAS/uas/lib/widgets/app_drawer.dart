import 'package:flutter/material.dart';

enum DrawerDestination { aplikasi, setting, faq }

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.activeDestination,
    required this.onGoToDashboard,
  });

  final DrawerDestination activeDestination;
  final VoidCallback onGoToDashboard;

  void _handleDestinationTap(
    BuildContext context,
    DrawerDestination destination,
  ) {
    Navigator.of(context).pop(); // close drawer first
    if (destination == activeDestination) return;

    final routeName = switch (destination) {
      DrawerDestination.aplikasi => '/uts',
      DrawerDestination.setting => '/settings',
      DrawerDestination.faq => '/faq',
    };

    Navigator.of(context).pushReplacementNamed(routeName);
  }

  void _handleDashboardTap(BuildContext context) {
    Navigator.of(context).pop(); // close drawer first
    onGoToDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DrawerMenuItem(
                icon: Icons.apps_rounded,
                label: "Aplikasi",
                isActive: activeDestination == DrawerDestination.aplikasi,
                onTap: () => _handleDestinationTap(
                  context,
                  DrawerDestination.aplikasi,
                ),
              ),
              const SizedBox(height: 12),
              _DrawerMenuItem(
                icon: Icons.settings_outlined,
                label: "Setting",
                isActive: activeDestination == DrawerDestination.setting,
                onTap: () => _handleDestinationTap(
                  context,
                  DrawerDestination.setting,
                ),
              ),
              const SizedBox(height: 12),
              _DrawerMenuItem(
                icon: Icons.help_outline_rounded,
                label: "FAQ",
                isActive: activeDestination == DrawerDestination.faq,
                onTap: () => _handleDestinationTap(
                  context,
                  DrawerDestination.faq,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0057FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => _handleDashboardTap(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text(
                    "Kembali ke Dashboard",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : const Color(0xFFF4F4F6),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: isActive ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
