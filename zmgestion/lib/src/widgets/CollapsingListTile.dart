import 'package:flutter/material.dart';

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;
  final double iconSize;
  final double width;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;

  CollapsingListTile({
    @required this.title,
    @required this.icon,
    @required this.width,
    @required this.animationController,
    this.isSelected = false,
    this.iconSize = 32,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.onTap
  });

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
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
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.1)
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: (widthAnimation.value >= 190) ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 48,
              child: Icon(
                widget.icon,
                color: widget.isSelected ? Theme.of(context).primaryTextTheme.caption.color : Colors.white30,
                size: widget.iconSize,
              ),
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 190)
                ? Text(widget.title,
                    style: widget.isSelected
                        ? widget.unselectedTextStyle
                        : widget.selectedTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}