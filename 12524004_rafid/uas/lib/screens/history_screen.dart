part of 'package:uas/main.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.repository});

  final ExpenseRepository repository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final groups = _groupTransactions(repository.transactions);
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeader(
                subtitle: 'Laporan',
                title: 'History',
              trailing: AddButton(
                  onPressed: () => debugPrint(
                    'Gunakan layar Dashboard untuk tambah transaksi.',
                  ),
                ),
              ),
              const FilterTabs(
                tabs: ['Minggu', 'Bulan', 'Tahun'],
                activeIndex: 0,
              ),
              const SizedBox(height: 12),
              const FilterRow(
                filters: [
                  FilterChipData(label: 'Kategori', value: 'Semua'),
                  FilterChipData(label: 'Metode', value: 'Semua'),
                ],
              ),
              const SizedBox(height: 12),
              const SearchBox(
                placeholder: 'Cari transaksi, merchant, atau nominal',
              ),
              const SizedBox(height: 20),
              if (groups.isEmpty)
                const _EmptyHistoryMessage()
              else
                ...[
                  for (var i = 0; i < groups.length; i++) ...[
                    TransactionGroupWidget(group: groups[i]),
                    if (i != groups.length - 1) const SizedBox(height: 18),
                  ],
                ],
            ],
          ),
        );
      },
    );
  }

  List<TransactionGroupData> _groupTransactions(
    List<ExpenseTransaction> transactions,
  ) {
    final map = <String, List<TransactionItem>>{};
    for (final tx in transactions) {
      final dateLabel = _formatDate(tx.date);
      final list = map.putIfAbsent(dateLabel, () => []);
      final amountPrefix =
          tx.type == TransactionType.expense ? '-' : '+';
      list.add(
        TransactionItem(
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
          amount: '$amountPrefix${CurrencyFormatter.formatFull(tx.amount)}',
          isIncome: tx.type == TransactionType.income,
          attachment: tx.type == TransactionType.income ? '+ Income' : null,
        ),
      );
    }
    final groups = map.entries
        .map(
          (entry) => TransactionGroupData(
            label: entry.key,
            items: entry.value,
          ),
        )
        .toList();
    groups.sort((a, b) => _parseDate(b.label).compareTo(_parseDate(a.label)));
    return groups;
  }

  String _formatDate(DateTime date) {
    final weekday = [
      'SENIN',
      'SELASA',
      'RABU',
      'KAMIS',
      'JUMAT',
      'SABTU',
      'MINGGU'
    ][date.weekday - 1];
    return '$weekday, ${date.day} ${_monthName(date.month)}';
  }

  DateTime _parseDate(String label) {
    try {
      final parts = label.split(', ');
      final dayParts = parts.last.split(' ');
      final day = int.parse(dayParts[0]);
      final month = _monthIndex(dayParts[1]);
      final now = DateTime.now();
      return DateTime(now.year, month, day);
    } catch (_) {
      return DateTime.now();
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MEI',
      'JUN',
      'JUL',
      'AGU',
      'SEP',
      'OKT',
      'NOV',
      'DES',
    ];
    return months[month];
  }

  int _monthIndex(String abbrev) {
    const map = {
      'JAN': 1,
      'FEB': 2,
      'MAR': 3,
      'APR': 4,
      'MEI': 5,
      'JUN': 6,
      'JUL': 7,
      'AGU': 8,
      'SEP': 9,
      'OKT': 10,
      'NOV': 11,
      'DES': 12,
    };
    return map[abbrev.toUpperCase()] ?? DateTime.now().month;
  }
}

class _EmptyHistoryMessage extends StatelessWidget {
  const _EmptyHistoryMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: const [
          Icon(Icons.history, size: 48, color: MockupColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'Belum ada transaksi tercatat.',
            style: TextStyle(
              fontSize: 14,
              color: MockupColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
