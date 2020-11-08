import 'package:flutter/material.dart';
import 'package:zmgestion/main.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/views/usuarios/CambiarPassAlertDialog.dart';

class ZMUserAction extends StatefulWidget {
  final Usuarios usuario;

  const ZMUserAction({
    Key key, 
    this.usuario
  }) : assert(usuario != null), super(key: key);

  @override
  _ZMUserActionState createState() => _ZMUserActionState();
}


class _ZMUserActionState extends State<ZMUserAction> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  GlobalKey _userActionKey = GlobalKey();
  bool menuVisible = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        var entry = _createOverlayEntry(context);
        OverlayState overlayState = locator<NavigationService>().navigatorKey.currentState.overlay;
        overlayState.insert(entry);
        setState(() {
          _overlayEntry = entry;
          menuVisible = true;
        });
      } else {
        _overlayEntry.remove();
        setState(() {
          _overlayEntry = null;
          menuVisible = false;
        });
      }
    });
  }

  Widget _item({
    Function() onTap,
    String text = "",
    IconData iconData,
    Color backgroundColor,
    Color textColor,
    Color iconColor
  }){
    return Material(
      color: backgroundColor != null ? backgroundColor : Colors.transparent,
      child: ListTile(
        title: Row(
          children: [
            Icon(
              iconData != null ? iconData : Icons.insert_emoticon,
              size: 22,
              color: iconColor != null ? iconColor : Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.4),
            ),
            SizedBox(
              width: 18,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor != null ? textColor : Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.8),
                fontSize: 16
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox userAction = _userActionKey.currentContext.findRenderObject();
    Size userActionSize = userAction.size;
    Offset userActionPosition = userAction.localToGlobal(Offset.zero);
    double _width = 300;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: _width,
        left: userActionPosition.dx - userActionSize.width/2 - (_width - userActionSize.width)/2,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                width: _width,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.1),
                      width: 0.8,
                    )
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
                        maxRadius: 36,
                        child: Text(
                          widget.usuario.nombres != null ? widget.usuario.nombres.substring(0,1) : "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.usuario.nombres != null ? "${widget.usuario.nombres} ${widget.usuario.apellidos}" : "...",
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                widget.usuario.email != null ? "${widget.usuario.email}" : "...",
                                style: TextStyle(
                                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7),
                                  fontSize: 12
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Material(
                                    elevation: 1,
                                    borderRadius: BorderRadius.circular(4),
                                    color: Theme.of(context).primaryColorLight.withOpacity(0.7),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      child: Text(
                                        widget.usuario.rol != null ? "${widget.usuario.rol.rol}" : "...",
                                        style: TextStyle(
                                        color: Theme.of(context).primaryTextTheme.caption.color.withOpacity(0.8),
                                        fontSize: 12
                                      ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).cardColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: <Widget>[
                    
                    _item(
                      text: "Cambiar contraseña",
                      backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.05),
                      iconData: Icons.lock_outline,
                      iconColor: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.5),
                      textColor: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.8),
                      onTap: (){
                        showDialog(
                          context: context,
                          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                          builder: (context) {
                            return CambiarPassAlertDialog(
                              usuario: widget.usuario,
                            );
                          },
                        );
                      }
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          borderRadius: BorderRadius.circular(32),
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          child: InkWell(
            onTap: (){
              if(_focusNode.hasFocus){
                _focusNode.unfocus();
              }else{
                _focusNode.requestFocus();
              }
              //_createOverlayEntry(context);
            },
            focusNode: _focusNode,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              key: _userActionKey,
              padding: EdgeInsets.fromLTRB(4, 4, 12, 4),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryTextTheme.caption.color.withOpacity(0.3),
                    maxRadius: 16,
                    child: Text(
                      widget.usuario.nombres != null ? widget.usuario.nombres.substring(0,1) : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          widget.usuario.nombres != null ? "${widget.usuario.nombres} ${widget.usuario.apellidos}" : "...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          menuVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}