import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class OrdenesProduccionVerificarLinea extends StatefulWidget {
  final List<int> idsLineaOrdenProduccion;
  final Function onSuccess;

  const OrdenesProduccionVerificarLinea({
    Key key, 
    this.idsLineaOrdenProduccion,
    this.onSuccess
  }) : super(key: key);
  
  @override
  _OrdenesProduccionVerificarLineaState createState() => _OrdenesProduccionVerificarLineaState();
}

class _OrdenesProduccionVerificarLineaState extends State<OrdenesProduccionVerificarLinea> {
  int _idUbicacion;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titlePadding: EdgeInsets.fromLTRB(0,0,0,0),
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(0),
      buttonPadding: EdgeInsets.all(0),
      elevation: 1.5,
      scrollable: true,
      backgroundColor: Theme.of(context).cardColor,
      title: AlertDialogTitle(
        width: SizeConfig.blockSizeHorizontal * 30,
        title: "Verificar linea",
        titleColor: Theme.of(context).primaryColor,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    "Seleccione la ubicación destino de los productos fabricados",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                child: DropDownModelView(
                  service: UbicacionesService(),
                  listMethodConfiguration: UbicacionesService().listar(),
                  parentName: "Ubicaciones",
                  labelName: "Seleccione una ubicación",
                  displayedName: "Ubicacion",
                  valueName: "IdUbicacion",
                  allOption: false,
                  errorMessage: "Debe seleccionar una ubicación",
                  textStyle: TextStyle(
                    color: Colors.black.withOpacity(0.8)
                  ),
                  iconEnabledColor: Colors.black.withOpacity(0.7),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: Color(0xff87C2F5).withOpacity(0.7),  
                    ),
                  ),
                  onChanged: (idSelected) {
                    setState(() {
                      _idUbicacion = idSelected;
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZMStdButton(
                  color: Theme.of(context).primaryColor,
                  text: Text(
                    "Aceptar",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onPressed: () async{
                    List<Map<String, int>> _lineasOrdenProduccion = List<Map<String, int>>();
                    widget.idsLineaOrdenProduccion.forEach((idLineaProducto) {
                      _lineasOrdenProduccion.add({
                        "IdLineaProducto": idLineaProducto
                      });
                    });
                    await OrdenesProduccionService().doMethod(OrdenesProduccionService().verificarLineaOrdenProduccion({
                      "LineasOrdenProduccion": _lineasOrdenProduccion,
                      "Ubicaciones": {
                        "IdUbicacion": _idUbicacion
                      }
                    })).then((response) async{
                      if (response.status == RequestStatus.SUCCESS){
                        if(widget.onSuccess != null){
                          widget.onSuccess();
                        }
                      }
                    });
                    Navigator.pop(context, false);
                  },
                ),
                SizedBox(
                  width: 15
                ),
                ZMTextButton(
                  color: Theme.of(context).primaryColor,
                  text: "Cancelar",
                  onPressed: () async{
                    Navigator.of(context).pop();
                  },
                  outlineBorder: false,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}