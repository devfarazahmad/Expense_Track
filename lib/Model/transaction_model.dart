
class TransactionModel {
  final int? id;
  final String type; // income, expense, transfer
  final String? category;
  final double amount;
  final String note;
  final String date;

  TransactionModel({
    this.id,
    required this.type,
    this.category,
    required this.amount,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'amount': amount,
      'note': note,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      category: map['category'],
      amount: map['amount'],
      note: map['note'],
      date: map['date'],
    );
  }

  TransactionModel copyWith({
    int? id,
    String? type,
    String? category,
    double? amount,
    String? note,
    String? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}
