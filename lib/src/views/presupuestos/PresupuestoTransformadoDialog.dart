import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class PresupuestoTransformadoDialog extends StatefulWidget {
  final Ventas venta;

  const PresupuestoTransformadoDialog({
    Key key,
    this.venta
  }):super(key: key);

  @override
  _PresupuestoTransformadoDialogState createState() => _PresupuestoTransformadoDialogState();
}

class _PresupuestoTransformadoDialogState extends State<PresupuestoTransformadoDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("¡Venta creada!"),
      content: Text("La venta ha sido creada con éxito utilizando los presupuestos seleccionados."),
      titleTextStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          fontSize: 20,
          fontWeight: FontWeight.w600),
      actions: <Widget>[
        ZMStdButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.credit_card),
          text: Text(
            "Ver venta",
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color
            ),
          ),
          onPressed: (){
            final NavigationService _navigationService = locator<NavigationService>();
            _navigationService.navigateTo("/ventas?IdVenta="+widget.venta.idVenta.toString());
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
