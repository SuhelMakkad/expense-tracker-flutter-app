import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './transcation_item.dart';
import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> transactions;
  final Function(int) deleteExpense;

  ExpenseList(
    this.transactions,
    this.deleteExpense,
  );

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: ((context, constraints) {
              return Column(
                children: [
                  Text(
                    "No data avialabe",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              Expense transaction = transactions[index];
              return ExpenseItem(
                  transaction: transaction, deleteExpense: deleteExpense);
            },
            itemCount: transactions.length,
          );
  }
}
