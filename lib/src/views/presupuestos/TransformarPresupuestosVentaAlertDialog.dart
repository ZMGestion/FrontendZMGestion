import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/views/domicilios/CrearDomiciliosAlertDialog.dart';
import 'package:zmgestion/src/views/presupuestos/CrearLineaVenta.dart';
import 'package:zmgestion/src/views/presupuestos/PresupuestoTransformadoDialog.dart';
import 'package:zmgestion/src/views/presupuestos/PresupuestosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AnimatedLoadingWidget.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class TransformarPresupuestosVentaAlertDialog extends StatefulWidget {
  final List<Models> presupuestos;
  final Function onSuccess;

  const TransformarPresupuestosVentaAlertDialog({
    Key key, 
    this.presupuestos, 
    this.onSuccess
  }) : super(key: key);

  @override
  _TransformarPresupuestosVentaAlertDialogState createState() => _TransformarPresupuestosVentaAlertDialogState();
}

class _TransformarPresupuestosVentaAlertDialogState extends State<TransformarPresupuestosVentaAlertDialog> {
  
  List<LineasProducto> _lineasPresupuesto = List<LineasProducto>();
  List<LineasProducto> _lineasVenta = List<LineasProducto>();
  
  int _idUbicacion;
  int _idCliente;
  int _idDomicilio;
  bool creatingVenta = false;
  String cliente;
  double _total = 0;
  int refreshDomicilios = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<int> _idPresupuestos = [];
    for(Presupuestos presupuesto in widget.presupuestos){
      _idPresupuestos.add(presupuesto.idPresupuesto);
      if(_idCliente == null){
        setState(() {
          _idCliente = presupuesto.idCliente;
        });
      }
      if(cliente == null){
        if (presupuesto.cliente.nombres != null && presupuesto.cliente.apellidos != null){
          setState(() {
            cliente = presupuesto.cliente.apellidos + ", "+ presupuesto.cliente.nombres; 
          });
        }else{
          setState(() {
            cliente = presupuesto.cliente.razonSocial;
          });
        }
      }
    }
    Map<String, dynamic> _payload = new Map<String, dynamic>();
    _payload.addAll({"Presupuestos":_idPresupuestos});
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      await PresupuestosService().listarPor(PresupuestosService().dameMultiplesConfiguration(_payload)).then((value) {
        for (Presupuestos presupuesto in value.message){
          presupuesto.lineasProducto.forEach((linea) {
            _lineasPresupuesto.add(linea);
          });
        }
      });
      setState(() {
        
      });
    });
  }

  double _getTotal(List<LineasProducto> lineasVenta){
    double _total = 0;
    lineasVenta.forEach((lv) {
      _total += lv.cantidad * lv.precioUnitario;
    });
    return double.parse(_total.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(
      builder: (scheduler){
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
          title: "Transformar presupuestos en venta",
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
                      listMethodConfiguration: ClientesService().listarDomiciliosConfiguration(_idCliente),
                      parentName: "Domicilios",
                      labelName: "Seleccione un domicilio",
                      displayedName: "Domicilio",
                      valueName: "IdDomicilio",
                      allOption: false,
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
                              barrierColor: Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              builder: (BuildContext context) {
                                return CrearDomiciliosAlertDialog(
                                  title: "Agregar domicilio",
                                  cliente: Clientes(idCliente: _idCliente),
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
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(minWidth: 200),
                    child: DropDownModelView(
                      service: UbicacionesService(),
                      listMethodConfiguration: UbicacionesService().listar(),
                      parentName: "Ubicaciones",
                      labelName: "Seleccione una ubicación",
                      displayedName: "Ubicacion",
                      valueName: "IdUbicacion",
                      allOption: false,
                      errorMessage:
                        "Debe seleccionar una ubicación",
                      textStyle: TextStyle(
                        color: Color(0xff97D2FF).withOpacity(1),
                      ),
                      dropdownColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Color(0xff87C2F5).withOpacity(0.8),  
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
                          _idUbicacion = idSelected;
                        });
                      },
                    )    
                  ),
                ),
                SizedBox(width: 12,),
                Container(
                  constraints: BoxConstraints(minWidth: 180),
                  child: ZMStdButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    text: Text(
                      "Crear venta",
                      style: TextStyle(
                        color: (_lineasVenta.isNotEmpty && _idUbicacion != null && _idDomicilio != null) ? Colors.white : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    color: Colors.green,
                    icon: Icon(
                      Icons.credit_card_outlined,
                      color: (_lineasVenta.isNotEmpty && _idUbicacion != null && _idDomicilio != null) ? Colors.white : Colors.white.withOpacity(0.5),
                      size: 16,
                    ),
                    disabledColor: Colors.white.withOpacity(0.5),
                    onPressed: (_lineasVenta.isNotEmpty && _idUbicacion != null && _idDomicilio != null) ? () async{
                        List<int> _lineasProducto = [];
                        List<Map<String, dynamic>> _nuevasLineas = new List<Map<String, dynamic>>();

                        _lineasVenta.forEach((element) {
                          if(element.idLineaProducto != null){
                            _lineasProducto.add(element.idLineaProducto);
                          }else{
                            _nuevasLineas.add({
                              "LineasProducto":{
                                "Cantidad": element.cantidad,
                                "PrecioUnitario": element.precioUnitario
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
                          "Ventas":{
                            "IdUbicacion":_idUbicacion,
                            "IdDomicilio": _idDomicilio,
                          },
                          "LineasPresupuesto": _lineasProducto,
                          "LineasVenta": _nuevasLineas
                        });
                        setState(() {
                          creatingVenta = true;
                        });
                        await PresupuestosService(scheduler: scheduler).doMethod(PresupuestosService().transformarPresupuestoEnVentaConfiguration(_payload)).then((response) async{
                          if(response.status == RequestStatus.SUCCESS){
                            Navigator.pop(context, true);
                            await showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return PresupuestoTransformadoDialog(
                                  venta: Ventas().fromMap(response.message),
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
                    Flexible(child: detallePresupuesto()),
                  ],
                )
              ),
              Expanded(
                child: Column(
                  children: [
                    Flexible(child: detalleVenta()),
                  ],
                )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detallePresupuesto(){
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
                          "Detalles de presupuestos",
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
                        flex: 2,
                        child: Text(
                          "Precio unitario",
                          textAlign: TextAlign.center,
                          style: _columnHeaderTextStyle
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Subtotal",
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
                    itemCount: _lineasPresupuesto.length,
                    itemBuilder: (context, index){
                      LineasProducto _lineaProducto = _lineasPresupuesto.elementAt(index);
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
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Expanded(
                              flex:2,
                              child: Column(
                                children: [
                                  Text(
                                    "\$"+_lineaProducto.precioUnitario.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _lineaProducto.precioUnitarioActual != null && _lineaProducto.precioUnitario != _lineaProducto.precioUnitarioActual ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _lineaProducto.precioUnitarioActual != null && _lineaProducto.precioUnitario != _lineaProducto.precioUnitarioActual,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Text(
                                            "Hoy: "+"\$"+_lineaProducto.precioUnitarioActual.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex:2,
                              child: Column(
                                children: [
                                  Text(
                                    "\$"+(_lineaProducto.precioUnitario * _lineaProducto.cantidad).toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _lineaProducto.precioUnitarioActual != null && _lineaProducto.precioUnitario != _lineaProducto.precioUnitarioActual ? Colors.white.withOpacity(0.9) : Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _lineaProducto.precioUnitarioActual != null && _lineaProducto.precioUnitario != _lineaProducto.precioUnitarioActual,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Text(
                                            "Hoy: "+"\$"+(_lineaProducto.precioUnitarioActual * _lineaProducto.cantidad).toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                        right: 7,
                                        bottom: 7,
                                        child: Visibility(
                                          visible: _lineaProducto.precioUnitarioActual != null && _lineaProducto.precioUnitario != _lineaProducto.precioUnitarioActual,
                                          child: Icon(
                                            Icons.report,
                                            color: Colors.yellow.withOpacity(0.7),
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.green,
                                        ), 
                                        onPressed: (){
                                          setState(() {
                                            _lineasVenta.add(_lineaProducto);
                                            _lineasPresupuesto.remove(_lineaProducto);
                                            _total = _getTotal(_lineasVenta);
                                          }
                                        );
                                      }),
                                    ],
                                  ),
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

  Widget detalleVenta(){
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
                    "Detalles de venta",
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
                  flex: 2,
                  child: Text(
                    "Precio unitario",
                    textAlign: TextAlign.center,
                    style: _columnHeaderTextStyle
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Subtotal",
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
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
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
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Column(
                          children: [
                            Text(
                              "\$"+_lineaProducto.precioUnitario.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                              ),
                            ),
                            Visibility(
                              visible: _lineaProducto.precioUnitarioActual != null && _lineaProducto.precioUnitario != _lineaProducto.precioUnitarioActual,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text(
                                      "Hoy: "+"\$"+_lineaProducto.precioUnitarioActual.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Column(
                          children: [
                            Text(
                              "\$"+(_lineaProducto.precioUnitario * _lineaProducto.cantidad).toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                              ),
                            ),
                            Visibility(
                              visible: _lineaProducto.precioUnitarioActual != null && _lineaProducto.precioUnitario != _lineaProducto.precioUnitarioActual,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text(
                                      "Hoy: "+"\$"+(_lineaProducto.precioUnitarioActual != null ? (_lineaProducto.precioUnitarioActual * _lineaProducto.cantidad).toString() : ""),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.remove,
                            color: Colors.red,
                          ), 
                          onPressed: (){
                            setState(() {
                              _lineasVenta.remove(_lineaProducto);
                              if(_lineaProducto.idLineaProducto != null){
                                _lineasPresupuesto.add(_lineaProducto);
                              }
                              _total = _getTotal(_lineasVenta);
                            });
                        }),
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
          Visibility(
            visible: _lineasVenta.indexWhere((lv){
              return lv.precioUnitarioActual != null && lv.precioUnitario != lv.precioUnitarioActual;
            }) > -1,
            child: Container(
              padding: EdgeInsets.all(12),
              color: Colors.blue.withOpacity(0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "La venta deberá ser revisada ya que contiene precios desactualizados",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ),
          ),
          Stack(
            children: [
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
                      child: Text(
                        "Total: \$" + _total.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryTextTheme.bodyText1.color,
                          fontSize: 26,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 5,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: (){
                    showDialog(
                      context: context,
                      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                      builder: (BuildContext context) {
                        return CrearLineaVenta(
                          onAccept: (lineaProducto){
                            setState(() {
                              _lineasVenta.add(lineaProducto);
                              _total = _getTotal(_lineasVenta);
                            });
                          },
                          onCancel: (){
                            Navigator.of(context).pop();
                          }
                        );
                      },
                    );
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}