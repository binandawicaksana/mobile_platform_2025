import 'package:flutter/material.dart';

enum TransactionType { income, expense }

TransactionType transactionTypeFromString(String value) {
  switch (value) {
    case 'income':
      return TransactionType.income;
    case 'expense':
    default:
      return TransactionType.expense;
  }
}

String transactionTypeToString(TransactionType type) {
  return type == TransactionType.income ? 'income' : 'expense';
}

class ExpenseTransaction {
  const ExpenseTransaction({
    this.id,
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.date,
    this.type = TransactionType.expense,
  });

  final int? id;
  final String title;
  final String categoryId;
  final double amount;
  final DateTime date;
  final TransactionType type;

  ExpenseTransaction copyWith({
    int? id,
    String? title,
    String? categoryId,
    double? amount,
    DateTime? date,
    TransactionType? type,
  }) {
    return ExpenseTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  factory ExpenseTransaction.fromMap(Map<String, Object?> map) {
    return ExpenseTransaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      categoryId: map['category_id'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      type: transactionTypeFromString(map['type'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'category_id': categoryId,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
      'type': transactionTypeToString(type),
    };
  }
}

class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.shortLabel,
    required this.budget,
    required this.color,
    this.userId,
  });

  final String id;
  final String name;
  final String shortLabel;
  final double budget;
  final Color color;
  final int? userId;

  ExpenseCategory copyWith({
    String? id,
    String? name,
    String? shortLabel,
    double? budget,
    Color? color,
    int? userId,
  }) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      shortLabel: shortLabel ?? this.shortLabel,
      budget: budget ?? this.budget,
      color: color ?? this.color,
      userId: userId ?? this.userId,
    );
  }

  factory ExpenseCategory.fromMap(Map<String, Object?> map) {
    return ExpenseCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      shortLabel: map['short_label'] as String,
      budget: (map['budget'] as num).toDouble(),
      color: Color(map['color'] as int),
      userId: map['user_id'] as int?,
    );
  }

  Map<String, Object?> toMap({int? ownerId}) {
    return {
      'id': id,
      'name': name,
      'short_label': shortLabel,
      'budget': budget,
      'color': color.toARGB32(),
      'user_id': ownerId ?? userId,
    };
  }
}

class CategorySpendingSummary {
  const CategorySpendingSummary({
    required this.category,
    required this.spent,
  });

  final ExpenseCategory category;
  final double spent;

  double get budgetUsage => category.budget == 0
      ? 0
      : (spent / category.budget).clamp(0, 1).toDouble();
}

class UserAccount {
  const UserAccount({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.initialBalance,
    required this.createdAt,
  });

  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final double initialBalance;
  final DateTime createdAt;

  UserAccount copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    double? initialBalance,
    DateTime? createdAt,
  }) {
    return UserAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      initialBalance: initialBalance ?? this.initialBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserAccount.fromMap(Map<String, Object?> map) {
    return UserAccount(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      initialBalance: (map['initial_balance'] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['created_at'] as num).toInt(),
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'initial_balance': initialBalance,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}
