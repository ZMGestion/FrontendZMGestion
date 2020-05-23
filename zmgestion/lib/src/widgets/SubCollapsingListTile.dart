import 'package:flutter/material.dart';

class SubCollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;
  final double width;
  final bool isLast;
  final double iconSize;
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;

  SubCollapsingListTile(
      {@required this.title,
      @required this.icon,
      @required this.width,
      @required this.animationController,
      this.isLast = false,
      this.isSelected = false,
      this.iconSize = 20,
      this.selectedTextStyle,
      this.unselectedTextStyle,
      this.onTap});

  @override
  _SubCollapsingListTileState createState() => _SubCollapsingListTileState();
}

class _SubCollapsingListTileState extends State<SubCollapsingListTile> {
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
          borderRadius: widget.isLast ? BorderRadius.vertical(bottom: Radius.circular(16)) : null,
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3)
              : Colors.transparent.withOpacity(0.05),
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: (widthAnimation.value >= 190) ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: sizedBoxAnimation.value * 2),
            Padding(
              padding: EdgeInsets.only(left:0),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black12
                ),
                child: Container(
                    width: 30,
                    child: Icon(
                    widget.icon,
                    color: widget.isSelected ? Theme.of(context).primaryTextTheme.caption.color : Colors.white24,
                    size: widget.iconSize,
                  ),
                ),
              ),
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 190)
                ? Text(widget.title,
                    style: widget.isSelected
                        ? widget.selectedTextStyle
                        : widget.unselectedTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}