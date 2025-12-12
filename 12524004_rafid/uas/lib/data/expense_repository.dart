import 'package:flutter/foundation.dart';

import 'package:uas/data/local_expense_database.dart';
import 'package:uas/data/models.dart';

class ExpenseRepository extends ChangeNotifier {
  ExpenseRepository({LocalExpenseDatabase? database})
      : _database = database ?? LocalExpenseDatabase.instance;

  final LocalExpenseDatabase _database;

  List<ExpenseTransaction> _transactions = [];
  List<ExpenseCategory> _categories = [];
  UserAccount? _currentUser;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  UserAccount? get currentUser => _currentUser;

  List<ExpenseCategory> get categories => _categories;
  List<ExpenseTransaction> get transactions => _transactions;

  double get initialBalance => _currentUser?.initialBalance ?? 0;

  double get totalIncome => _transactions
      .where((tx) => tx.type == TransactionType.income)
      .fold(0, (sum, tx) => sum + tx.amount);

  double get totalExpense => _transactions
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0, (sum, tx) => sum + tx.amount);

  double get currentBalance => initialBalance + totalIncome - totalExpense;

  Future<void> clearUser() async {
    _currentUser = null;
    _transactions = [];
    _categories = [];
    _isInitialized = false;
    notifyListeners();
  }

  Future<void> setActiveUser(UserAccount user) async {
    _currentUser = user;
    await _loadUserData();
  }

  Future<void> refresh() async {
    await _loadUserData();
  }

  Future<void> addTransaction(ExpenseTransaction transaction) async {
    final user = _currentUser;
    if (user == null) {
      throw StateError('Tidak ada pengguna aktif.');
    }

    await _database.insertTransaction(transaction, user.id!);
    await _loadUserData();
  }

  Future<void> updateInitialBalance(double value) async {
    final user = _currentUser;
    if (user == null) {
      throw StateError('Tidak ada pengguna aktif.');
    }

    await _database.updateInitialBalance(user.id!, value);
    _currentUser = user.copyWith(initialBalance: value);
    notifyListeners();
  }

  List<CategorySpendingSummary> categorySummaries() {
    if (_categories.isEmpty) {
      return [];
    }

    return _categories
        .map(
          (category) => CategorySpendingSummary(
            category: category,
            spent: _transactions
                .where(
                  (tx) =>
                      tx.type == TransactionType.expense &&
                      tx.categoryId == category.id,
                )
                .fold(0.0, (sum, tx) => sum + tx.amount),
          ),
        )
        .toList();
  }

  Future<void> _loadUserData() async {
    final user = _currentUser;
    if (user == null) {
      await clearUser();
      return;
    }

    _categories = await _database.loadCategories(user.id!);
    if (_categories.isEmpty) {
      await _database.seedCategoriesForUser(user.id!);
      _categories = await _database.loadCategories(user.id!);
    }

    _transactions = await _database.loadTransactions(user.id!);
    _isInitialized = true;
    notifyListeners();
  }
}
