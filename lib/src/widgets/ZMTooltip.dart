import 'package:flutter/material.dart';
import 'package:zmgestion/main.dart';

enum ZMTooltipTheme {
  PRIMARY,
  BLACK,
  WHITE,
  BLUE,
  RED,
  YELLOW,
  GREEN
}

class ZMTooltip extends StatefulWidget {
  final bool visible;
  final double opacity;
  final String message;
  final Widget child;
  final BoxDecoration decoration;
  final ZMTooltipTheme theme;

  const ZMTooltip({
    Key key, 
    this.visible = true,
    this.message = "",
    this.opacity = 0.85,
    this.decoration,
    this.child,
    this.theme = ZMTooltipTheme.PRIMARY
  }) : super(key: key);

  @override
  _ZMTooltipState createState() => _ZMTooltipState();
}

class _ZMTooltipState extends State<ZMTooltip> {
  Color _backgroundColor;
  Color _textColor;
  double _opacity;
  
  @override
  void initState() {
    _opacity = widget.opacity;
    if(_opacity > 1){
      _opacity = 1;
    }else if(_opacity < 0){
      _opacity = 0;
    }

    switch(widget.theme){
      case ZMTooltipTheme.PRIMARY:
        _backgroundColor = Theme.of(mainContext).primaryColor.withOpacity(_opacity);
        _textColor = Colors.white;
        break;
      case ZMTooltipTheme.BLACK:
        _backgroundColor = Colors.black.withOpacity(_opacity);
        _textColor = Colors.white;
        break;
      case ZMTooltipTheme.WHITE:
        _backgroundColor = Colors.white.withOpacity(_opacity);
        _textColor = Colors.black;
        break;
      case ZMTooltipTheme.BLUE:
        _backgroundColor = Colors.blue.withOpacity(_opacity);
        _textColor = Colors.white;
        break;
      case ZMTooltipTheme.RED:
        _backgroundColor = Colors.red.withOpacity(_opacity);
        _textColor = Colors.white;
        break;
      case ZMTooltipTheme.GREEN:
        _backgroundColor = Colors.green.withOpacity(_opacity);
        _textColor = Colors.white;
        break;
      case ZMTooltipTheme.YELLOW:
        _backgroundColor = Colors.yellow.withOpacity(_opacity);
        _textColor = Colors.black;
        break;
      default:
        _backgroundColor = Colors.black.withOpacity(_opacity);
        _textColor = Colors.white;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      child: widget.child,
      waitDuration: widget.visible ? null : Duration(minutes: 1),
      message: widget.visible ? widget.message : "",
      textStyle: TextStyle(
        color: _textColor
      ),
      decoration: widget.decoration != null ? widget.decoration : BoxDecoration(
        color: widget.visible ? _backgroundColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: widget.visible ? [ 
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(1,1)
          )
        ] : null,
      ),
    );
  }
}