import 'package:flutter/material.dart';

class TopLabel extends StatelessWidget {
  final String labelText;
  final Color color;
  final EdgeInsetsGeometry padding;

  const TopLabel(
      {Key key,
      this.labelText = "",
      this.color,
      this.padding = const EdgeInsets.only(left: 12)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.padding,
      child: Text(
        labelText,
        style: TextStyle(color: color != null ? color : Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.55), fontSize: 12),
      ),
    );
  }
}
