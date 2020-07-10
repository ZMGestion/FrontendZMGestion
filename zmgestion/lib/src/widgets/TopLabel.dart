import 'package:flutter/material.dart';

class TopLabel extends StatelessWidget {
  final String labelText;

  const TopLabel({
    Key key, 
    this.labelText = ""
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        labelText,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12
        ),
      ),
    );
  }
}