import 'package:flutter/material.dart';

class CollapsingHeaderListTile extends StatefulWidget {
  final String title;
  final Widget leading;
  final AnimationController animationController;
  final double width;
  final TextStyle textStyle;
  final bool expandable;

  CollapsingHeaderListTile({
    @required this.title,
    this.leading,
    @required this.width,
    @required this.animationController,
    this.textStyle,
    this.expandable = false
  });

  @override
  _CollapsingHeaderListTileState createState() => _CollapsingHeaderListTileState();
}

class _CollapsingHeaderListTileState extends State<CollapsingHeaderListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: widget.width, end: 70).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 10, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthAnimation.value,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
      child: Row(
        mainAxisAlignment: (widthAnimation.value >= 190) ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            child: widget.leading != null ? widget.leading : Container()
          ),
          SizedBox(width: sizedBoxAnimation.value),
          (widthAnimation.value >= 190)
              ? Expanded(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: widget.textStyle),
                  ],
                ),
              )
              : Container()
        ],
      ),
    );
  }
}