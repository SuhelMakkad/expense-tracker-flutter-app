const String tableExpense = 'transactions';

class ExpenseFields {
  static final List<String> values = [
    uid,
    id,
    title,
    amount,
    date,
  ];

  static const String uid = 'uid';
  static const String id = 'id';
  static const String title = 'isImportant';
  static const String amount = 'number';
  static const String date = 'title';
}

class Expense {
  final int? uid;
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    this.uid,
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  Expense copy({
    int? uid,
    String? id,
    String? title,
    double? amount,
    DateTime? date,
  }) {
    return Expense(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, Object?> toJson() {
    return {
      ExpenseFields.id: id,
      ExpenseFields.title: title,
      ExpenseFields.amount: amount,
      ExpenseFields.date: date.toIso8601String(),
    };
  }

  static Expense fromJson(Map<String, Object?> json) {
    return Expense(
      id: json[ExpenseFields.id] as String,
      title: json[ExpenseFields.title] as String,
      amount: json[ExpenseFields.amount] as double,
      date: DateTime.parse(json[ExpenseFields.date] as String),
    );
  }
}
