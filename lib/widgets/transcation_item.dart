import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function(String p1) deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text("₹${transaction.amount.toStringAsFixed(0)}"),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 360
            ? TextButton.icon(
                style: TextButton.styleFrom(
                  primary: ThemeData.light().errorColor,
                ),
                onPressed: () => deleteTransaction(transaction.id),
                icon: const Icon(
                  Icons.delete,
                ),
                label: const Text("Delete"),
              )
            : IconButton(
                color: Theme.of(context).errorColor,
                icon: const Icon(
                  Icons.delete,
                ),
                onPressed: () => deleteTransaction(transaction.id),
              ),
      ),
    );
  }
}
