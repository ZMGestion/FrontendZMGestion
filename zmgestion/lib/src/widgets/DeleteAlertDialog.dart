import 'package:flutter/material.dart';

class DeleteAlertDialog extends StatefulWidget {
  final Function onAccept;
  final String title;
  final String message;

  DeleteAlertDialog({this.onAccept, this.title = "", this.message = ""});
  @override
  _DeleteAlertDialogState createState() => _DeleteAlertDialogState();
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.message),
      useMaterialBorderRadius: true,
      titleTextStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          fontSize: 20,
          fontWeight: FontWeight.w600),
      actions: <Widget>[
        FlatButton(
            child: Text("Aceptar"),
            onPressed: widget.onAccept != null ? widget.onAccept : () {}),
        FlatButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    ;
  }
}
