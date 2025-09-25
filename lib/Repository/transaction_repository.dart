
import 'package:track_expense/Database/app_database.dart';
import 'package:track_expense/Model/transaction_model.dart';

class TransactionRepository {
  
  Future<int> insertTransaction(TransactionModel txn) async {
    final db = await AppDatabase.instance.database;

    
    final data = txn.toMap();
    data.remove("id");

    return await db.insert("transactions", data);
  }

 
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query("transactions", orderBy: "date DESC");
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<int> updateTransaction(TransactionModel txn) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      "transactions",
      txn.toMap(),
      where: "id = ?",
      whereArgs: [txn.id],
    );
  }

 
  Future<int> deleteTransaction(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      "transactions",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
