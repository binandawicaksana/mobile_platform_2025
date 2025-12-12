import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:uas/data/models.dart';
import 'package:uas/theme/mockup_colors.dart';

class LocalExpenseDatabase {
  LocalExpenseDatabase._();

  static final LocalExpenseDatabase instance = LocalExpenseDatabase._();

  static const _dbName = 'expense_mockup.db';
  static const _dbVersion = 2;
  Database? _database;

  Future<Database> _openDatabase() async {
    await _ensureDatabaseFactory();
    if (_database != null) {
      return _database!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return _database!;
  }

  Future<void> _ensureDatabaseFactory() async {
    if (kIsWeb) return;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        initial_balance REAL NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories(
        id TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        short_label TEXT NOT NULL,
        budget REAL NOT NULL DEFAULT 0,
        color INTEGER NOT NULL,
        PRIMARY KEY (id, user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        category_id TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        date INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < _dbVersion) {
      await db.execute('DROP TABLE IF EXISTS transactions');
      await db.execute('DROP TABLE IF EXISTS categories');
      await db.execute('DROP TABLE IF EXISTS meta');
      await db.execute('DROP TABLE IF EXISTS users');
      await _onCreate(db, newVersion);
    }
  }

  Future<bool> hasAnyUser() async {
    final db = await _openDatabase();
    final result = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM users'),
    );
    return (result ?? 0) > 0;
  }

  Future<int> insertUser(UserAccount user) async {
    final db = await _openDatabase();
    return db.insert(
      'users',
      user.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<UserAccount?> getUserById(int id) async {
    final db = await _openDatabase();
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return UserAccount.fromMap(result.first);
  }

  Future<UserAccount?> findUserByEmail(String email) async {
    final db = await _openDatabase();
    final result = await db.query(
      'users',
      where: 'LOWER(email) = LOWER(?)',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return UserAccount.fromMap(result.first);
  }

  Future<void> updateInitialBalance(int userId, double value) async {
    final db = await _openDatabase();
    await db.update(
      'users',
      {'initial_balance': value},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<ExpenseCategory>> loadCategories(int userId) async {
    final db = await _openDatabase();
    final result = await db.query(
      'categories',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );
    return result.map(ExpenseCategory.fromMap).toList();
  }

  Future<void> seedCategoriesForUser(int userId) async {
    final db = await _openDatabase();
    final categories = _defaultCategories
        .map((category) => category.toMap(ownerId: userId))
        .toList();

    final batch = db.batch();
    for (final category in categories) {
      batch.insert('categories', category, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<ExpenseTransaction>> loadTransactions(int userId) async {
    final db = await _openDatabase();
    final result = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC, id DESC',
    );
    return result.map(ExpenseTransaction.fromMap).toList();
  }

  Future<void> insertTransaction(
    ExpenseTransaction transaction,
    int userId,
  ) async {
    final db = await _openDatabase();
    final data = transaction.toMap()
      ..remove('id')
      ..putIfAbsent('user_id', () => userId);
    await db.insert('transactions', data);
  }

  Future<void> deleteTransaction(int id, int userId) async {
    final db = await _openDatabase();
    await db.delete(
      'transactions',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  List<ExpenseCategory> get _defaultCategories => [
        ExpenseCategory(
          id: 'food',
          name: 'Makan & Minum',
          shortLabel: 'Mkn',
          budget: 2000000,
          color: MockupColors.accentOrange,
        ),
        ExpenseCategory(
          id: 'bills',
          name: 'Tagihan Bulanan',
          shortLabel: 'Tagihan',
          budget: 3000000,
          color: MockupColors.accentGreen,
        ),
        ExpenseCategory(
          id: 'transport',
          name: 'Transportasi',
          shortLabel: 'Transport',
          budget: 1500000,
          color: MockupColors.accentPurple,
        ),
        ExpenseCategory(
          id: 'shopping',
          name: 'Belanja',
          shortLabel: 'Belanja',
          budget: 1800000,
          color: MockupColors.blueLight,
        ),
        ExpenseCategory(
          id: 'other',
          name: 'Lain-lain',
          shortLabel: 'Lain',
          budget: 1000000,
          color: MockupColors.accentRed,
        ),
      ];
}
