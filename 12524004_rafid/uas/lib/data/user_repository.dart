import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:uas/data/local_expense_database.dart';
import 'package:uas/data/models.dart';

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

class UserRepository {
  UserRepository({LocalExpenseDatabase? database})
      : _database = database ?? LocalExpenseDatabase.instance;

  final LocalExpenseDatabase _database;

  Future<bool> hasAnyUser() => _database.hasAnyUser();

  Future<UserAccount> register({
    required String name,
    required String email,
    required String password,
    double initialBalance = 0,
  }) async {
    final existing = await _database.findUserByEmail(email);
    if (existing != null) {
      throw AuthException('Email sudah terdaftar.');
    }

    final hashed = _hashPassword(password);
    final user = UserAccount(
      name: name.trim(),
      email: email.trim(),
      passwordHash: hashed,
      initialBalance: initialBalance,
      createdAt: DateTime.now(),
    );

    final userId = await _database.insertUser(user);
    await _database.seedCategoriesForUser(userId);
    final created = await _database.getUserById(userId);
    if (created == null) {
      throw AuthException('Gagal membuat akun baru.');
    }
    return created;
  }

  Future<UserAccount> login({
    required String email,
    required String password,
  }) async {
    final user = await _database.findUserByEmail(email.trim());
    if (user == null) {
      throw AuthException('Akun tidak ditemukan.');
    }

    final hashed = _hashPassword(password);
    if (hashed != user.passwordHash) {
      throw AuthException('Password yang kamu masukkan salah.');
    }

    return user;
  }

  String _hashPassword(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
