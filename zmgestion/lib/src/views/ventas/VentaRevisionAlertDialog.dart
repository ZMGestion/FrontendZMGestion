import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class VentaRevisionAlertDialog extends StatefulWidget {

  final Ventas venta;

  const VentaRevisionAlertDialog({Key key, this.venta}) : super(key: key);
  @override
  _VentaRevisionAlertDialogState createState() => _VentaRevisionAlertDialogState();
}

class _VentaRevisionAlertDialogState extends State<VentaRevisionAlertDialog> {

  Ventas venta;
  String content;

  @override
  void initState() {
    // TODO: implement initState
    venta = widget.venta;
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(context);
     if (_usuariosProvider.usuario.idRol == 1){
       content = "La venta requiere autorización. ¿Desea confirmar la venta?";
     }else{
       content = "La venta requiere de autorización. Contactese con un administrador.";
     }
    return AppLoader(
      builder: (RequestScheduler scheduler){
          return AlertDialog(
          title: Text("Venta pendiente!"),
          content: Text(content),
          titleTextStyle: TextStyle(
              color: Theme.of(context).primaryTextTheme.bodyText1.color,
              fontSize: 20,
              fontWeight: FontWeight.w600
          ),
          actions: [
            Visibility(
              visible: _usuariosProvider.usuario.idRol == 1,
              child: ZMStdButton(
                color: Colors.red,
                text: Text(
                  "No Autorizar",
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color
                  ),
                ),
                onPressed: () async{
                  await VentasService(scheduler: scheduler).doMethod(VentasService().cancelarVentaConfiguration(venta.idVenta));
                  Navigator.of(context).pop();               
                }
              ),
            ),
            Visibility(
              visible: _usuariosProvider.usuario.idRol == 1,
              child: ZMStdButton(
                color: Colors.green,
                text: Text(
                  "Autorizar",
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6.color
                  ),
                ),
                onPressed: () async{
                  await VentasService(scheduler: scheduler).doMethod(VentasService().revisarVentaConfiguration(venta.idVenta));
                  Navigator.of(context).pop();   
                }
              ),
            ),
            Visibility(
              visible: _usuariosProvider.usuario.idRol != 1,
              child: ZMStdButton(
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
            )
          ],
        );
      },
    );
  }
}