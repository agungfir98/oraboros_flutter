import 'package:intl/intl.dart';

enum TransactionType { expense, income }

class Transactions {
  final int? id;
  final TransactionType type;
  final double amount;
  final int? categoryId;
  final String? category;
  final String? description;
  final DateTime? createdAt;

  Transactions({
    this.id,
    this.type = TransactionType.expense,
    required this.amount,
    this.categoryId,
    this.category,
    this.description,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'category_id': categoryId,
      'description': description,
      'created_at': createdAt,
    };
  }

  Map<String, dynamic> toMapInsert() {
    return {
      'type': type.name,
      'amount': amount,
      'category_id': categoryId,
      'description': description,
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      id: map['id'],
      type: TransactionType.values
          .firstWhere((e) => e.name == map['type'] as String),
      amount: (map['amount'] as num).toDouble(),
      categoryId: map['category_id'],
      category: map['category'],
      description: map['description'],
      createdAt: map['created_at'] != null
          ? DateFormat("yyyy-MM-dd HH:mm:ss")
              .parseUTC(map['created_at'])
              .toLocal()
          : null,
    );
  }
}
