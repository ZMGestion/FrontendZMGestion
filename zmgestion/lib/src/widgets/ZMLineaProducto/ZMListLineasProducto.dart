import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';

class ZMListLineasProducto extends StatefulWidget {
  final List<LineasProducto> lineasProducto;
  final Function(LineasProducto lp) onEdit;
  final Function(LineasProducto lp) onDelete;

  const ZMListLineasProducto({
    Key key, 
    this.lineasProducto,
    this.onEdit,
    this.onDelete
  }) : super(key: key);

  @override
  _ZMListLineasProductoState createState() => _ZMListLineasProductoState();
}

class _ZMListLineasProductoState extends State<ZMListLineasProducto> {
  List<Widget> _lineasProducto = List<Widget>();

  @override
  void initState() {
    // TODO: implement initState
    widget.lineasProducto.forEach((lp) {
      _lineasProducto.add(_lineaProducto(lp));
    });
    super.initState();
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
                  "x"+lp.cantidad.toString(),
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
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$"+lp.precioUnitario.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$"+(lp.precioUnitario * lp.cantidad).toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            size: 18,
          ),
          onPressed: () => widget.onEdit(lp)
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            size: 20,
          ),
          onPressed: () => widget.onDelete(lp)
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _lineasProducto
    );
  }
}