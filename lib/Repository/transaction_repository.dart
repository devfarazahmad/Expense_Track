import 'package:track_expense/Database/app_database.dart';
import 'package:track_expense/Model/transaction_model.dart';


class TransactionRepository {
  Future<int> insertTransaction(TransactionModel txn) async {
    final db = await AppDatabase.instance.database;
    return await db.insert("transactions", txn.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query("transactions", orderBy: "date DESC");
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }
}
