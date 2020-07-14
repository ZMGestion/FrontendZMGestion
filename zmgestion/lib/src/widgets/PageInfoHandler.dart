import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Paginaciones.dart';

class PageInfoHandler extends StatefulWidget {
  final Paginaciones initialPageInfo;
  final Function(Paginaciones pageInfo) onChange;
  final int maxPagesIcon;

  const PageInfoHandler({
    Key key, 
    this.initialPageInfo,
    this.onChange,
    this.maxPagesIcon = 7
  }): assert(initialPageInfo != null),  super(key: key);

  @override
  _PageInfoHandlerState createState() => _PageInfoHandlerState();
}

class _PageInfoHandlerState extends State<PageInfoHandler> {

  Paginaciones currentPageInfo;
  int pagina = 1;
  int cantidadTotal = 0;
  int longitudPagina = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPageInfo = widget.initialPageInfo;
    cantidadTotal = currentPageInfo.cantidadTotal != null ? currentPageInfo.cantidadTotal : 0;
    pagina = currentPageInfo.pagina;
    longitudPagina = currentPageInfo.longitudPagina;
  }

  int _getPageLength(){
    int cantidad = cantidadTotal ~/ longitudPagina;
    int resto = cantidadTotal % longitudPagina;
    if(resto > 0){
      cantidad++;
    }
    return cantidad;
  }

  List<Widget> _getPageIcons(){
    int pageLength = _getPageLength();
    int max = pageLength < widget.maxPagesIcon ? pageLength : widget.maxPagesIcon;
    List<Widget> _buttons = new List<Widget>();
    int initialIndex = 0;
    if(pageLength > max){
      if(pagina > (max/2 + (max % 2))){
        initialIndex = pagina - (max/2 + (max % 2)).toInt();
      }
      if(initialIndex > (pageLength - (max/2 - (max % 2)))){
        initialIndex = (pageLength - max).toInt();
      }
    }
    int cantidad = 0;
    for (int i=initialIndex; i < pageLength; i++){
      cantidad++;
      if(cantidad <= max){
        _buttons.add(
          pageButton(i)
        );
      }
    }
    return _buttons;
  }

  Widget pageButton(int pageIndex){
    return ClipOval(
      child: Material(
        color: pagina == (pageIndex != null ? (pageIndex+1) : -1) ? Theme.of(context).primaryColor : Colors.transparent,
        child: InkWell(
          splashColor: Colors.blueAccent,
          child: SizedBox(
            width: 32, 
            height: 32, 
            child: Center(
              child: Text(
                pageIndex != null ? (pageIndex+1).toString() : "-",
                style: TextStyle(
                  fontWeight: pagina == (pageIndex != null ? (pageIndex+1) : -1) ? FontWeight.bold : FontWeight.normal,
                  color: pagina == (pageIndex != null ? (pageIndex+1) : -1) ? Theme.of(context).primaryTextTheme.caption.color : Theme.of(context).primaryTextTheme.bodyText1.color,
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() { 
              pagina = pageIndex+1;
            });
          },
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    if(widget.onChange != null){
      widget.onChange(
        Paginaciones(
          cantidadTotal: cantidadTotal,
          longitudPagina: longitudPagina,
          pagina: pagina
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left
          ),
          onPressed: currentPageInfo.pagina <= 1 ? null : (){
            setState((){
              pagina--;
            });
          },
        ),
        Row(
          children: _getPageIcons() != null ? _getPageIcons() : [],
        ),
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_right
          ),
          onPressed: currentPageInfo.pagina >= _getPageLength() ? null : (){
            setState((){
              pagina++;
            });
          },
        ),
      ],
    );
  }
}