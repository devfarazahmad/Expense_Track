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
}
