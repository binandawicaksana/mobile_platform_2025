import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dashboard.dart';
import 'faq_page.dart';
import 'login.dart';
import 'settings_page.dart';
import 'uts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Color _baseSeedColor = Color(0xFF4C6FFF);
  Color _pageSeedColor = const Color(0xFF0057FF);
  Locale _locale = const Locale('id');

  void updatePageSeedColor(Color color) {
    setState(() {
      _pageSeedColor = color;
    });
  }

  void updateLocale(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      controller: AppStateController(
        pageSeedColor: _pageSeedColor,
        locale: _locale,
        updatePageSeedColor: updatePageSeedColor,
        updateLocale: updateLocale,
      ),
      child: MaterialApp(
        title: 'Flutter Login App',
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: const [
          Locale('id'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: _baseSeedColor,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFEEF2FF),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/uts': (context) => const UtsPage(),
          '/settings': (context) => const SettingsPage(),
          '/faq': (context) => const FaqPage(),
        },
      ),
    );
  }
}

class AppStateController {
  AppStateController({
    required this.pageSeedColor,
    required this.locale,
    required this.updatePageSeedColor,
    required this.updateLocale,
  });

  final Color? pageSeedColor;
  final Locale? locale;
  final void Function(Color) updatePageSeedColor;
  final void Function(String) updateLocale;
}

class AppStateScope extends InheritedWidget {
  const AppStateScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final AppStateController controller;

  static AppStateController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()?.controller;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    final currentColor =
        controller.pageSeedColor ?? const Color(0xFF0057FF);
    final previousColor =
        oldWidget.controller.pageSeedColor ?? const Color(0xFF0057FF);
    final currentLocale = controller.locale ?? const Locale('id');
    final previousLocale = oldWidget.controller.locale ?? const Locale('id');

    return currentColor != previousColor || currentLocale != previousLocale;
  }
}
