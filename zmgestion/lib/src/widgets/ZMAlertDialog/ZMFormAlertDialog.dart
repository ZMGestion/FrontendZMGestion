import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';

class ZMFormAlertDialog extends StatefulWidget{
  final Models model;

  const ZMFormAlertDialog({
    Key key,
    this.model
  }) : super(key: key);

  @override
  _ZMFormAlertDialogState createState() => _ZMFormAlertDialogState();
}

class _ZMFormAlertDialogState extends State<ZMFormAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        Text("Asd"),
      ],
    );
  }
}