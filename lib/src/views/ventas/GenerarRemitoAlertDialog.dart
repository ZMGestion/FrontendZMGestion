import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Remitos.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/domicilios/CrearDomiciliosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/views/productosFinales/ProductosFinalesStockDialog.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';


class GenerarRemitoAlertDialog extends StatefulWidget {
  final Ventas venta;
  final Function onSuccess;

  const GenerarRemitoAlertDialog({Key key, this.venta, this.onSuccess}) : super(key: key);
  @override
  _GenerarRemitoAlertDialogState createState() => _GenerarRemitoAlertDialogState();
}

class _GenerarRemitoAlertDialogState extends State<GenerarRemitoAlertDialog> {
  Remitos remito;
  Ventas venta;
  List<LineasProducto> lineasVenta;
  List<LineasProducto> lineasVentaSeleccionadas;
  bool tieneDomicilio;
  int refreshDomicilios;
  int _idDomicilio;
  String cliente;
  List<Ubicaciones> ubicaciones = new List<Ubicaciones>();

  @override
  void initState() {
    lineasVenta = new List<LineasProducto>();
    if(widget.venta != null){
      venta = widget.venta;
      if(venta.lineasProducto != null){
        venta.lineasProducto.forEach((lineaProducto) {
          lineasVenta.add(lineaProducto);
        });
      }
      if(widget.venta.idDomicilio != null){
        _idDomicilio = venta.idDomicilio;
      }
      if (venta.cliente.nombres != null && venta.cliente.apellidos != null){
        cliente = venta.cliente.apellidos + ", "+ venta.cliente.nombres; 
      }else{
        cliente = venta.cliente.razonSocial;
      }
    }
    lineasVentaSeleccionadas = new List<LineasProducto>();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await UbicacionesService().listarPor(UbicacionesService().listar()).then((response){
        if(response.status == RequestStatus.SUCCESS){
          response.message.forEach((element) { 
            ubicaciones.add(element);
          });
        }
      });
    });
    super.initState();
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
          buttonPadding: EdgeInsets.all(0),
          elevation: 1.5,
          scrollable: true,
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: AlertDialogTitle(
            title: "Generar Remito",
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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                fit: FlexFit.tight,
                child: detalles()
              ),
                informacion(scheduler),
              ],
            )
          ),
        );
      },
    );
  }
  Widget informacion(RequestScheduler scheduler){
    return Container(
      child: Card(
        color: Color(0xff042949).withOpacity(0.55),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopLabel(
                      labelText: "Cliente",
                      color: Color(0xff97D2FF).withOpacity(0.9),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        cliente,
                        style: TextStyle(
                          color: Color(0xff97D2FF),
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ],
                )
              ),
              SizedBox(width: 12,),
              Expanded(
                  child: Container(
                  constraints: BoxConstraints(minWidth: 200),
                  child: DropDownModelView(
                    key: Key("do"+refreshDomicilios.toString()),
                    service: ClientesService(),
                    listMethodConfiguration: ClientesService().listarDomiciliosConfiguration(venta.idCliente),
                    parentName: "Domicilios",
                    labelName: "Seleccione un domicilio",
                    displayedName: "Domicilio",
                    valueName: "IdDomicilio",
                    allOption: false,
                    initialValue: _idDomicilio,
                    errorMessage: "Debe seleccionar un domicilio",
                    textStyle: TextStyle(
                      color: Color(0xff97D2FF).withOpacity(1),
                    ),
                    dropdownColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Color(0xff87C2F5).withOpacity(0.8),  
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.add_box,
                          color: Color(0xff87C2F5),
                        ),
                        onPressed: (){
                          showDialog(
                            context: context,
                            barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return CrearDomiciliosAlertDialog(
                                title: "Agregar domicilio",
                                cliente: Clientes(idCliente: venta.idCliente),
                                onSuccess: () {
                                  Navigator.of(context).pop(true);
                                  setState(() {
                                    refreshDomicilios = Random().nextInt(99999);
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                      hintStyle: TextStyle(
                        color: Color(0xffBADDFB).withOpacity(0.8)
                      ),
                      labelStyle: TextStyle(
                        color: Color(0xffBADDFB).withOpacity(0.8)
                      ),
                    ),
                    onChanged: (idSelected) {
                      setState(() {
                        _idDomicilio = idSelected;
                      });
                    }
                  )
                ),
              ),
              SizedBox(width: 12,),
              Container(
                constraints: BoxConstraints(minWidth: 180),
                child: ZMStdButton(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  text: Text(
                    "Generar Remito",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:Colors.white
                    ),
                  ),
                  color: Colors.green,
                  disable: lineasVentaSeleccionadas.length == 0 || _idDomicilio == null || _idDomicilio == 0,
                  disabledColor: Colors.grey,
                  onPressed: () async{
                    List<Map<String, dynamic>> _lineasVenta = new List<Map<String, dynamic>>();
                    lineasVentaSeleccionadas.forEach((element) { 
                      Map<String, dynamic> lineaVentaMap = new Map<String, dynamic>();
                      lineaVentaMap.addAll({
                        "IdLineaProducto": element.idLineaProducto,
                        "IdUbicacion": element.idUbicacion,
                        "Cantidad": element.cantidad,
                      });
                      _lineasVenta.add(lineaVentaMap);
                    });
                    await VentasService().doMethod(VentasService().generarRemito({
                      "Ventas":{
                        "IdVenta": venta.idVenta,
                        "IdDomicilio": _idDomicilio,
                      },
                      "LineasVenta": _lineasVenta,
                    })).then((response){
                      if(response.status == RequestStatus.SUCCESS){
                        Remitos _remito = Remitos().fromMap(response.message);
                        final NavigationService _navigationService = locator<NavigationService>();
                        _navigationService.navigateToWithReplacement('/remitos?IdRemito='+ _remito.idRemito.toString());
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget detalles(){
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
                    Flexible(child: detalleRemito()),
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
    return Card(
      elevation: 0.5,
      color: Colors.black.withOpacity(0.2),
      child: Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.05),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Detalles de venta",
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
                    "",
                    textAlign: TextAlign.center,
                  )
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              itemCount: lineasVenta.length,
              itemBuilder: (context, index){
                LineasProducto _lineaProducto = lineasVenta.elementAt(index);
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
                        child: Text(
                          _lineaProducto.productoFinal.producto.producto + 
                          " " + (_lineaProducto.productoFinal.tela?.tela??"") +
                          " " + (_lineaProducto.productoFinal.lustre?.lustre??""),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.green,
                          ), 
                          onPressed: () async{
                            ProductosFinales _productoFinal;
                            await ProductosFinalesService().damePor(ProductosFinalesService().dameConfiguration(_lineaProducto.idProductoFinal)).then((response){
                              if(response.status == RequestStatus.SUCCESS){
                                setState(() {
                                  _productoFinal = response.message;
                                });
                                showDialog(
                                  context: context,
                                  barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ProductosFinalesStockDialog(
                                      productoFinal: _productoFinal,
                                      cantidadSolicitada: _lineaProducto.cantidad,
                                      onAccept: (response) {
                                        Map<String, dynamic> lineaProductoMap = _lineaProducto.toMap();
                                        lineaProductoMap['LineasProducto']['IdUbicacion'] = response['IdUbicacion'];
                                        lineaProductoMap['LineasProducto']['Cantidad'] = response['Cantidad'];
                                        setState(() {
                                          lineasVenta.remove(_lineaProducto);
                                          if(_lineaProducto.cantidad != response['Cantidad']){
                                            Map<String, dynamic> lineasVentaActualizada = _lineaProducto.toMap();
                                            lineasVentaActualizada['LineasProducto']['Cantidad'] = _lineaProducto.cantidad - response['Cantidad'];
                                            lineasVenta.add(LineasProducto().fromMap(lineasVentaActualizada));
                                          }
                                          LineasProducto _lineaSeleccionada = LineasProducto().fromMap(lineaProductoMap);
                                          lineasVentaSeleccionadas.add(_lineaSeleccionada);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              }
                            });
                            
                          }
                        ),
                      ),
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
        ]
      ),
    );
  }

  Widget detalleRemito(){
    TextStyle _columnHeaderTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13
    );


    return Card(
      elevation: 0.5,
      child: Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.05),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Detalles de remito",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                  flex: 2,
                  child: Text(
                    "Ubicación",
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
            child: ListView.separated(
              itemCount: lineasVentaSeleccionadas.length,
              itemBuilder: (context, index){
                LineasProducto _lineaProducto = lineasVentaSeleccionadas.elementAt(index);
                String ubicacion = nombreUbicacion(_lineaProducto.idUbicacion);
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
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          _lineaProducto.productoFinal.producto.producto + 
                          " " + (_lineaProducto.productoFinal.tela?.tela??"") +
                          " " + (_lineaProducto.productoFinal.lustre?.lustre??""),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          ubicacion != null ? ubicacion : "",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: Colors.red,
                          ), 
                          onPressed: () {
                            setState(() {
                              lineasVentaSeleccionadas.remove(_lineaProducto);
                              lineasVenta.add(_lineaProducto);
                            });
                          }
                        ),
                      ),
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
        ]
      ),
    );
  }

  String nombreUbicacion(int idUbicacion ){
    String _ubicacion;
    ubicaciones.forEach((element) {
      if(element.idUbicacion == idUbicacion){
        _ubicacion = element.ubicacion;
      }
    });
    return _ubicacion;
  }
}