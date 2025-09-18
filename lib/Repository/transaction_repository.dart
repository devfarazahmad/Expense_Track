// import 'package:track_expense/Database/app_database.dart';
// import 'package:track_expense/Model/transaction_model.dart';


// class TransactionRepository {
//   Future<int> insertTransaction(TransactionModel txn) async {
//     final db = await AppDatabase.instance.database;
//     return await db.insert("transactions", txn.toMap());
//   }

//   Future<List<TransactionModel>> getAllTransactions() async {
//     final db = await AppDatabase.instance.database;
//     final result = await db.query("transactions", orderBy: "date DESC");
//     return result.map((e) => TransactionModel.fromMap(e)).toList();
//   }
// }

// import 'package:track_expense/Database/app_database.dart';
// import 'package:track_expense/Model/transaction_model.dart';

// class TransactionRepository {
//   // Insert Transaction
//   Future<int> insertTransaction(TransactionModel txn) async {
//     final db = await AppDatabase.instance.database;
//     return await db.insert("transactions", txn.toMap());
//   }

//   // Get All Transactions
//   Future<List<TransactionModel>> getAllTransactions() async {
//     final db = await AppDatabase.instance.database;
//     final result = await db.query("transactions", orderBy: "date DESC");
//     return result.map((e) => TransactionModel.fromMap(e)).toList();
//   }

//   // Update Transaction
//   Future<int> updateTransaction(TransactionModel txn) async {
//     final db = await AppDatabase.instance.database;
//     return await db.update(
//       "transactions",
//       txn.toMap(),
//       where: "id = ?",
//       whereArgs: [txn.id],
//     );
//   }

//   // Delete Transaction
//   Future<int> deleteTransaction(int id) async {
//     final db = await AppDatabase.instance.database;
//     return await db.delete(
//       "transactions",
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }
// }


import 'package:track_expense/Database/app_database.dart';
import 'package:track_expense/Model/transaction_model.dart';

class TransactionRepository {
  // Insert Transaction
  Future<int> insertTransaction(TransactionModel txn) async {
    final db = await AppDatabase.instance.database;

    // Remove id when inserting (let SQLite auto-increment it)
    final data = txn.toMap();
    data.remove("id");

    return await db.insert("transactions", data);
  }

  // Get All Transactions
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query("transactions", orderBy: "date DESC");
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  // Update Transaction
  Future<int> updateTransaction(TransactionModel txn) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      "transactions",
      txn.toMap(),
      where: "id = ?",
      whereArgs: [txn.id],
    );
  }

  // Delete Transaction
  Future<int> deleteTransaction(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(
      "transactions",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
