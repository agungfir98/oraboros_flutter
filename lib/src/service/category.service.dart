import 'package:oraboros/src/model/category.model.dart';
import 'package:sqflite/sqflite.dart';

class CategoryService {
  final String tableName = 'categories';
  final Database db;

  CategoryService({required this.db});

  Future<int> createCategory(Category payload) async {
    return await db.insert(
      tableName,
      payload.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> editCategory(Category payload) async {
    return await db.update(
      tableName,
      payload.toMap(),
      where: 'id = ?',
      whereArgs: [payload.id],
    );
  }

  Future<List<Category>> getCategories() async {
    final List<Map<String, Object?>> categoriesMap = await db.query(tableName);

    List<Category> categories = [];

    for (var categoryMap in categoriesMap) {
      var category = Category.fromMap(categoryMap);
      categories.add(Category(
        createdAt: category.createdAt,
        amount: category.amount,
        name: category.name,
        id: category.id,
      ));
    }

    return categories;
  }

  Future<void> removeCategory(String id) async {
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
