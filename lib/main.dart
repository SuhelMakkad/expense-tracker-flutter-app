import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';

import './models/transaction.dart';

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

  final List<Transaction> _userTransaction = [
    // Transaction(
    //     id: "t1",
    //     title: "New Shoes",
    //     amount: 7100,
    //     date: DateTime.now().subtract(Duration(days: 1))),
    // Transaction(
    //     id: "t4",
    //     title: "Rent",
    //     amount: 9500,
    //     date: DateTime.now().subtract(Duration(days: 2))),
    // Transaction(
    //     id: "t3",
    //     title: "Trip to Goa",
    //     amount: 9700,
    //     date: DateTime.now().subtract(Duration(days: 3))),
    // Transaction(
    //     id: "t4",
    //     title: "Food",
    //     amount: 1500,
    //     date: DateTime.now().subtract(Duration(days: 4))),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTransaction);
    });
  }

  void _startAddNewTransactions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        isScrollControlled: true,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
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
                }),
          ],
        ),
      ),
      _showChart
          ? SizedBox(
              height: workingHeight * 0.8,
              child: Chart(_recentTransactions),
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
        child: Chart(_recentTransactions),
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
                  onPressed: () => _startAddNewTransactions(context),
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
      child: TransactionList(_userTransaction, _deleteTransaction),
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
              onPressed: () => _startAddNewTransactions(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
