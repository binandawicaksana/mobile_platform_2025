part of 'package:uas/main.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({
    super.key,
    required this.categories,
    required this.initialType,
    required this.onSubmit,
  });

  final List<ExpenseCategory> categories;
  final TransactionType initialType;
  final Future<void> Function(ExpenseTransaction transaction) onSubmit;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategoryId;
  late TransactionType _type;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    if (widget.categories.isNotEmpty) {
      _selectedCategoryId = widget.categories.first.id;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final categoryId = _type == TransactionType.expense
        ? _selectedCategoryId
        : 'income';
    if (_type == TransactionType.expense && categoryId == null) {
      debugPrint('Kategori belum tersedia.');
      return;
    }

    final rawAmount = _amountController.text.trim().replaceAll('.', '');
    final parsedAmount = double.tryParse(
          rawAmount.replaceAll(',', '.'),
        ) ??
        0;

    if (parsedAmount <= 0) {
      debugPrint('Masukkan nominal yang valid.');
      return;
    }

    final navigator = Navigator.of(context);
    setState(() => _isSaving = true);
    final transaction = ExpenseTransaction(
      title: _titleController.text.trim(),
      amount: parsedAmount,
      categoryId: categoryId ?? 'income',
      date: DateTime.now(),
      type: _type,
    );

    try {
      await widget.onSubmit(transaction);
      if (!mounted) return;
      navigator.pop(true);
    } catch (error) {
      if (!mounted) return;
      debugPrint('Gagal menyimpan transaksi: $error');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MockupStandalonePage(
      title: 'Transaksi Baru',
      subtitle: 'Catat pemasukan atau pengeluaranmu.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nama Transaksi',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama transaksi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Nominal (Rp)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nominal wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            if (_type == TransactionType.expense) ...[
              DropdownButtonFormField<String>(
                key: ValueKey(
                  '${widget.categories.length}-${_selectedCategoryId ?? 'none'}',
                ),
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: widget.categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: widget.categories.isEmpty
                    ? null
                    : (value) => setState(() => _selectedCategoryId = value),
              ),
              if (widget.categories.isEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Belum ada kategori yang tersedia.',
                  style: TextStyle(
                    fontSize: 12,
                    color: MockupColors.textSecondary,
                  ),
                ),
              ],
            ] else ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MockupColors.borderBase.withOpacity(0.4),
                  ),
                ),
                child: const Text(
                  'Kategori tidak diperlukan untuk pemasukan.',
                  style: TextStyle(
                    fontSize: 12,
                    color: MockupColors.textSecondary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: TransactionType.values.map((type) {
                final bool isSelected = _type == type;
                return ChoiceChip(
                  label: Text(
                    type == TransactionType.expense
                        ? 'Pengeluaran'
                        : 'Pemasukan',
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _type = type);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _isSaving ? null : _handleSubmit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: MockupColors.blueDark,
              ),
              child: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class InitialBalanceScreen extends StatefulWidget {
  const InitialBalanceScreen({
    super.key,
    required this.initialValue,
    required this.onSubmit,
  });

  final double initialValue;
  final Future<void> Function(double value) onSubmit;

  @override
  State<InitialBalanceScreen> createState() => _InitialBalanceScreenState();
}

class _InitialBalanceScreenState extends State<InitialBalanceScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue > 0 ? widget.initialValue.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _parseValue(String input) {
    final sanitized = input.replaceAll(RegExp(r'[^0-9,\.]'), '');
    final normalized = sanitized.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  Future<void> _handleSubmit() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final parsed = _parseValue(_controller.text);
    final navigator = Navigator.of(context);
    setState(() => _isSaving = true);
    try {
      await widget.onSubmit(parsed);
      if (!mounted) return;
      navigator.pop(true);
    } catch (error) {
      if (!mounted) return;
      debugPrint('Gagal memperbarui saldo: $error');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MockupStandalonePage(
      title: 'Atur Saldo Awal',
      subtitle: 'Sesuaikan modal awalmu.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Saldo Awal (Rp)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nominal wajib diisi';
                }
                final parsed = _parseValue(value);
                if (parsed < 0) {
                  return 'Nominal tidak boleh negatif';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _isSaving ? null : _handleSubmit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: MockupColors.blueDark,
              ),
              child: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class MockupStandalonePage extends StatelessWidget {
  const MockupStandalonePage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: Column(
            children: [
              const StatusBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StandaloneHeader(title: title, subtitle: subtitle),
                      const SizedBox(height: 16),
                      child,
                    ],
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

class _StandaloneHeader extends StatelessWidget {
  const _StandaloneHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: MockupColors.blueDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: MockupColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PhoneSheetWrapper extends StatelessWidget {
  const PhoneSheetWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: FractionallySizedBox(
        heightFactor: 0.98,
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Material(
                color: Colors.transparent,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}










