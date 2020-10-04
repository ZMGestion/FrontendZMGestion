import 'package:flutter/material.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class ConfirmationAlertDialog extends StatefulWidget {
  final Function onAccept;
  final Function onCancel;
  final String cancelText;
  final String acceptText;
  final Color acceptColor;
  final Color cancelColor;
  final Icon cancelIcon;
  final Icon acceptIcon;
  final String title;
  final String message;

  const ConfirmationAlertDialog({
    Key key,
    this.onAccept, 
    this.onCancel, 
    this.acceptText = "Aceptar",
    this.cancelText = "Cancelar",
    this.acceptIcon, 
    this.cancelIcon, 
    this.cancelColor,
    this.acceptColor,
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
        ZMStdButton(
          icon: widget.acceptIcon,
          text: Text(widget.acceptText),
          color: widget.acceptColor,
          onPressed: widget.onAccept,
        ),
        ZMStdButton(
          icon: widget.cancelIcon,
          text: Text(widget.cancelText),
          color: widget.cancelColor,
          onPressed: widget.onCancel,
        )
      ],
    );
    ;
  }
}
