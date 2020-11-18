import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class MoverProductoAlertDialog extends StatefulWidget {
  final ProductosFinales productoFinal;

  const MoverProductoAlertDialog({Key key, this.productoFinal}) : super(key: key);
  @override
  _MoverProductoAlertDialogState createState() => _MoverProductoAlertDialogState();
}

class _MoverProductoAlertDialogState extends State<MoverProductoAlertDialog> {

  ProductosFinales productoFinal;
  int cantidad;
  int idUbicacionEntrada;
  int idUbicacionSalida;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.productoFinal != null){
      productoFinal = widget.productoFinal;
    }
    cantidad = 0;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(
      builder: (RequestScheduler scheduler){
        return AlertDialog(
          titlePadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.all(16),
          insetPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(16),
          buttonPadding: EdgeInsets.all(0),
          elevation: 1.5,
          scrollable: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              RichText(
                text: TextSpan(
                  text: 'Mover mueble de ubicación',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                  children: <TextSpan>[],
                ),
              ),
            ],
          ),
          actions: [
            ZMTextButton(
              text: "Cancelar",
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal*1,
            ),
            ZMTextButton(
              text: "Aceptar",
              color: Theme.of(context).primaryColor,
              onPressed: () async{
                if(_formKey.currentState.validate()){
                  await ProductosFinalesService().doMethod(ProductosFinalesService().moverProductoFinal({
                    "LineasProducto":{
                      "IdProductoFinal": productoFinal.idProductoFinal,
                      "Cantidad": cantidad
                    },
                    "UbicacionesEntrada":{
                      "IdUbicacion": idUbicacionEntrada,
                    },
                    "UbicacionesSalida":{
                      "IdUbicacion": idUbicacionSalida,
                    }
                  })).then((response) {
                    if(response.status == RequestStatus.SUCCESS){
                      Navigator.of(context).pop(true);
                    }
                  });
                }
              },
            ),
            
          ],
          content: Container(
            padding: EdgeInsets.all(8),
            width: SizeConfig.blockSizeHorizontal * 45,
            constraints: BoxConstraints(
              maxWidth: 600,
              minWidth: 400
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: DropDownModelView(
                            service: UbicacionesService(),
                            listMethodConfiguration: UbicacionesService().listar(),
                            parentName: "Ubicaciones",
                            labelName: "Desde",
                            displayedName: "Ubicacion",
                            valueName: "IdUbicacion",
                            errorMessage: "Debe seleccionar una ubicación",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8)
                            ),
                            onChanged: (idSelected) async{
                              await ProductosFinalesService().doMethod(ProductosFinalesService().dameStock({
                                "ProductosFinales":{
                                  "IdProductoFinal": productoFinal.idProductoFinal
                                },
                                "Ubicaciones": {
                                  "IdUbicacion": idSelected
                                }
                              })).then((response) {
                                if(response.status == RequestStatus.SUCCESS){
                                  setState(() {
                                    idUbicacionSalida = idSelected;
                                    productoFinal = ProductosFinales().fromMap(response.message);
                                    cantidad = 0;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.arrow_right_alt,
                            size: 40,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: DropDownModelView(
                            service: UbicacionesService(),
                            listMethodConfiguration: UbicacionesService().listar(),
                            parentName: "Ubicaciones",
                            labelName: "Hacia",
                            displayedName: "Ubicacion",
                            valueName: "IdUbicacion",
                            errorMessage: "Debe seleccionar una ubicación",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8)
                            ),
                            onChanged: (idSelected) {
                              setState(() {
                                idUbicacionEntrada = idSelected;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SpinBox(
                            key: Key(productoFinal.cantidad.toString()),
                            enabled: idUbicacionEntrada != null && idUbicacionSalida != null ,
                            direction: Axis.horizontal,
                            decimals: 0,
                            max: productoFinal.cantidad.toDouble(),
                            decoration: InputDecoration(
                              labelText: "Cantidad"
                            ),
                            validator: (value){
                              return Validator.greaterValidator(int.parse(value), 0);
                            },
                            onChanged: (value){
                              setState(() {
                                cantidad = value.toInt();
                              });
                            },
                          )
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal*1,
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            color: Color(0xff042949).withOpacity(0.55),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text(
                                    "Disponible",
                                    style: TextStyle(
                                      color: Color(0xffBADDFB).withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          idUbicacionSalida == null ? "-" : productoFinal.cantidad.toString(),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600
                                          ),
                                          textAlign: TextAlign.center
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}