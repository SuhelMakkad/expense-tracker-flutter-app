import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  String day;
  double amount;
  double totalAmountSpentInAWeek;

  ChartBar(this.day, this.amount, this.totalAmountSpentInAWeek);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        final baseHeight = constraints.maxHeight * 0.6;

        double remaingHeight = totalAmountSpentInAWeek == 0.0
            ? 0.0
            : (baseHeight * (amount / totalAmountSpentInAWeek));
        double completedHeight = baseHeight - remaingHeight;

        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(amount.toStringAsFixed(0)),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Column(
              children: [
                Container(
                  width: 10,
                  color: Colors.grey[350],
                  height: completedHeight,
                ),
                Container(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 10,
                  height: remaingHeight,
                ),
              ],
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                  day.toString().substring(0, 1),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
