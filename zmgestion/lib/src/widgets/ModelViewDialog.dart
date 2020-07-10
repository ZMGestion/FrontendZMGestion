import 'package:flutter/material.dart';

class ModelViewDialog extends StatefulWidget {
  final Widget content;

  const ModelViewDialog({
    Key key, 
    this.content
  }) : super(key: key);


  @override
  _ModelViewDialogState createState() => _ModelViewDialogState();
}

class _ModelViewDialogState extends State<ModelViewDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      elevation: 1.5,
      scrollable: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: widget.content,
    );
  }
}