import 'package:intl/intl.dart';
import 'package:oraboros/src/lib/db/db_helper.dart';

enum TransactionType { expense, income }

class Transactions {
  final int? id;
  late TransactionType type;
  final double amount;
  final int? categoryId;
  final String? category;
  final String? description;
  late DateTime? createdAt;

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
      'category': category,
      'category_id': categoryId,
      'description': description,
      'created_at': createdAt,
    };
  }

  Map<String, dynamic> toMapInsert() {
    var map = {
      'type': type.name,
      'amount': amount,
      'category_id': categoryId,
      'description': description,
    };

    if (createdAt != null) {
      map['created_at'] =
          DateFormat(sqliteDefaultDateFormat).format(createdAt!);
    }

    return map;
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
        id: map['id'],
        type: TransactionType.values.singleWhere((e) => e.name == map['type']),
        amount: (map['amount'] as num).toDouble(),
        categoryId: map['category_id'],
        category: map['category'],
        description: map['description'],
        createdAt: DateFormat(sqliteDefaultDateFormat)
            .parseUTC(map['created_at'].toString())
            .toLocal());
  }
}
