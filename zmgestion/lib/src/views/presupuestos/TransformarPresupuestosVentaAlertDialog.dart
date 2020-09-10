import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';

class TransformarPresupuestosVentaAlertDialog extends StatefulWidget {
  final List<Models> presupuestos;

  const TransformarPresupuestosVentaAlertDialog({
    Key key, 
    this.presupuestos
  }) : super(key: key);

  @override
  _TransformarPresupuestosVentaAlertDialogState createState() => _TransformarPresupuestosVentaAlertDialogState();
}

class _TransformarPresupuestosVentaAlertDialogState extends State<TransformarPresupuestosVentaAlertDialog> {
  
  List<Presupuestos> _presupuestos = List<Presupuestos>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(Presupuestos presupuesto in widget.presupuestos){
      _presupuestos.add(presupuesto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      elevation: 1.5,
      scrollable: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: AlertDialogTitle(
        title: "Transformar presupuestos en venta"
      ),
      content: Container(
        child: Text(
          _presupuestos != null ? _presupuestos.map((e) => e.idPresupuesto).toString() : ""
        )
      )
    );
  }
}