import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/ZMLineaProductoSinPrecio/ZMLineaProductoSinPrecio.dart';

class CrearLineaOrdenProduccion extends StatefulWidget {
  final Function(LineasProducto lp, Map<int, int> cantidadSolicitadaUbicacion) onAccept;
  final Function() onCancel;

  const CrearLineaOrdenProduccion({
    Key key,
    this.onAccept,
    this.onCancel
  }):super(key:key);
  @override
  _CrearLineaOrdenProduccionState createState() => _CrearLineaOrdenProduccionState();
}

class _CrearLineaOrdenProduccionState extends State<CrearLineaOrdenProduccion> {
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
        title: "Nueva linea de orden de producción", 
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
          child: ZMLineaProductoSinPrecio(
            onCancel: widget.onCancel,
            onAccept: (lineaProducto, stockUbicacion){
              widget.onAccept(lineaProducto, stockUbicacion);
              Navigator.of(context).pop();
            },
          )
        ),
      ),
    );
  }
}