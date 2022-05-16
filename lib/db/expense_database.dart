import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction.dart';

class ExpenseDatabase {
  static final ExpenseDatabase instance = ExpenseDatabase();

  static Database? _database;

  ExpenseDatabase();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('transaction.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableExpense (
  ${ExpenseFields.id} $textType,
  ${ExpenseFields.title} $textType,
  ${ExpenseFields.amount} $integerType,
  ${ExpenseFields.date} $textType,
  )
''');
  }

  Future<Expense> create(Expense transaction) async {
    final db = await instance.database;

    final uid = await db.insert(tableExpense, transaction.toJson());
    return transaction.copy(uid: uid);
  }

  Future<Expense> readExpense(int uid) async {
    final db = await instance.database;

    final maps = await db.query(
      tableExpense,
      columns: ExpenseFields.values,
      where: '${ExpenseFields.uid} = ?',
      whereArgs: [uid],
    );

    if (maps.isNotEmpty) {
      return Expense.fromJson(maps.first);
    } else {
      throw Exception('ID $uid not found');
    }
  }

  Future<List<Expense>> readAllExpense() async {
    final db = await instance.database;
    final result = await db.query(tableExpense);

    return result.map((json) => Expense.fromJson(json)).toList();
  }

  Future<int> update(Expense expense) async {
    final db = await instance.database;

    return db.update(
      tableExpense,
      expense.toJson(),
      where: '${ExpenseFields.uid} = ?',
      whereArgs: [expense.uid],
    );
  }

  Future<int> delete(int uid) async {
    final db = await instance.database;

    return await db.delete(
      tableExpense,
      where: '${ExpenseFields.uid} = ?',
      whereArgs: [uid],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
