import 'package:flutter/material.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';

class ModelViewDialog extends StatefulWidget {
  /*
    Widget utilizado para renderizar los modelos en un alert dialog (utilizado por el 'ojo' en los actions de las tablas)
  */
  final Widget content;
  final String title;

  const ModelViewDialog({
    Key key, 
    this.content,
    this.title = ""
  }) : super(key: key);


  @override
  _ModelViewDialogState createState() => _ModelViewDialogState();
}

class _ModelViewDialogState extends State<ModelViewDialog> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      title: AlertDialogTitle(
        title: widget.title, 
        titleColor: Theme.of(context).primaryColorLight.withOpacity(0.8),
      ),
      elevation: 1.5,
      scrollable: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: widget.content,
    );
  }
}