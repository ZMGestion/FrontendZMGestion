import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class ZMListLineasProducto extends StatefulWidget {
  final List<LineasProducto> lineasProducto;
  final Function(LineasProducto lp) onEdit;
  final bool withPrice;
  final Function(LineasProducto lp) onDelete;

  const ZMListLineasProducto({
    Key key, 
    this.lineasProducto,
    this.onEdit,
    this.withPrice = true,
    this.onDelete
  }) : super(key: key);

  @override
  _ZMListLineasProductoState createState() => _ZMListLineasProductoState();
}

class _ZMListLineasProductoState extends State<ZMListLineasProducto> {
  List<Widget> _lineasProducto = List<Widget>();

  @override
  void initState() {
    widget.lineasProducto.forEach((lp) {
      _lineasProducto.add(_lineaProducto(lp));
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
            child: IconButton(
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
              ),
              onPressed: null
            ),
          ),
          Opacity(
            opacity: 0,
            child: IconButton(
              icon: Icon(
                Icons.delete,
                size: 20,
              ),
              onPressed: null
            ),
          )
        ]
      ),
    );
  }

  Widget _lineaProducto(LineasProducto lp){
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  lp.cantidad.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  lp.productoFinal.producto.producto + 
                  (lp.productoFinal.tela != null? " - "+lp.productoFinal.tela.tela : "") +
                  (lp.productoFinal.lustre != null? " - "+lp.productoFinal.lustre.lustre : ""),
                  style: TextStyle(
                  color: Colors.white.withOpacity(1)
                ),
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
                  "\$"+(lp.precioUnitario != null ? lp.precioUnitario.toString() : ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600
                  ),
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
                  "\$"+(lp.precioUnitario != null ? (lp.precioUnitario * lp.cantidad).toString() : ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
          ),
        ),
        ZMTooltip(
          message: "Editar",
          theme: ZMTooltipTheme.WHITE,
          child: IconButton(
            icon: Icon(
              Icons.edit_outlined,
              size: 18,
            ),
            onPressed: () => widget.onEdit(lp)
          ),
        ),
        ZMTooltip(
          message: "Eliminar",
          theme: ZMTooltipTheme.RED,
          child: IconButton(
            icon: Icon(
              Icons.delete,
              size: 20,
            ),
            onPressed: () => widget.onDelete(lp)
          ),
        )
      ]
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