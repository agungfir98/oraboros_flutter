import 'package:oraboros/src/model/transactions.model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class TransactionService {
  final String table = 'transactions';
  final Database db;

  TransactionService({required this.db});

  newIncome(Transactions payload) async {
    payload.type = TransactionType.income;
    await db.insert(table, payload.toMapInsert());
  }

  Future<List<Transactions>> getTransactions({
    int limit = 5,
    int offset = 0,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    List<Transactions> transactionList = [];

    startDate ??= DateTime.now().subtract(const Duration(days: 60));
    endDate ??= DateTime.now();

    var result = await db.rawQuery('''
SELECT 
    transactions.id AS id,
    transactions.type AS type,
    transactions.amount AS amount,
    categories.name AS category,
    transactions.description AS description,
    transactions.created_at AS created_at
FROM $table
LEFT JOIN categories ON transactions.category_id = categories.id
WHERE transactions.created_at BETWEEN ? AND ?
ORDER BY created_at DESC
LIMIT ? OFFSET ?;
''', [startDate.toIso8601String(), endDate.toIso8601String(), limit, offset]);

    for (var transaction in result) {
      transactionList.add(Transactions.fromMap(transaction));
    }

    return transactionList;
  }

  Future newExpense(Transactions payload) async {
    return await db.insert(table, payload.toMapInsert());
  }

  Future<Map<String, dynamic>> getBalance() async {
    List<Map<String, Object?>> result = await db.rawQuery('''
SELECT
  COUNT(CASE WHEN type = 'income' THEN 1 END) AS income_count,
  COUNT(CASE WHEN type = 'expense' THEN 1 END) AS expense_count,
  SUM(CASE when type = 'income' THEN amount else 0 END) AS total_income,
  SUM(CASE when type = 'expense' THEN amount else 0 END) AS total_expense,
  (SUM(CASE when type = 'income' THEN amount else 0 END) - SUM(CASE when type = 'expense' THEN amount else 0 END)) AS balance
FROM $table
''');
    return result.isNotEmpty ? result.first : {};
  }
}
