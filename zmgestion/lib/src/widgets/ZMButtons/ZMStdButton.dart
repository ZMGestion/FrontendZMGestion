import 'package:flutter/material.dart';

class ZMStdButton extends StatelessWidget {

  final Text text;
  final Color color;
  final Color disabledColor;
  final Icon icon;
  final Function onPressed;

  const ZMStdButton({
    Key key, 
    this.text, 
    this.color = Colors.black,
    this.disabledColor = Colors.grey,
    this.icon, 
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        )
      ),
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        disabledColor: disabledColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(color: color.withOpacity(0.7), width: 2)
        ),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 4,
            ),
            text
          ],
        ),
      ),
    );
  }
}