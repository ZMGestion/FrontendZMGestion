import 'package:flutter/material.dart';

class ConfirmationAlertDialog extends StatefulWidget {
  final Function onAccept;
  final Function onCancel;
  final String cancelText;
  final String acceptText;
  final String title;
  final String message;

  const ConfirmationAlertDialog({
    Key key,
    this.onAccept, 
    this.onCancel, 
    this.acceptText = "Aceptar",
    this.cancelText = "Cancelar",
    this.title = "", 
    this.message = ""
  }):super(key: key);

  @override
  _ConfirmationAlertDialogState createState() => _ConfirmationAlertDialogState();
}

class _ConfirmationAlertDialogState extends State<ConfirmationAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.message),
      titleTextStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          fontSize: 20,
          fontWeight: FontWeight.w600),
      actions: <Widget>[
        FlatButton(
            color: Colors.green,
            child: Text(widget.acceptText),
            onPressed: widget.onAccept
          ),
        FlatButton(
          color: Colors.red,
          child: Text(widget.cancelText),
          onPressed: widget.onCancel
        ),
      ],
    );
    ;
  }
}
