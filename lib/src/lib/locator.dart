import 'package:get_it/get_it.dart';
import 'package:oraboros/src/lib/db/db_helper.dart';
import 'package:oraboros/src/service/category.service.dart';
import 'package:oraboros/src/service/transaction.service.dart';
import 'package:sqflite/sqflite.dart';

final GetIt locator = GetIt.instance;

setupLocator() async {
  final db = await DBHelper().database;

  locator.registerLazySingleton<Database>(() => db);
  locator.registerLazySingleton<TransactionService>(() => TransactionService(db: db));
  locator.registerLazySingleton<CategoryService>(() => CategoryService(db: db));
}
