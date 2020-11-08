import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:zmgestion/src/helpers/PDFManager.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PresupuestoCreadoDialog extends StatefulWidget {
  final Presupuestos presupuesto;

  const PresupuestoCreadoDialog({
    Key key,
    this.presupuesto
  }):super(key: key);

  @override
  _PresupuestoCreadoDialogState createState() => _PresupuestoCreadoDialogState();
}

class _PresupuestoCreadoDialogState extends State<PresupuestoCreadoDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("¡Presupuesto creado!"),
      content: Text("El presupuesto se ha creado con éxito. Seleccione lo que desee hacer."),
      titleTextStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          fontSize: 20,
          fontWeight: FontWeight.w600),
      actions: <Widget>[
        ZMStdButton(
          color: Colors.blue,
          icon: Icon(Icons.print_outlined),
          text: Text(
            "Imprimir",
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color
            ),
          ),
          onPressed: () async{
            Response<Models<dynamic>> response;
            Presupuestos _presupuesto;
            
            if(widget.presupuesto?.idPresupuesto != null){
              response = await PresupuestosService().damePor(PresupuestosService().dameConfiguration(widget.presupuesto.idPresupuesto));
            }
            if(response?.status == RequestStatus.SUCCESS){
              _presupuesto = Presupuestos().fromMap(response.message.toMap());
            }
            await Printing.layoutPdf(onLayout: (format) => PDFManager.generarPresupuestoPDF(
              format, 
              _presupuesto
            ));
          }
        ),
        ZMStdButton(
          color: Theme.of(context).primaryColor,
          text: Text(
            "Cerrar",
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color
            ),
          ),
          onPressed: (){
            Navigator.of(context).pop();
          }
        ),
      ],
    );
  }
}
