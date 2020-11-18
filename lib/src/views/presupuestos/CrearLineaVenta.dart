import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMLineaProducto.dart';

class CrearLineaVenta extends StatefulWidget {
  final Function(LineasProducto lp) onAccept;
  final Function() onCancel;

  const CrearLineaVenta({
    Key key,
    this.onAccept,
    this.onCancel
  }):super(key:key);
  @override
  _CrearLineaVentaState createState() => _CrearLineaVentaState();
}

class _CrearLineaVentaState extends State<CrearLineaVenta> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(6,6,6,0),
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      elevation: 1.5,
      scrollable: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: AlertDialogTitle(
        title: "Nueva linea de venta", 
        titleColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      content: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
        ),
        child: Card(
          color: Theme.of(context).primaryColorLight,
          child: ZMLineaProducto(
            onCancel: widget.onCancel,
            onAccept: (lineaProducto){
              widget.onAccept(lineaProducto);
              Navigator.of(context).pop();
            },
          )
        ),
      ),
    );
  }
}