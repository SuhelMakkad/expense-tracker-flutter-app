import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'adaptive_button.dart';

import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense) addExpense;

  NewExpense(this.addExpense);

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
  }

  void _handleSubmit() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    var newExpense = Expense(
      title: enteredTitle,
      amount: enteredAmount,
      date: (_selectedDate as DateTime),
    );

    widget.addExpense(newExpense);
    // _setExpenseToLocal(newExpense);

    Navigator.of(context).pop();
  }

  // void _setExpenseToLocal(Expense transaction) async {
  //   var prefs = await SharedPreferences.getInstance();
  // }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                controller: _titleController,
                onSubmitted: (_) => _handleSubmit(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _handleSubmit(),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "No Date Chosen!"
                            : "Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime).toString()}",
                      ),
                    ),
                    AdaptiveButton("Choose Date", _presentDatePicker),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text("Add Expense"),
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
