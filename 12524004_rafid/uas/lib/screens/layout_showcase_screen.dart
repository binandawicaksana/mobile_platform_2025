part of 'package:uas/main.dart';

class LayoutShowcaseScreen extends StatelessWidget {
  const LayoutShowcaseScreen({super.key, required this.repository});

  final ExpenseRepository repository;

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

    final totalExpense = repository.totalExpense;
    final totalIncome = repository.totalIncome;
    final balance = repository.currentBalance;
    final highlights = [
      _ShowcaseHighlight(
        title: 'Total Pengeluaran',
        value: CurrencyFormatter.formatFull(totalExpense),
        subtitle: 'Dari ${repository.transactions.length} transaksi',
        color: MockupColors.blueDark,
      ),
      _ShowcaseHighlight(
        title: 'Saldo Bersih',
        value: CurrencyFormatter.formatFull(balance),
        subtitle:
            'Pemasukan ${CurrencyFormatter.formatCompact(totalIncome)}',
        color: MockupColors.accentGreen,
      ),
    ];

    final activities = repository.transactions
        .take(5)
        .map(
          (tx) => _ShowcaseActivityData(
            title: tx.title,
            category: repository.categories
                .firstWhere(
                  (c) => c.id == tx.categoryId,
                  orElse: () => ExpenseCategory(
                    id: tx.categoryId,
                    name: tx.categoryId,
                    shortLabel: tx.categoryId,
                    budget: 0,
                    color: MockupColors.textSecondary,
                  ),
                )
                .name,
            amount:
                '${tx.type == TransactionType.expense ? '-' : '+'}${CurrencyFormatter.formatFull(tx.amount)}',
            time: _formatTime(tx.date),
            accent: tx.type == TransactionType.expense
                ? MockupColors.accentOrange
                : MockupColors.accentGreen,
          ),
        )
        .toList();

    final summaries = repository.categorySummaries();
    final categories = _mapCategoryCharts(summaries);

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
                  const _QuickActionList(
                    key: ValueKey('layout-quick-actions'),
                    actions: quickActions,
                  ),
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
    debugPrint(message);
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final dayLabel = difference.inDays == 0
        ? 'Hari ini'
        : difference.inDays == 1
            ? 'Kemarin'
            : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    final timeLabel =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$dayLabel · $timeLabel';
  }

  List<_ShowcaseCategoryData> _mapCategoryCharts(
    List<CategorySpendingSummary> summaries,
  ) {
    if (summaries.isEmpty) {
      return const [
        _ShowcaseCategoryData(
          name: 'Belum ada',
          total: 'Rp 0',
          icon: Icons.category_outlined,
          color: MockupColors.textSecondary,
        ),
      ];
    }
    return summaries
        .map(
          (summary) => _ShowcaseCategoryData(
            name: summary.category.name,
            total: CurrencyFormatter.formatCompact(summary.spent),
            icon: _iconForCategory(summary.category.id),
            color: summary.category.color,
          ),
        )
        .toList();
  }

  IconData _iconForCategory(String categoryId) {
    final lower = categoryId.toLowerCase();
    if (lower.contains('food') ||
        lower.contains('makan') ||
        lower.contains('minum')) {
      return Icons.restaurant;
    }
    if (lower.contains('transport') ||
        lower.contains('bensin') ||
        lower.contains('parkir') ||
        lower.contains('ojek')) {
      return Icons.directions_car;
    }
    if (lower.contains('tagihan') ||
        lower.contains('bill') ||
        lower.contains('listrik') ||
        lower.contains('internet')) {
      return Icons.receipt_long;
    }
    if (lower.contains('belanja') || lower.contains('shopping')) {
      return Icons.shopping_bag;
    }
    return Icons.category_outlined;
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
    required this.user,
  });

  final int currentIndex;
  final ValueChanged<int> onNavigate;
  final VoidCallback onLogout;
  final UserAccount? user;

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              color: MockupColors.blueDark,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    child: Text(
                      (user?.name.isNotEmpty == true ? user!.name[0] : '?').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Pengguna',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '-',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
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
              data.amount.startsWith('+')
                  ? Icons.trending_up
                  : Icons.trending_down,
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
  const AddButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14);
    return Material(
      color: MockupColors.blueDark,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
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
    const double chartHeight = 160;
    const double barMaxHeight = 120;
    return SizedBox(
      height: chartHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < bars.length; i++) ...[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: barMaxHeight * bars[i].percent.clamp(0.0, 1.0),
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
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.1,
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

enum AuthMode { login, register }

class AuthFormData {
  const AuthFormData({
    required this.mode,
    required this.email,
    required this.password,
    this.fullName,
    this.confirmPassword,
    this.initialBalance,
  });

  final AuthMode mode;
  final String? fullName;
  final String email;
  final String password;
  final String? confirmPassword;
  final double? initialBalance;
}

class BalanceActionRow extends StatelessWidget {
  const BalanceActionRow({
    super.key,
    this.onAddTransaction,
    this.onSetInitialBalance,
  });

  final Future<void> Function()? onAddTransaction;
  final Future<void> Function()? onSetInitialBalance;

  @override
  Widget build(BuildContext context) {
    Widget buildButton({
      required IconData icon,
      required String label,
      Future<void> Function()? handler,
    }) {
      return OutlinedButton.icon(
        onPressed: handler == null ? null : () => handler(),
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          foregroundColor: MockupColors.blueDark,
          side: BorderSide(color: MockupColors.blueDark.withOpacity(0.2)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: buildButton(
            icon: Icons.receipt_long,
            label: 'Transaksi Baru',
            handler: onAddTransaction,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildButton(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Atur Saldo Awal',
            handler: onSetInitialBalance,
          ),
        ),
      ],
    );
  }
}
