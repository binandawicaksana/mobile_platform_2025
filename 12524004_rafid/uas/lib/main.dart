import 'package:flutter/material.dart';

void main() {
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

  static const List<Widget> _screens = [
    DashboardScreen(),
    ScanBillScreen(),
    HistoryScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _handleAuthSuccess() {
    setState(() => _isAuthenticated = true);
  }

  void _toggleAuthMode() {
    setState(() => _isLoginMode = !_isLoginMode);
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
                        child: _screens[_currentIndex],
                      ),
                      onItemSelected: _onItemSelected,
                      currentIndex: _currentIndex,
                    )
                  : _AuthView(
                      key: ValueKey('auth-$_isLoginMode'),
                      child: AuthScreen(
                        isLogin: _isLoginMode,
                        onSubmit: _handleAuthSuccess,
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
  });

  final Widget screen;
  final ValueChanged<int> onItemSelected;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StatusBar(),
        Expanded(child: screen),
        BottomNav(
          items: const ['Dashboard', 'Scan Bill', 'History'],
          activeIndex: currentIndex,
          onItemSelected: onItemSelected,
        ),
      ],
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StatusBar(),
        Expanded(child: child),
      ],
    );
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
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            '09:41',
            style: TextStyle(
              fontSize: 12,
              color: MockupColors.textSecondary,
            ),
          ),
          Text(
            '5G 100%',
            style: TextStyle(
              fontSize: 12,
              color: MockupColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    super.key,
    required this.isLogin,
    required this.onSubmit,
    required this.onToggleMode,
  });

  final bool isLogin;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final title = isLogin ? 'Masuk' : 'Daftar';
    final subtitle = isLogin
        ? 'Selamat datang kembali! Masuk untuk lanjut ke dashboard.'
        : 'Buat akun baru agar pengeluaranmu lebih teratur.';
    final actionLabel = isLogin ? 'Masuk Sekarang' : 'Buat Akun';
    final toggleLabel =
        isLogin ? 'Belum punya akun? Daftar' : 'Sudah punya akun? Masuk';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Text(
            'Self track.\nStay on budget.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: MockupColors.blueDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola pemasukan dan pengeluaranmu lewat aplikasi ini.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MockupColors.textSecondary,
                ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: MockupColors.blueDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: MockupColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                if (!isLogin) ...[
                  const AuthTextField(
                    label: 'Nama Lengkap',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                ],
                const AuthTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const AuthTextField(
                  label: 'Password',
                  obscureText: true,
                ),
                if (!isLogin) ...[
                  const SizedBox(height: 16),
                  const AuthTextField(
                    label: 'Konfirmasi Password',
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: MockupColors.blueDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onSubmit,
                  child: Text(
                    actionLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onToggleMode,
                  child: Text(
                    toggleLabel,
                    style: const TextStyle(
                      color: MockupColors.blueDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.verified_user, size: 18, color: MockupColors.mutedBlue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Data kamu terenkripsi dan aman. Kamu bisa ubah profil kapan pun.',
                        style: TextStyle(
                          fontSize: 12,
                          color: MockupColors.textSecondary,
                        ),
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

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: MockupColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: MockupColors.borderBase.withOpacity(0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: MockupColors.blueDark, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          AppHeader(
            subtitle: 'Halo kembali,',
            title: 'Rafid Akmal',
            trailing: AddButton(),
          ),
          SummaryCard(
            label: 'Saldo Bersih',
            amount: 'Rp 12.560.000',
            footerLeft: 'Pengeluaran Minggu Ini',
            footerRight: '-12% dibandingkan minggu lalu',
          ),
          SizedBox(height: 18),
          InfoCard(
            title: 'Pengeluaran per Kategori',
            child: BarChart(
              bars: [
                BarEntry(label: 'Mkn', value: '420K', percent: 0.42),
                BarEntry(label: 'Tagihan', value: '680K', percent: 0.68),
                BarEntry(label: 'Transport', value: '560K', percent: 0.56),
                BarEntry(label: 'Belanja', value: '320K', percent: 0.32),
                BarEntry(label: 'Lain', value: '240K', percent: 0.24),
              ],
            ),
          ),
          SizedBox(height: 18),
          InfoCard(
            title: 'Anggaran Kategori',
            child: Column(
              children: [
                CategoryBudgetRow(
                  entry: CategoryBudgetEntry(
                    name: 'Makan & Minum',
                    detail: '72% dari Rp 2jt',
                    percent: 0.72,
                    color: MockupColors.accentOrange,
                  ),
                ),
                SizedBox(height: 14),
                CategoryBudgetRow(
                  entry: CategoryBudgetEntry(
                    name: 'Transportasi',
                    detail: '48% dari Rp 1,5jt',
                    percent: 0.48,
                    color: MockupColors.accentPurple,
                  ),
                ),
                SizedBox(height: 14),
                CategoryBudgetRow(
                  entry: CategoryBudgetEntry(
                    name: 'Tagihan Bulanan',
                    detail: '64% dari Rp 3jt',
                    percent: 0.64,
                    color: MockupColors.accentGreen,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          InsightButton(),
        ],
      ),
    );
  }
}

class ScanBillScreen extends StatelessWidget {
  const ScanBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          AppHeader(
            subtitle: 'Mode',
            title: 'Scan Bill',
            trailing: AvatarBadge(initials: 'RP'),
          ),
          CameraActionsRow(labels: ['Import', 'Riwayat Scan']),
          SizedBox(height: 12),
          CameraPreview(),
          SizedBox(height: 16),
          CameraControls(),
          SizedBox(height: 16),
          OcrPreview(
            details: [
              'Merchant: Coffee Bloom',
              'Tanggal: 12 Apr 2024',
              'Total: Rp 58.000',
              'Metode: Kartu Debit',
            ],
            actions: [
              OcrAction(label: 'Edit'),
              OcrAction(label: 'Simpan', primary: true),
              OcrAction(label: 'Tambah Kategori'),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          AppHeader(
            subtitle: 'Laporan',
            title: 'History',
            trailing: AddButton(),
          ),
          FilterTabs(
            tabs: ['Minggu', 'Bulan', 'Tahun'],
            activeIndex: 0,
          ),
          SizedBox(height: 12),
          FilterRow(
            filters: [
              FilterChipData(label: 'Kategori', value: 'Makan'),
              FilterChipData(label: 'Metode', value: 'Kartu'),
            ],
          ),
          SizedBox(height: 12),
          SearchBox(
            placeholder: 'Cari transaksi, merchant, atau nominal',
          ),
          SizedBox(height: 20),
          TransactionGroupWidget(
            group: TransactionGroupData(
              label: 'SENIN, 12 APR',
              items: [
                TransactionItem(
                  title: 'Lunch Meeting',
                  category: 'Food & Beverage',
                  amount: '-Rp 125.000',
                ),
                TransactionItem(
                  title: 'Gojek Airport',
                  category: 'Transport',
                  amount: '-Rp 85.000',
                  attachment: '+ Bill',
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          TransactionGroupWidget(
            group: TransactionGroupData(
              label: 'MINGGU, 11 APR',
              items: [
                TransactionItem(
                  title: 'Subscription Netflix',
                  category: 'Entertainment',
                  amount: '-Rp 186.000',
                ),
                TransactionItem(
                  title: 'Grocery Weekend',
                  category: 'Daily Needs',
                  amount: '-Rp 312.000',
                  attachment: '+ Foto',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.subtitle,
    required this.title,
    required this.trailing,
  });

  final String subtitle;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MockupColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: MockupColors.blueDark,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: MockupColors.blueDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

class AvatarBadge extends StatelessWidget {
  const AvatarBadge({super.key, required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MockupColors.blueDark, MockupColors.blueLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.footerLeft,
    required this.footerRight,
  });

  final String label;
  final String amount;
  final String footerLeft;
  final String footerRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [MockupColors.blueDark, MockupColors.mutedBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  footerLeft,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  footerRight,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MockupColors.borderBase.withOpacity(0.18)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MockupColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  const BarChart({super.key, required this.bars});

  final List<BarEntry> bars;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < bars.length; i++) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 120 * bars[i].percent,
                    decoration: BoxDecoration(
                      color: MockupColors.blueLight.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: MockupColors.mutedBlue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          bars[i].value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bars[i].label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: MockupColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (i != bars.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class CategoryBudgetRow extends StatelessWidget {
  const CategoryBudgetRow({super.key, required this.entry});

  final CategoryBudgetEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      color: MockupColors.borderBase.withOpacity(0.15),
                    ),
                    FractionallySizedBox(
                      widthFactor: entry.percent,
                      child: Container(
                        height: 6,
                        color: entry.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          entry.detail,
          style: const TextStyle(
            fontSize: 12,
            color: MockupColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class InsightButton extends StatelessWidget {
  const InsightButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: MockupColors.blueLight.withOpacity(0.12),
          foregroundColor: MockupColors.blueDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Lihat Insight Lengkap',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
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
        MiniButton(label: '📷'),
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
          const Text('🔍'),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: MockupColors.accentRed,
                  fontSize: 14,
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

  final List<String> items;
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
          color: MockupColors.borderBase.withOpacity(0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
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
                    Text(
                      items[i],
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
class MockupColors {
  static const Color blueDark = Color(0xFF1E3A8A);
  static const Color blueLight = Color(0xFF60A5FA);
  static const Color mutedBlue = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color borderBase = Color(0xFF94A3B8);
  static const Color pillBackground = Color(0x2894A3B8);
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
    this.attachment,
  });

  final String title;
  final String category;
  final String amount;
  final String? attachment;
}
