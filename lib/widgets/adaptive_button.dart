import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveButton extends StatelessWidget {
  final isIOS = Platform.isIOS;

  final String text;
  final VoidCallback presentDatePicker;

  AdaptiveButton(this.text, this.presentDatePicker);

  @override
  Widget build(BuildContext context) {
    return isIOS
        ? CupertinoButton(
            onPressed: presentDatePicker,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : TextButton(
            onPressed: presentDatePicker,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
