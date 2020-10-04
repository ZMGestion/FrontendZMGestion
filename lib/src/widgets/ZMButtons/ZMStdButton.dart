import 'package:flutter/material.dart';

class ZMStdButton extends StatelessWidget {

  final Text text;
  final Color color;
  final Color disabledColor;
  final Icon icon;
  final Function onPressed;
  final EdgeInsets padding;

  const ZMStdButton({
    Key key, 
    this.text, 
    this.color = Colors.black,
    this.disabledColor = Colors.grey,
    this.icon, 
    this.onPressed,
    this.padding = const EdgeInsets.all(0)
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
            Visibility(
              visible: icon != null,
              child: Row(
                children: [
                  icon != null ? icon : Container(),
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ),
            Padding(
              padding: padding,
              child: text,
            )
          ],
        ),
      ),
    );
  }
}