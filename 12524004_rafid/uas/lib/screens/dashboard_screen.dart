part of 'package:uas/main.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.repository,
    required this.onAddTransaction,
    required this.onSetInitialBalance,
  });

  final ExpenseRepository repository;
  final Future<void> Function() onAddTransaction;
  final Future<void> Function() onSetInitialBalance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final summaries = repository.categorySummaries()
          ..sort((a, b) => b.spent.compareTo(a.spent));
        final bars = _buildCategoryBars(summaries, repository.totalExpense);
        final budgets = _buildBudgetEntries(summaries);
        final balanceText =
            CurrencyFormatter.formatFull(repository.currentBalance);
        final expenseText =
            CurrencyFormatter.formatFull(repository.totalExpense);
        final isInitialized = repository.isInitialized;
        final canAddTransaction =
            isInitialized && repository.categories.isNotEmpty;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeader(
                subtitle: 'Halo kembali,',
                title: repository.currentUser?.name ?? 'Pengguna',
                trailing: AddButton(
                  onPressed:
                      canAddTransaction ? () => onAddTransaction() : null,
                ),
              ),
              SummaryCard(
                label: 'Saldo Bersih',
                amount: balanceText,
                footerLeft: 'Total Pengeluaran',
                footerRight: '$expenseText bulan ini',
              ),
              const SizedBox(height: 12),
              BalanceActionRow(
                onAddTransaction: canAddTransaction && isInitialized
                    ? () => onAddTransaction()
                    : null,
                onSetInitialBalance: isInitialized
                    ? () => onSetInitialBalance()
                    : null,
              ),
              const SizedBox(height: 18),
              InfoCard(
                title: 'Pengeluaran per Kategori',
                child: !isInitialized
                    ? const _EmptyDashboardMessage(
                        message: 'Memuat data transaksi...',
                      )
                    : bars.isEmpty
                        ? const _EmptyDashboardMessage(
                            message: 'Belum ada pengeluaran yang tercatat.',
                          )
                        : BarChart(bars: bars),
              ),
              const SizedBox(height: 18),
              InfoCard(
                title: 'Anggaran Kategori',
                child: !isInitialized
                    ? const _EmptyDashboardMessage(
                        message: 'Memuat data anggaran...',
                      )
                    : budgets.isEmpty
                        ? const _EmptyDashboardMessage(
                            message: 'Belum ada kategori anggaran.',
                          )
                        : Column(
                            children: [
                              for (var i = 0; i < budgets.length; i++) ...[
                                CategoryBudgetRow(entry: budgets[i]),
                                if (i != budgets.length - 1)
                                  const SizedBox(height: 14),
                              ],
                            ],
                          ),
              ),
              const SizedBox(height: 20),
              const InsightButton(),
            ],
          ),
        );
      },
    );
  }

  List<BarEntry> _buildCategoryBars(
    List<CategorySpendingSummary> summaries,
    double totalExpense,
  ) {
    const order = ['Belanja', 'Makan & Minum', 'Tagihan Bulanan', 'Transportasi'];
    summaries.sort((a, b) {
      final aIndex = order.indexOf(a.category.name);
      final bIndex = order.indexOf(b.category.name);
      if (aIndex == -1 && bIndex == -1) {
        return a.category.name.compareTo(b.category.name);
      }
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });
    return summaries
        .map(
          (summary) {
            final spent = summary.spent;
            final percent = totalExpense <= 0
                ? 0.0
                : (spent / totalExpense).clamp(0.0, 1.0);
            final valueText = spent <= 0
                ? CurrencyFormatter.formatFull(0)
                : CurrencyFormatter.formatCompact(spent);
            return BarEntry(
              label: summary.category.shortLabel,
              value: valueText,
              percent: percent,
            );
          },
        )
        .toList();
  }

  List<CategoryBudgetEntry> _buildBudgetEntries(
    List<CategorySpendingSummary> summaries,
  ) {
    return summaries
        .map(
          (summary) => CategoryBudgetEntry(
            name: summary.category.name,
            detail:
                '${(summary.budgetUsage * 100).round()}% dari ${CurrencyFormatter.formatFull(summary.category.budget)}',
            percent: summary.budgetUsage,
            color: summary.category.color,
          ),
        )
        .toList();
  }
}

class _EmptyDashboardMessage extends StatelessWidget {
  const _EmptyDashboardMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: MockupColors.textSecondary,
        ),
      ),
    );
  }
}
