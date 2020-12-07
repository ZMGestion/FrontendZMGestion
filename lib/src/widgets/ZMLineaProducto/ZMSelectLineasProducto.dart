import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';

class ZMSelectLineasProducto extends StatefulWidget {
  final List<LineasProducto> lineasProducto;
  final Function(List<LineasProducto> lp) onSelect;
  final bool Function(LineasProducto lp) selectable;
  final bool canChangeQuantity;
  final Function(Map<int, int> mapCantidades) onChangeQuantity;
  final bool withPrice;

  const ZMSelectLineasProducto({
    Key key, 
    this.lineasProducto,
    this.onSelect,
    this.selectable,
    this.canChangeQuantity = false,
    this.onChangeQuantity,
    this.withPrice = true,
  }) : super(key: key);

  @override
  _ZMSelectLineasProductoState createState() => _ZMSelectLineasProductoState();
}

class _ZMSelectLineasProductoState extends State<ZMSelectLineasProducto> {
  List<Widget> _lineasProducto = List<Widget>();
  Map<int, int> _mapCantidades = Map<int, int>();
  List<LineasProducto> _lineasProductoSeleccionadas = List<LineasProducto>();

  @override
  void initState() {
    widget.lineasProducto.forEach((lp) {
      _lineasProducto.add(
        _LineaProducto(
          lineaProducto: lp,
          canChangeQuantity: widget.canChangeQuantity,
          onChangeQuantity: widget.selectable == null ? null : (id, cantidad){
            if(widget.onChangeQuantity != null){
              setState(() {
                _mapCantidades.containsKey(id) ?
                _mapCantidades[id]=cantidad :
                _mapCantidades.addAll({id: cantidad});
                widget.onChangeQuantity(
                  _mapCantidades
                );
              });
            }
          },
          onChange: widget.selectable == null ? null : (widget.selectable(lp) ? (s, lp){
            setState(() {
              _lineasProductoSeleccionadas.contains(lp)
              ? _lineasProductoSeleccionadas.remove(lp)
              : _lineasProductoSeleccionadas.add(lp);
            });
            if(widget.onSelect != null){
              widget.onSelect(_lineasProductoSeleccionadas);
            }
          } : null),
        )
      );
    });
    super.initState();
  }

  Widget _header(){
    TextStyle _headerTextStyle = TextStyle(
      color: Colors.white.withOpacity(0.6),
      fontWeight: FontWeight.w600
    );


    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.05),
            Colors.black.withOpacity(0.001),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1
          )
        )
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Cant.",
                    textAlign: TextAlign.center,
                    style: _headerTextStyle,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    "Detalle",
                    textAlign: TextAlign.center,
                    style: _headerTextStyle,
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: widget.withPrice,
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Precio unitario",
                    textAlign: TextAlign.center,
                    style: _headerTextStyle,
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: widget.withPrice,
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Subtotal",
                    textAlign: TextAlign.center,
                    style: _headerTextStyle,
                  )
                ],
              ),
            ),
          ),
          Opacity(
            opacity: 0,
            child: CircularCheckBox(
              onChanged: null,
              value: false,
            )
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header(),
        Column(
          children: _lineasProducto
        ),
      ],
    );
  }
}

class _LineaProducto extends StatefulWidget {
  final LineasProducto lineaProducto;
  final bool canChangeQuantity;
  final Function(int id, int cantidad) onChangeQuantity;
  final Function(bool selected, LineasProducto lp) onChange;

  const _LineaProducto({
    Key key, 
    this.lineaProducto,
    this.canChangeQuantity = false,
    this.onChangeQuantity,
    this.onChange
  }) : super(key: key);

  @override
  __LineaProductoState createState() => __LineaProductoState();
}

class __LineaProductoState extends State<_LineaProducto> {
  bool _selected = false;
  int _cantidad;
  int _minValue;

  @override
  void initState(){
    _minValue = widget.lineaProducto.cantidad;
    _cantidad = widget.lineaProducto.cantidad;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.onChange == null ? Colors.red.withOpacity(0.1) : Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: _selected && widget.onChangeQuantity != null,
                        child: InkWell(
                          onTap: _cantidad <= _minValue ? (){
                            //ScreenMessage.push("No puede fabricar para una venta menos que lo requerido ("+_minValue.toString()+")", MessageType.Info);
                          } : (){
                            setState(() {
                              _cantidad--;
                            });
                            widget.onChangeQuantity(widget.lineaProducto.idLineaProducto, _cantidad);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Text(
                              "-",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selected && widget.onChangeQuantity != null ? Colors.black.withOpacity(0.075) : Colors.transparent,
                            borderRadius: BorderRadius.circular(3)
                          ),
                          padding: EdgeInsets.symmetric(horizontal:0, vertical:8),
                          child: Text(
                            _cantidad.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(widget.onChange == null ? 0.6 : 0.8),
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _selected && widget.onChangeQuantity != null,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              _cantidad++;
                            });
                            widget.onChangeQuantity(widget.lineaProducto.idLineaProducto, _cantidad);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Text(
                              "+",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Text(
                        widget.lineaProducto.productoFinal.producto.producto + 
                        (widget.lineaProducto.productoFinal.tela != null? " - "+widget.lineaProducto.productoFinal.tela.tela : "") +
                        (widget.lineaProducto.productoFinal.lustre != null? " - "+widget.lineaProducto.productoFinal.lustre.lustre : ""),
                        style: TextStyle(
                        color: Colors.white.withOpacity(widget.onChange == null ? 0.8 : 1)
                      ),
                      ),
                      SizedBox(width: 6,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          LineasProducto().mapEstados()[widget.lineaProducto.estado],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          CircularCheckBox(
            value: _selected,
            disabledColor: Colors.grey,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onChanged: widget.onChange == null ? null : (s){
              setState(() {
                _selected = s;
                if(!_selected){
                  _cantidad = _minValue;
                }
                widget.onChange(s, widget.lineaProducto);
              });
            }
          )
        ]
      ),
    );
  }
}