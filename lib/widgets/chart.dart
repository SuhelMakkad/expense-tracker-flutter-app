import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Expense> recentExpenses;

  Chart(this.recentExpenses);

  List<Map<String, Object>> get groupedExpenses {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentExpenses.length; i++) {
        final transaction = recentExpenses[i];

        if (DateFormat.yMEd().format(transaction.date) ==
            DateFormat.yMEd().format(weekDay)) {
          totalSum += transaction.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).toString(),
        'amount': totalSum.toStringAsFixed(0),
      };
    }).reversed.toList();
  }

  double get totalAmountSpentInAWeek {
    return groupedExpenses.fold(0, (previousValue, transaction) {
      return previousValue += double.parse(transaction["amount"] as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: groupedExpenses.map((transaction) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                transaction['day'] as String,
                double.parse(transaction['amount'] as String),
                totalAmountSpentInAWeek,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
