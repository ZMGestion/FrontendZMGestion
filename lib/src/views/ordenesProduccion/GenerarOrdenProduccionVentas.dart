import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/views/domicilios/CrearDomiciliosAlertDialog.dart';
import 'package:zmgestion/src/views/ordenesProduccion/CrearLineaOrdenProduccion.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AnimatedLoadingWidget.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class GenerarOrdenProduccionVentas extends StatefulWidget {
  final List<Models> ventas;
  final Function onSuccess;

  const GenerarOrdenProduccionVentas({
    Key key, 
    this.ventas, 
    this.onSuccess
  }) : super(key: key);

  @override
  _GenerarOrdenProduccionVentasState createState() => _GenerarOrdenProduccionVentasState();
}

class _GenerarOrdenProduccionVentasState extends State<GenerarOrdenProduccionVentas> {
  
  List<LineasProducto> _lineasVenta = List<LineasProducto>();
  List<LineasProducto> _lineasOrdenProduccion = List<LineasProducto>();
  TextEditingController _observacionesController = TextEditingController();

  int _idUbicacion;
  int _idDomicilio;
  bool creatingVenta = false;
  double _total = 0;
  int refreshDomicilios = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<int> _idVentas = [];
    for(Ventas venta in widget.ventas){
      _idVentas.add(venta.idVenta);
    }
    Map<String, dynamic> _payload = new Map<String, dynamic>();
    _payload.addAll({"Ventas": _idVentas});
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      await VentasService().listarPor(VentasService().dameMultipleConfiguration(_payload)).then((value) {
        for (Ventas venta in value.message){
          venta.lineasProducto.forEach((lineaVenta) {
            int _index = _lineasVenta.lastIndexWhere((el){
              return el.idProductoFinal == lineaVenta.idProductoFinal && el.estado == lineaVenta.estado;
            });
            if(_index >= 0){
              LineasProducto _newLineaProducto = LineasProducto(
                idLineaProducto: lineaVenta.idLineaProducto,
                cantidad: lineaVenta.cantidad + _lineasVenta[_index].cantidad,
                idProductoFinal: lineaVenta.idProductoFinal,
                productoFinal: lineaVenta.productoFinal,
                estado: lineaVenta.estado,
                idLineasPadres: [lineaVenta.idLineaProducto, ..._lineasVenta[_index].idLineasPadres]
              );
              _lineasVenta.removeAt(_index);
              _lineasVenta.add(_newLineaProducto);
            }else{
              LineasProducto _newLineaProducto = LineasProducto(
                idLineaProducto: lineaVenta.idLineaProducto,
                cantidad: lineaVenta.cantidad,
                idProductoFinal: lineaVenta.idProductoFinal,
                productoFinal: lineaVenta.productoFinal,
                estado: lineaVenta.estado,
                idLineasPadres: [lineaVenta.idLineaProducto]
              );
              _lineasVenta.add(_newLineaProducto);
            }
          });
        }
      });
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(
      builder: (scheduler){
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
          title: "Generar orden de producción para ventas",
          backgroundColor: Theme.of(context).primaryColorLight,
          titleColor: Colors.white,
        ),
        content: Container(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          width: SizeConfig.blockSizeHorizontal * 90,
          height: SizeConfig.blockSizeVertical * 65,
          constraints: BoxConstraints(
            maxWidth: 1300,
            minWidth: 600
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: generadorDetalle()
              ),
              formulario(scheduler)
            ],
          )
        )
      );
      },
    );
  }

  Widget formulario(RequestScheduler scheduler){
    return Card(
      color: Color(0xff042949).withOpacity(0.55),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormFieldDialog(
                    controller: _observacionesController,
                    labelText: "Observaciones",
                    maxLines: 2,
                    hintText: "Ingrese aquí sus observaciones (opcional)",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5)
                    ),
                    labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.8)
                    ),
                    textStyle: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                SizedBox(width: 12,),
                Container(
                  constraints: BoxConstraints(minWidth: 180),
                  child: ZMStdButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                    text: Text(
                      "Generar orden de producción",
                      style: TextStyle(
                        color: (_lineasOrdenProduccion.isNotEmpty) ? Colors.white : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    color: Colors.green,
                    icon: Icon(
                      FontAwesomeIcons.hammer,
                      color: (_lineasOrdenProduccion.isNotEmpty) ? Colors.white : Colors.white.withOpacity(0.5),
                      size: 14,
                    ),
                    disabledColor: Colors.white.withOpacity(0.5),
                    onPressed: (_lineasOrdenProduccion.isNotEmpty) ? () async{
                        List<Map<String, dynamic>> _lv = List<Map<String, dynamic>>();
                        List<Map<String, dynamic>> _nuevasLineas = List<Map<String, dynamic>>();

                        _lineasOrdenProduccion.forEach((element) {
                          if(element.idLineaProducto != null){
                            _lv.add({
                              "Cantidad": element.cantidad,
                              "IdProductoFinal": element.idProductoFinal,
                              "IdLineasPadre": element.idLineasPadres,
                            });
                          }else{
                            _nuevasLineas.add({
                              "LineasProducto":{
                                "Cantidad": element.cantidad
                              },
                              "ProductosFinales":{
                                "IdProducto": element.productoFinal.producto?.idProducto,
                                "IdTela": element.productoFinal.tela != null ? element.productoFinal.tela.idTela : 0,
                                "IdLustre": element.productoFinal.lustre != null ? element.productoFinal.lustre.idLustre : 0,
                              }
                            });
                          }
                        });
                        Map<String, dynamic> _payload = new Map<String, dynamic>();
                        _payload.addAll({
                          "OrdenesProduccion":{
                            "Observaciones": _observacionesController.text
                          },
                          "LineasVenta": _lv,
                          "LineasOrdenProduccion": _nuevasLineas
                        });
                        setState(() {
                          creatingVenta = true;
                        });
                        await VentasService(scheduler: scheduler).doMethod(VentasService().generarOrdenProduccion(_payload)).then((response) async{
                          if(response.status == RequestStatus.SUCCESS){
                            Navigator.pop(context, true);
                            await showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                //Orden de produccion generada
                                return AlertDialog(
                                  content: Text("Success"),
                                );
                              },
                            );
                            widget.onSuccess();
                          }
                        });
                        setState(() {
                          creatingVenta = false;
                        });
                      } : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget generadorDetalle(){
    return Column(
      children: [
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Flexible(child: detalleVenta()),
                  ],
                )
              ),
              Expanded(
                child: Column(
                  children: [
                    Flexible(child: detalleOrdenProduccion()),
                  ],
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detalleVenta(){
    TextStyle _columnHeaderTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
      color: Colors.white.withOpacity(0.8)
    );

    return Column(
      children: [
        Flexible(
          child: Card(
            elevation: 0.5,
            color: Colors.black.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(0.05),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Detalles de ventas",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff97D2FF),
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),  
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.25)
                      )
                    )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Cant.",
                          textAlign: TextAlign.center,
                          style: _columnHeaderTextStyle,
                        )
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          "Detalle",
                          textAlign: TextAlign.center,
                          style: _columnHeaderTextStyle
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Cant. Ventas",
                          textAlign: TextAlign.center,
                          style: _columnHeaderTextStyle
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "",
                          textAlign: TextAlign.center,
                        )
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    itemCount: _lineasVenta.length,
                    itemBuilder: (context, index){
                      LineasProducto _lineaProducto = _lineasVenta.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                _lineaProducto.cantidad.toString(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _lineaProducto.productoFinal.producto.producto + 
                                    " " + (_lineaProducto.productoFinal.tela?.tela??"") +
                                    " " + (_lineaProducto.productoFinal.lustre?.lustre??""),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Visibility(
                                    visible: _lineaProducto.estado != null,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 6,),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Text(
                                            LineasProducto().mapEstados()[_lineaProducto.estado]??(_lineaProducto.estado??""),
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 11
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _lineaProducto.idLineasPadres.length.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: _lineaProducto.estado != 'P' ? Colors.grey : Colors.green,
                                    ), 
                                    onPressed: _lineaProducto.estado != 'P' ? null : (){
                                      setState(() {
                                        _lineasOrdenProduccion.add(_lineaProducto);
                                        _lineasVenta.remove(_lineaProducto);
                                      }
                                    );
                                  }),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index){
                      return Divider(
                        color: Colors.black12,
                        height: 2,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget detalleOrdenProduccion(){
    TextStyle _columnHeaderTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13
    );

    return Card(
      elevation: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.05),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Detalles de orden de producción",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.bodyText1.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),  
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.25)
                )
              )
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Cant.",
                    textAlign: TextAlign.center,
                    style: _columnHeaderTextStyle,
                  )
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "Detalle",
                    textAlign: TextAlign.center,
                    style: _columnHeaderTextStyle
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Cant. Ventas",
                    textAlign: TextAlign.center,
                    style: _columnHeaderTextStyle,
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "",
                    textAlign: TextAlign.center,
                  )
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: ListView.separated(
              itemCount: _lineasOrdenProduccion.length,
              itemBuilder: (context, index){
                LineasProducto _lineaProducto = _lineasOrdenProduccion.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          _lineaProducto.cantidad.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _lineaProducto.productoFinal.producto.producto + 
                              " " + (_lineaProducto.productoFinal.tela?.tela??"") +
                              " " + (_lineaProducto.productoFinal.lustre?.lustre??""),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            Visibility(
                              visible: _lineaProducto.estado != null,
                              child: Row(
                                children: [
                                  SizedBox(width: 6,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Text(
                                      LineasProducto().mapEstados()[_lineaProducto.estado]??(_lineaProducto.estado??""),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 11
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _lineaProducto.idLineasPadres?.length?.toString()??"-",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                fontWeight: FontWeight.w600
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.red,
                              ), 
                              onPressed: (){
                                setState(() {
                                  _lineasOrdenProduccion.remove(_lineaProducto);
                                  if(_lineaProducto.idLineaProducto != null){
                                    _lineasVenta.add(_lineaProducto);
                                  }
                                });
                            }),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index){
                return Divider(
                  color: Colors.black12,
                  height: 2,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    border: Border(
                      top: BorderSide(
                        width: 0.5,
                        color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.25)
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZMStdButton(
                        color: Colors.blue,
                        text: Text(
                          "Agregar linea",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: (){
                          showDialog(
                            context: context,
                            barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return CrearLineaOrdenProduccion(
                                onAccept: (lineaProducto, cantidadSolicitadaUbicacion){
                                  setState(() {
                                    _lineasOrdenProduccion.add(lineaProducto);
                                  });
                                },
                                onCancel: (){
                                  Navigator.of(context).pop();
                                }
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}