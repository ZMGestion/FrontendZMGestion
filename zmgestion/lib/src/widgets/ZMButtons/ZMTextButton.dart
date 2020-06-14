import 'package:flutter/material.dart';

class ZMTextButton extends StatelessWidget {

  final String text;
  final Color color;
  final Color disabledColor;
  final Icon icon;
  final Function onPressed;
  final bool outlineBorder;

  const ZMTextButton({
    Key key, 
    this.text = "", 
    this.color = Colors.black,
    this.disabledColor = Colors.grey,
    this.icon, 
    this.onPressed,
    this.outlineBorder
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
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        color: Colors.transparent,
        disabledColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(color: outlineBorder ? color.withOpacity(0.7) : Colors.transparent, width: 2)
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
            Text(
              text,
              style: TextStyle(
                color: onPressed != null ? color : disabledColor,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}