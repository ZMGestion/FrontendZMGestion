import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';

import 'SizeConfig.dart';

class AlertDialogTitle extends StatelessWidget {
  final String title;
  final double width;
  final Color backgroundColor;
  final Color titleColor;
  final Color titleShadowColor;

  const AlertDialogTitle({
    Key key, 
    this.title,
    this.width,
    this.backgroundColor,
    this.titleColor,
    this.titleShadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: backgroundColor != null ? backgroundColor : Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22))
          ),
          width: width != null ? width : SizeConfig.blockSizeHorizontal * 40,
          child: Column(
            children: [
              Container(
                height: 60,
                child: Stack(
                  children: [
                    Container(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title.trim(),
                            style: TextStyle(
                              color: titleShadowColor != null ? titleShadowColor : Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.06),
                              fontWeight: FontWeight.bold,
                              fontSize: 40
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      child: Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: titleColor != null ? titleColor : Theme.of(context).primaryTextTheme.headline1.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: GFIconButton(
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7),
                        ),
                        shape: GFIconButtonShape.circle,
                        color: backgroundColor ?? Theme.of(context).cardColor,
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ]
                ),
              ),
            ],
          ),
        ),
      );
  }
}