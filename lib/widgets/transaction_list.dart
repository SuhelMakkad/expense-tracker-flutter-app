import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './transcation_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) deleteTransaction;

  TransactionList(
    this.transactions,
    this.deleteTransaction,
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
              Transaction transaction = transactions[index];
              return TransactionItem(
                  transaction: transaction,
                  deleteTransaction: deleteTransaction);
            },
            itemCount: transactions.length,
          );
  }
}
