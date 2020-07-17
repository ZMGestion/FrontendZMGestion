import 'package:flutter/material.dart';

class TopLabel extends StatelessWidget {
  final String labelText;
  final EdgeInsetsGeometry padding;

  const TopLabel(
      {Key key,
      this.labelText = "",
      this.padding = const EdgeInsets.only(left: 12)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.padding,
      child: Text(
        labelText,
        style: TextStyle(color: Colors.black54, fontSize: 12),
      ),
    );
  }
}
