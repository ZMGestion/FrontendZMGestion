import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';

class IconButtonTableAction extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;

  const IconButtonTableAction({
    Key key, 
    this.iconData,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFIconButton(
      icon: Icon(
        iconData != null ? iconData : Icons.image,
        color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.6),
      ),
      shape: GFIconButtonShape.circle,
      color: Colors.white,
      hoverColor: Colors.black.withOpacity(0.1),
      onPressed: onPressed
    );
  }
}