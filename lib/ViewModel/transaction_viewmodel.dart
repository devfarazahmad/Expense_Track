// import 'package:flutter/foundation.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:track_expense/Repository/transaction_repository.dart';


// class TransactionViewModel extends ChangeNotifier {
//   final TransactionRepository _repository = TransactionRepository();

//   List<TransactionModel> _transactions = [];
//   List<TransactionModel> get transactions => _transactions;

//   double get totalIncome => _transactions
//       .where((t) => t.type == "Income")
//       .fold(0, (sum, t) => sum + t.amount);

//   double get totalExpense => _transactions
//       .where((t) => t.type == "Expense")
//       .fold(0, (sum, t) => sum + t.amount);

//   double get totalBalance => totalIncome - totalExpense;

//   Future<void> fetchTransactions() async {
//     _transactions = await _repository.getAllTransactions();
//     notifyListeners();
//   }

//   Future<void> addTransaction(TransactionModel txn) async {
//     await _repository.insertTransaction(txn);
//     await fetchTransactions();
//   }
// }



// import 'package:flutter/foundation.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:track_expense/Repository/transaction_repository.dart';

// class TransactionViewModel extends ChangeNotifier {
//   final TransactionRepository _repository = TransactionRepository();

//   List<TransactionModel> _transactions = [];
//   List<TransactionModel> get transactions => _transactions;

//   // Income total
//   double get totalIncome => _transactions
//       .where((t) => t.type == "Income")
//       .fold(0, (sum, t) => sum + t.amount);

//   // Expense total
//   double get totalExpense => _transactions
//       .where((t) => t.type == "Expense")
//       .fold(0, (sum, t) => sum + t.amount);

//   // Balance
//   double get totalBalance => totalIncome - totalExpense;

//   // Fetch all
//   Future<void> fetchTransactions() async {
//     _transactions = await _repository.getAllTransactions();
//     notifyListeners();
//   }

//   // Add
//   Future<void> addTransaction(TransactionModel txn) async {
//     await _repository.insertTransaction(txn);
//     await fetchTransactions();
//   }

//   // Update
//   Future<void> updateTransaction(TransactionModel txn) async {
//     await _repository.updateTransaction(txn);
//     await fetchTransactions();
//   }

//   // Delete
//   Future<void> deleteTransaction(int id) async {
//     await _repository.deleteTransaction(id);
//     await fetchTransactions();
//   }
// }



// import 'package:flutter/foundation.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:track_expense/Repository/transaction_repository.dart';

// class TransactionViewModel extends ChangeNotifier {
//   final TransactionRepository _repository = TransactionRepository();

//   List<TransactionModel> _transactions = [];
//   List<TransactionModel> get transactions => _transactions;

//   double get totalIncome => _transactions
//       .where((t) => t.type == "Income")
//       .fold(0, (sum, t) => sum + t.amount);

//   double get totalExpense => _transactions
//       .where((t) => t.type == "Expense")
//       .fold(0, (sum, t) => sum + t.amount);

//   double get totalBalance => totalIncome - totalExpense;

//   Future<void> fetchTransactions() async {
//     _transactions = await _repository.getAllTransactions();
//     notifyListeners();
//   }

//   Future<void> addTransaction(TransactionModel txn) async {
//     await _repository.insertTransaction(txn);
//     await fetchTransactions();
//   }

//   Future<void> updateTransaction(TransactionModel txn) async {
//     await _repository.updateTransaction(txn);
//     await fetchTransactions();
//   }

//   Future<void> deleteTransaction(int id) async {
//     await _repository.deleteTransaction(id);
//     await fetchTransactions();
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:track_expense/Model/transaction_model.dart';
import 'package:track_expense/Repository/transaction_repository.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((t) => t.type == "Income")
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == "Expense")
      .fold(0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  Future<void> fetchTransactions() async {
    _transactions = await _repository.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel txn) async {
    await _repository.insertTransaction(txn);
    await fetchTransactions();
  }

  // ✅ FIXED: preserve history → insert instead of update
  Future<void> updateTransaction(TransactionModel txn) async {
    await _repository.insertTransaction(txn);
    await fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _repository.deleteTransaction(id);
    await fetchTransactions();
  }
}
