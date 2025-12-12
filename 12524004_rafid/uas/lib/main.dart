library expense_mockup;

import 'dart:convert';
import 'dart:io' show Platform, File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:uas/data/expense_repository.dart';
import 'package:uas/data/models.dart';
import 'package:uas/data/user_repository.dart';
import 'package:uas/services/gemini_ocr_service.dart';
import 'package:uas/services/local_ocr_service.dart';
import 'package:uas/theme/mockup_colors.dart';
import 'package:uas/utils/currency_formatter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

part 'screens/auth_screen.dart';
part 'screens/dashboard_screen.dart';
part 'screens/scan_bill_screen.dart';
part 'screens/history_screen.dart';
part 'screens/layout_showcase_screen.dart';
part 'screens/transaction_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    final envFile = File('.env');
    if (envFile.existsSync()) {
      await dotenv.load(fileName: '.env');
    }
  }
  if (!kIsWeb &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    sqflite.databaseFactory = databaseFactoryFfi;
  }
  runApp(const ExpenseMockupApp());
}

class ExpenseMockupApp extends StatelessWidget {
  const ExpenseMockupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mockup Tracking Pengeluaran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MockupColors.blueDark),
        scaffoldBackgroundColor: Colors.transparent,
        useMaterial3: true,
      ),
      home: const ExpenseHomePage(),
    );
  }
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  int _currentIndex = 0;
  bool _isAuthenticated = false;
  bool _isLoginMode = true;
  final ExpenseRepository _repository = ExpenseRepository();
  final UserRepository _userRepository = UserRepository();
  static const String _defaultEmail = 'demo@uas.app';
  static const String _defaultPassword = '123456';

  @override
  void initState() {
    super.initState();
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    var hasUser = await _userRepository.hasAnyUser();
    if (!hasUser) {
      try {
        await _userRepository.register(
          name: 'Demo User',
          email: _defaultEmail,
          password: _defaultPassword,
          initialBalance: 1000000,
        );
        hasUser = true;
      } catch (_) {
        hasUser = await _userRepository.hasAnyUser();
      }
    }
    if (!mounted) return;
    setState(() {
      _isLoginMode = hasUser;
    });
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  void _onItemSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _toggleAuthMode() {
    setState(() => _isLoginMode = !_isLoginMode);
  }

  void _handleLogout() {
    _repository.clearUser();
    setState(() {
      _isAuthenticated = false;
      _isLoginMode = true;
      _currentIndex = 0;
    });
  }

  Future<void> _handleAuthSubmit(AuthFormData data) async {
    FocusScope.of(context).unfocus();
    try {
      UserAccount user;
      if (data.mode == AuthMode.login) {
        user = await _userRepository.login(
          email: data.email,
          password: data.password,
        );
      } else {
        if (data.password != data.confirmPassword) {
          throw AuthException('Konfirmasi password tidak sama.');
        }
        user = await _userRepository.register(
          name: data.fullName!.trim(),
          email: data.email,
          password: data.password,
          initialBalance: data.initialBalance ?? 0,
        );
        setState(() => _isLoginMode = true);
      }

      await _repository.setActiveUser(user);
      if (!mounted) return;
      setState(() {
        _isAuthenticated = true;
        _currentIndex = 0;
      });
    } on AuthException catch (error) {
      if (!mounted) return;
      debugPrint('Autentikasi gagal: ${error.message}');
    } catch (error) {
      if (!mounted) return;
      debugPrint('Terjadi kesalahan: $error');
    }
  }

  Future<void> _openSetBalancePage() async {
    if (!_repository.isInitialized) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return PhoneSheetWrapper(
          child: InitialBalanceScreen(
            initialValue: _repository.initialBalance,
            onSubmit: (value) => _repository.updateInitialBalance(value),
          ),
        );
      },
    );
  }

  Future<void> _openTransactionPage({
    TransactionType initialType = TransactionType.expense,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return PhoneSheetWrapper(
          child: AddTransactionScreen(
            categories: _repository.categories,
            initialType: initialType,
            onSubmit: (transaction) => _repository.addTransaction(transaction),
          ),
        );
      },
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return DashboardScreen(
          repository: _repository,
          onAddTransaction: () =>
              _openTransactionPage(initialType: TransactionType.expense),
          onSetInitialBalance: _openSetBalancePage,
        );
      case 1:
        return ScanBillScreen(repository: _repository);
      case 2:
        return HistoryScreen(repository: _repository);
      case 3:
        return LayoutShowcaseScreen(repository: _repository);
      default:
        return DashboardScreen(
          repository: _repository,
          onAddTransaction: () =>
              _openTransactionPage(initialType: TransactionType.expense),
          onSetInitialBalance: _openSetBalancePage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MockupColors.blueDark.withOpacity(0.08),
              MockupColors.blueLight.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: PhoneShell(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _isAuthenticated
                  ? _MainAppView(
                      key: ValueKey('home-$_currentIndex'),
                      screen: KeyedSubtree(
                        key: ValueKey('screen-$_currentIndex'),
                        child: _buildScreen(_currentIndex),
                      ),
                      onItemSelected: _onItemSelected,
                      currentIndex: _currentIndex,
                      onLogout: _handleLogout,
                      user: _repository.currentUser,
                    )
                  : _AuthView(
                      key: ValueKey('auth-$_isLoginMode'),
                      child: AuthScreen(
                        isLogin: _isLoginMode,
                        onSubmit: _handleAuthSubmit,
                        onToggleMode: _toggleAuthMode,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainAppView extends StatelessWidget {
  const _MainAppView({
    super.key,
    required this.screen,
    required this.onItemSelected,
    required this.currentIndex,
    required this.onLogout,
    required this.user,
  });

  final Widget screen;
  final ValueChanged<int> onItemSelected;
  final int currentIndex;
  final VoidCallback onLogout;
  final UserAccount? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: _AppDrawer(
        currentIndex: currentIndex,
        onNavigate: onItemSelected,
        onLogout: onLogout,
        user: user,
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              StatusBar(onMenuTap: () => Scaffold.of(context).openDrawer()),
              Expanded(child: screen),
              BottomNav(
                items: const [
                  BottomNavItem(label: 'Dashboard', icon: Icons.home_outlined),
                  BottomNavItem(label: 'Scan Bill', icon: Icons.qr_code_scanner),
                  BottomNavItem(label: 'History', icon: Icons.credit_card),
                  BottomNavItem(label: 'Layouts', icon: Icons.dashboard_customize),
                ],
                activeIndex: currentIndex,
                onItemSelected: onItemSelected,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class PhoneShell extends StatelessWidget {
  const PhoneShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Container(
        width: 320,
        height: 640,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: MockupColors.borderBase.withOpacity(0.15),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: child,
        ),
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final hasMenu = onMenuTap != null;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18, hasMenu ? 18 : 20, 18, 16),
      decoration: const BoxDecoration(
        color: MockupColors.blueDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        children: [
          if (hasMenu)
            Material(
              color: Colors.white.withOpacity(0.18),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu, color: Colors.white),
                splashRadius: 24,
              ),
            )
          else
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 26,
            ),
          const SizedBox(width: 12),
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class CameraActionsRow extends StatelessWidget {
  const CameraActionsRow({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final label in labels)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: MockupColors.pillBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: MockupColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

class CameraPreview extends StatelessWidget {
  const CameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            MockupColors.blueDark.withOpacity(0.45),
            MockupColors.blueLight.withOpacity(0.45),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Arahkan ke struk'.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          Container(
            width: 220,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.7),
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraControls extends StatelessWidget {
  const CameraControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        MiniButton(label: 'Aa'),
        SizedBox(width: 24),
        ShutterButton(),
        SizedBox(width: 24),
        MiniButton(label: '??'),
      ],
    );
  }
}

class MiniButton extends StatelessWidget {
  const MiniButton({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: MockupColors.pillBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: MockupColors.textSecondary),
      ),
    );
  }
}

class ShutterButton extends StatelessWidget {
  const ShutterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: MockupColors.blueLight.withOpacity(0.32),
          width: 6,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MockupColors.blueLight,
        ),
      ),
    );
  }
}

class OcrPreview extends StatelessWidget {
  const OcrPreview({super.key, required this.details, required this.actions});

  final List<String> details;
  final List<OcrAction> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MockupColors.blueLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: MockupColors.blueLight.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hasil Scan',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < details.length; i++) ...[
            Text(
              details[i],
              style: const TextStyle(fontSize: 13),
            ),
            if (i != details.length - 1) const SizedBox(height: 4),
          ],
          const SizedBox(height: 12),
          Row(
            children: List.generate(actions.length, (index) {
              final action = actions[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == actions.length - 1 ? 0 : 8,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: action.primary
                          ? MockupColors.blueDark
                          : MockupColors.blueLight.withOpacity(0.18),
                      foregroundColor:
                          action.primary ? Colors.white : MockupColors.blueDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      action.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class FilterTabs extends StatelessWidget {
  const FilterTabs({super.key, required this.tabs, required this.activeIndex});

  final List<String> tabs;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MockupColors.pillBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: i == activeIndex ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: i == activeIndex
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: i == activeIndex
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: i == activeIndex
                        ? MockupColors.blueDark
                        : MockupColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FilterRow extends StatelessWidget {
  const FilterRow({super.key, required this.filters});

  final List<FilterChipData> filters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < filters.length; i++) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: MockupColors.pillBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    filters[i].label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: MockupColors.textSecondary,
                    ),
                  ),
                  Text(
                    filters[i].value,
                    style: const TextStyle(
                      fontSize: 12,
                      color: MockupColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i != filters.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
class SearchBox extends StatelessWidget {
  const SearchBox({super.key, required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: MockupColors.pillBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('??'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              placeholder,
              style: const TextStyle(
                fontSize: 12,
                color: MockupColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionGroupWidget extends StatelessWidget {
  const TransactionGroupWidget({super.key, required this.group});

  final TransactionGroupData group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.label,
          style: const TextStyle(
            fontSize: 11,
            color: MockupColors.textSecondary,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < group.items.length; i++) ...[
          TransactionCard(item: group.items[i]),
          if (i != group.items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MockupColors.borderBase.withOpacity(0.18)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 11,
                    color: MockupColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: item.isIncome
                      ? MockupColors.accentGreen
                      : MockupColors.accentRed,
                ),
              ),
              if (item.attachment != null) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MockupColors.blueLight.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.attachment!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: MockupColors.mutedBlue,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onItemSelected,
  });

  final List<BottomNavItem> items;
  final int activeIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: MockupColors.blueDark,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onItemSelected(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i].icon,
                      size: 18,
                      color: i == activeIndex
                          ? MockupColors.blueDark
                          : MockupColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[i].label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            i == activeIndex ? FontWeight.w600 : FontWeight.w500,
                        color: i == activeIndex
                            ? MockupColors.blueDark
                            : MockupColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 4,
                      width: 24,
                      decoration: BoxDecoration(
                        color: i == activeIndex
                            ? MockupColors.blueDark
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BottomNavItem {
  const BottomNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
class BarEntry {
  const BarEntry({
    required this.label,
    required this.value,
    required this.percent,
  });

  final String label;
  final String value;
  final double percent;
}

class CategoryBudgetEntry {
  const CategoryBudgetEntry({
    required this.name,
    required this.detail,
    required this.percent,
    required this.color,
  });

  final String name;
  final String detail;
  final double percent;
  final Color color;
}

class OcrAction {
  const OcrAction({required this.label, this.primary = false});

  final String label;
  final bool primary;
}

class FilterChipData {
  const FilterChipData({required this.label, required this.value});

  final String label;
  final String value;
}

class TransactionGroupData {
  const TransactionGroupData({required this.label, required this.items});

  final String label;
  final List<TransactionItem> items;
}

class TransactionItem {
  const TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    this.isIncome = false,
    this.attachment,
  });

  final String title;
  final String category;
  final String amount;
  final bool isIncome;
  final String? attachment;
}






