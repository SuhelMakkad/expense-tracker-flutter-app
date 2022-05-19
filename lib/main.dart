import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './db/expense_database.dart';

import 'models/expense.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final isIOS = Platform.isIOS;

  List<Expense> _userExpense = [];
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    _initExpenses();
  }

  @override
  void dispose() {
    super.dispose();
    ExpenseDatabase.instance.close();
  }

  List<Expense> get _recentExpenses {
    return _userExpense.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _initExpenses() async {
    final storedExpenses = await ExpenseDatabase.instance.readAllExpense();
    setState(() {
      _userExpense = storedExpenses;
    });
  }

  void _addNewExpense(Expense transaction) async {
    transaction = await ExpenseDatabase.instance.create(transaction);
    print(transaction.toJson());
    setState(() {
      _userExpense.add(transaction);
    });
  }

  void _startAddNewExpenses(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
      builder: (_) {
        return NewExpense(_addNewExpense);
      },
    );
  }

  void _deleteExpense(int id) async {
    await ExpenseDatabase.instance.delete(id);

    setState(() {
      _userExpense.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
    double workingHeight,
    Widget transactionListWidget,
  ) {
    return [
      SizedBox(
        height: workingHeight * 0.2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Show Chart",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch.adaptive(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              },
            ),
          ],
        ),
      ),
      _showChart
          ? SizedBox(
              height: workingHeight * 0.8,
              child: Chart(_recentExpenses),
            )
          : transactionListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
    double workingHeight,
    Widget transactionListWidget,
  ) {
    return [
      SizedBox(
        height: workingHeight * 0.3,
        child: Chart(_recentExpenses),
      ),
      transactionListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final _isLandscape = mediaQuery.orientation == Orientation.landscape;

    final dynamic appBar = isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Personal Expenses"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _startAddNewExpenses(context),
                  icon: const Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text("Personal Expenses"),
          );

    final _workingHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;

    final transactionListWidget = SizedBox(
      height: _workingHeight * (_isLandscape ? 0.8 : 0.7),
      child: ExpenseList(_userExpense, _deleteExpense),
    );

    final pageBody = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _isLandscape
            ? _buildLandscapeContent(_workingHeight, transactionListWidget)
            : _buildPortraitContent(_workingHeight, transactionListWidget),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: isIOS
          ? CupertinoPageScaffold(child: pageBody)
          : SingleChildScrollView(
              child: pageBody,
            ),
      floatingActionButton: isIOS
          ? Container()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewExpenses(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
