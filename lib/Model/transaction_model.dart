class TransactionModel {
  final int? id;
  final String type; // income, expense, transfer
  final double amount;
  final String note;
  final String date;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'note': note,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      note: map['note'],
      date: map['date'],
    );
  }
}
