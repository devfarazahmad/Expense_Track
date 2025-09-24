



import 'package:flutter/foundation.dart';
import 'package:track_expense/Model/transaction_model.dart';
import 'package:track_expense/Repository/transaction_repository.dart';
import 'package:intl/intl.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  double get totalIncome => _transactions
      .where((t) => t.type == "Income")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == "Expense")
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  
  DateTime _tryParseDate(String? s) {
    if (s == null || s.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
    final formats = ['MMM d, yyyy', 'MMMM d, yyyy', 'yyyy-MM-dd', 'dd/MM/yyyy'];
    for (final f in formats) {
      try {
        return DateFormat(f).parse(s);
      } catch (_) {}
    }
    try {
      return DateTime.parse(s);
    } catch (_) {}
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  
  void _sortTransactions() {
    _transactions.sort((a, b) {
      final dateA = _tryParseDate(a.date);
      final dateB = _tryParseDate(b.date);
      final cmp = dateB.compareTo(dateA); 
      if (cmp != 0) return cmp;

   
      try {
        final idA = (a.id ?? 0) as int;
        final idB = (b.id ?? 0) as int;
        return idB.compareTo(idA);
      } catch (_) {
        return 0;
      }
    });
  }

  Future<void> fetchTransactions() async {
    _transactions = await _repository.getAllTransactions();
    _sortTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel txn) async {
  
    await _repository.insertTransaction(txn);


    _transactions.insert(0, txn);
    _sortTransactions();
    notifyListeners();

    
    await fetchTransactions();
  }

  Future<void> updateTransaction(TransactionModel txn) async {
  
    try {
      await ( _repository as dynamic ).updateTransaction(txn);
    } catch (_) {
      await _repository.insertTransaction(txn);
    }
    await fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _repository.deleteTransaction(id);
    await fetchTransactions();
  }
}
