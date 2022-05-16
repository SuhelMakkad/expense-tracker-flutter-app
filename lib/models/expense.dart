const String tableExpense = 'expenses';

class ExpenseFields {
  static final List<String> values = [
    id,
    title,
    amount,
    date,
  ];

  static const String id = 'id';
  static const String title = 'title';
  static const String amount = 'amount';
  static const String date = 'date';
}

class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  Expense copy({
    int? id,
    String? title,
    double? amount,
    DateTime? date,
  }) {
    return Expense(
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
      id: json[ExpenseFields.id] as int,
      title: json[ExpenseFields.title] as String,
      amount: double.parse('${json[ExpenseFields.amount]}'),
      date: DateTime.parse(json[ExpenseFields.date] as String),
    );
  }
}
