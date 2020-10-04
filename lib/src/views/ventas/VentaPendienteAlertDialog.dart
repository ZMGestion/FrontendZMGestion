import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class VentaPendienteDialog extends StatefulWidget {
  final Ventas venta;
  final String operacion;
  final Function onSuccess;

  const VentaPendienteDialog({
    Key key,
    this.venta,
    this.operacion,
    this.onSuccess,
  }):super(key: key);

  @override
  _VentaPendienteDialogState createState() => _VentaPendienteDialogState();
}

class _VentaPendienteDialogState extends State<VentaPendienteDialog> {

  Ventas venta;
  String title;
  String content;
  @override
  void initState() {
    if(widget.venta != null){
      venta = widget.venta;
    }
    if(widget.operacion != null){
      if(widget.operacion == 'Modificar'){
        content = "La venta ha sido modificada con éxito.";
      }
      if(widget.operacion == "Crear"){
        content = "La venta ha sido creada con éxito.";
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enhorabuena!"),
      content: Text(content),
      titleTextStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          fontSize: 20,
          fontWeight: FontWeight.w600
      ),
      actions: <Widget>[
        ZMStdButton(
          color: Colors.blue,
          icon: Icon(Icons.attach_money),
          text: Text(
            "Agregar comprobante",
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color
            ),
          ),
          onPressed: () async{
            Navigator.of(context).pop();
            widget.onSuccess();
            
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
