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
}
