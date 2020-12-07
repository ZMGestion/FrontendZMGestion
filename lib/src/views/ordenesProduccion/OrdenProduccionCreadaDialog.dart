import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:printing/printing.dart';
import 'package:zmgestion/src/helpers/PDFManager.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class OrdenProduccionCreadaDialog extends StatefulWidget {
  final OrdenesProduccion ordenProduccion;

  const OrdenProduccionCreadaDialog({
    Key key,
    this.ordenProduccion
  }):super(key: key);

  @override
  _OrdenProduccionCreadaDialogState createState() => _OrdenProduccionCreadaDialogState();
}

class _OrdenProduccionCreadaDialogState extends State<OrdenProduccionCreadaDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Orden de producción creada!"),
      content: Text("La orden de producción se ha creado con éxito. Seleccione lo que desee hacer."),
      titleTextStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.bodyText1.color,
          fontSize: 20,
          fontWeight: FontWeight.w600),
      actions: <Widget>[
        ZMStdButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(
            FontAwesomeIcons.hammer,
            size: 15,
          ),
          padding: EdgeInsets.only(left: 6),
          text: Text(
            "Ver orden de producción",
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color
            ),
          ),
          onPressed: (){
            final NavigationService _navigationService = locator<NavigationService>();
            _navigationService.navigateTo("/ordenes-produccion?IdOrdenProduccion="+widget.ordenProduccion.idOrdenProduccion.toString());
          }
        ),
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
            OrdenesProduccion _ordenProduccion;
            
            if(widget.ordenProduccion?.idOrdenProduccion != null){
              response = await OrdenesProduccionService().damePor(OrdenesProduccionService().dameConfiguration(widget.ordenProduccion.idOrdenProduccion));
            }
            if(response?.status == RequestStatus.SUCCESS){
              _ordenProduccion = OrdenesProduccion().fromMap(response.message.toMap());
            }
            await Printing.layoutPdf(onLayout: (format) => PDFManager.generarOrdenProduccionPDF(
              format, 
              _ordenProduccion
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
