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

  void _onItemSelected(int index) {
    setState(() => _currentIndex = index);
  }

  void _handleAuthSuccess() {
    setState(() => _isAuthenticated = true);
  }

  void _toggleAuthMode() {
    setState(() => _isLoginMode = !_isLoginMode);
  }

  void _handleLogout() {
    setState(() {
      _isAuthenticated = false;
      _isLoginMode = true;
      _currentIndex = 0;
    });
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const ScanBillScreen();
      case 2:
        return const HistoryScreen();
      case 3:
        return const LayoutShowcaseScreen();
      default:
        return const DashboardScreen();
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
    required this.onLogout,
  });

  final Widget screen;
  final ValueChanged<int> onItemSelected;
  final int currentIndex;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: _AppDrawer(
        currentIndex: currentIndex,
        onNavigate: onItemSelected,
        onLogout: onLogout,
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
  const StatusBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Row(
        children: [
          if (onMenuTap != null)
            IconButton(
              onPressed: onMenuTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.menu,
                size: 20,
                color: MockupColors.textSecondary,
              ),
            ),
          if (onMenuTap != null) const SizedBox(width: 8),
          const Text(
            '09:41',
            style: TextStyle(
              fontSize: 12,
              color: MockupColors.textSecondary,
            ),
          ),
          const Spacer(),
          const Text(
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

class LayoutShowcaseScreen extends StatelessWidget {
  const LayoutShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const quickActions = <_QuickActionData>[
      _QuickActionData(
        label: 'Set Budget',
        icon: Icons.account_balance_wallet_outlined,
        color: MockupColors.accentPurple,
      ),
      _QuickActionData(
        label: 'Upload Nota',
        icon: Icons.receipt_long,
        color: MockupColors.accentOrange,
      ),
      _QuickActionData(
        label: 'Tambah Catatan',
        icon: Icons.edit_note,
        color: MockupColors.blueDark,
      ),
      _QuickActionData(
        label: 'Tag Tim',
        icon: Icons.group_add,
        color: MockupColors.accentGreen,
      ),
    ];

    const highlights = <_ShowcaseHighlight>[
      _ShowcaseHighlight(
        title: 'Total Pengeluaran',
        value: 'Rp 2,8 jt',
        subtitle: '+12% dari bulan lalu',
        color: MockupColors.blueDark,
      ),
      _ShowcaseHighlight(
        title: 'Anggaran Tersisa',
        value: 'Rp 1,2 jt',
        subtitle: 'Untuk 9 hari ke depan',
        color: MockupColors.accentGreen,
      ),
    ];

    const activities = <_ShowcaseActivityData>[
      _ShowcaseActivityData(
        title: 'Bayar sewa kantor',
        category: 'Operasional',
        amount: '-Rp 2.400.000',
        time: 'Hari ini · 09:20',
        accent: MockupColors.accentOrange,
      ),
      _ShowcaseActivityData(
        title: 'Langganan Figma',
        category: 'Software',
        amount: '-Rp 450.000',
        time: 'Kemarin · 15:03',
        accent: MockupColors.accentPurple,
      ),
      _ShowcaseActivityData(
        title: 'Bonus proyek',
        category: 'Pemasukan',
        amount: '+Rp 3.000.000',
        time: 'Kemarin · 10:11',
        accent: MockupColors.accentGreen,
      ),
    ];

    const categories = <_ShowcaseCategoryData>[
      _ShowcaseCategoryData(
        name: 'Transport',
        total: 'Rp 320 rb',
        icon: Icons.directions_car,
        color: MockupColors.accentPurple,
      ),
      _ShowcaseCategoryData(
        name: 'Langganan',
        total: 'Rp 450 rb',
        icon: Icons.subscriptions,
        color: MockupColors.accentOrange,
      ),
      _ShowcaseCategoryData(
        name: 'Makan',
        total: 'Rp 780 rb',
        icon: Icons.restaurant,
        color: MockupColors.accentRed,
      ),
      _ShowcaseCategoryData(
        name: 'Hiburan',
        total: 'Rp 215 rb',
        icon: Icons.movie_outlined,
        color: MockupColors.blueLight,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: MockupColors.blueDark,
        title: const Text(
          'Layout Explorer',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            tooltip: 'Segarkan data',
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                _showActionMessage(context, 'Data terbaru sudah disinkronkan'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 320;
                      final cardWidth = isWide
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final highlight in highlights)
                            SizedBox(
                              width: cardWidth,
                              child: _LayoutHighlightCard(data: highlight),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const _SectionTitle('Aktivitas Terbaru'),
                  const SizedBox(height: 12),
                  const _QuickActionList(actions: quickActions),
                  const SizedBox(height: 16),
                  ...activities.map(
                    (activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LayoutActivityTile(data: activity),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const _SectionTitle('Kategori Populer'),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _LayoutCategoryTile(data: categories[index]),
                childCount: categories.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  void _showActionMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _LayoutHighlightCard extends StatelessWidget {
  const _LayoutHighlightCard({required this.data});

  final _ShowcaseHighlight data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: data.color.withOpacity(0.08),
        border: Border.all(
          color: MockupColors.borderBase.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 13,
              color: MockupColors.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            data.value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: data.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: MockupColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.currentIndex,
    required this.onNavigate,
    required this.onLogout,
  });

  final int currentIndex;
  final ValueChanged<int> onNavigate;
  final VoidCallback onLogout;

  static const _items = [
    _DrawerItem(
      label: 'Dashboard',
      icon: Icons.space_dashboard_outlined,
    ),
    _DrawerItem(
      label: 'Scan Bill',
      icon: Icons.qr_code_scanner,
    ),
    _DrawerItem(
      label: 'History',
      icon: Icons.receipt_long,
    ),
    _DrawerItem(
      label: 'Layouts',
      icon: Icons.grid_view,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: MockupColors.blueDark,
                child: Text(
                  'RA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              title: Text(
                'Rafid Akmal',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('rafid.akmal@contoh.id'),
            ),
            const Divider(),
            for (var i = 0; i < _items.length; i++)
              ListTile(
                leading: Icon(
                  _items[i].icon,
                  color: i == currentIndex
                      ? MockupColors.blueDark
                      : MockupColors.textSecondary,
                ),
                title: Text(
                  _items[i].label,
                  style: TextStyle(
                    fontWeight: i == currentIndex ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: i == currentIndex,
                onTap: () {
                  Navigator.of(context).pop();
                  onNavigate(i);
                },
              ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem {
  const _DrawerItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _QuickActionList extends StatelessWidget {
  const _QuickActionList({super.key, required this.actions});

  final List<_QuickActionData> actions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _QuickActionCard(data: actions[index]);
        },
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.data});

  final _QuickActionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: data.color.withOpacity(0.08),
        border: Border.all(
          color: data.color.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data.icon,
              color: data.color,
              size: 18,
            ),
          ),
          const Spacer(),
          Text(
            data.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: MockupColors.blueDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _LayoutActivityTile extends StatelessWidget {
  const _LayoutActivityTile({required this.data});

  final _ShowcaseActivityData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(
          color: MockupColors.borderBase.withOpacity(0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              data.amount.startsWith('+') ? Icons.trending_up : Icons.trending_down,
              color: data.accent,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: MockupColors.blueDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.category} · ${data.time}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: MockupColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              data.amount,
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: data.amount.startsWith('+')
                    ? MockupColors.accentGreen
                    : MockupColors.accentRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayoutCategoryTile extends StatelessWidget {
  const _LayoutCategoryTile({required this.data});

  final _ShowcaseCategoryData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(
          color: MockupColors.borderBase.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              data.icon,
              color: data.color,
            ),
          ),
          const Spacer(),
          Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MockupColors.blueDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.total,
            style: const TextStyle(
              fontSize: 12,
              color: MockupColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MockupColors.blueDark,
      ),
    );
  }
}

class _ShowcaseHighlight {
  const _ShowcaseHighlight({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;
}

class _ShowcaseActivityData {
  const _ShowcaseActivityData({
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
    required this.accent,
  });

  final String title;
  final String category;
  final String amount;
  final String time;
  final Color accent;
}

class _ShowcaseCategoryData {
  const _ShowcaseCategoryData({
    required this.name,
    required this.total,
    required this.icon,
    required this.color,
  });

  final String name;
  final String total;
  final IconData icon;
  final Color color;
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.05,
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
