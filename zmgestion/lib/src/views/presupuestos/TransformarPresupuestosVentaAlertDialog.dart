import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/services/ClientesService.dart';
import 'package:zmgestion/src/services/PresupuestosService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/views/presupuestos/CrearLineaVenta.dart';
import 'package:zmgestion/src/views/presupuestos/CrearPresupuestosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AnimatedLoadingWidget.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class TransformarPresupuestosVentaAlertDialog extends StatefulWidget {
  final List<Models> presupuestos;

  const TransformarPresupuestosVentaAlertDialog({
    Key key, 
    this.presupuestos
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
          title: "Transformar presupuestos en venta"
        ),
        content: Container(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          width: SizeConfig.blockSizeHorizontal * 90,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              encabezado(),
              cuerpo(),
              ProgressButton.icon(
                radius: 7,
                iconedButtons: {
                  ButtonState.idle: IconedButton(
                      text: "Crear Venta",
                      icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                      color: Colors.blueAccent),
                  ButtonState.loading: IconedButton(
                      text: "Cargando", color: Colors.grey.shade400),
                  ButtonState.fail: IconedButton(
                      text: "Error",
                      icon: Icon(Icons.cancel, color: Colors.white),
                      color: Colors.red.shade300),
                  ButtonState.success: IconedButton(
                      text: "Éxito",
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      color: Colors.green.shade400)
                },
                onPressed: () async{
                  List<int> _lineasProducto = [];
                  List<LineasProducto> _nuevasLineas = new List<LineasProducto>();
                  _lineasVenta.forEach((element) {
                    if(element.idLineaProducto != null){
                      _lineasProducto.add(element.idLineaProducto);
                    }else{
                      _nuevasLineas.add(element);
                    }
                    
                  });

                  Map<String, dynamic> _payload = new Map<String, dynamic>();
                  _payload.addAll({
                    "Ventas":{
                      "IdUbicacion":_idUbicacion,
                      "IdDomicilio": _idDomicilio,
                    },
                    "LineasProducto": _lineasProducto,
                    "LineasVenta": _nuevasLineas
                  });

                  setState(() {
                    creatingVenta = true;
                  });
                  await PresupuestosService(scheduler: scheduler).doMethod(PresupuestosService().transformarPresupuestoEnVentaConfiguration(_payload)).then((response){
                    if(response.status == RequestStatus.SUCCESS){
                      print(response.message);
                    }else{
                      print("Ha ocurrido un error");
                    }
                  });
                  setState(() {
                    creatingVenta = false;
                  });
                },
                state: creatingVenta ? ButtonState.loading : ButtonState.idle,
              )
            ],
          )
        )
      );
      },
    );
  }

  Widget encabezado(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TopLabel(
                          padding: EdgeInsets.zero,
                          labelText: "Cliente",
                          fontSize: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            cliente,
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8)
                      ),
                      onChanged: (idSelected) {
                        setState(() {
                          _idUbicacion = idSelected;
                        });
                      },
                    )    
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                    constraints: BoxConstraints(minWidth: 200),
                    child: DropDownModelView(
                      service: ClientesService(),
                      listMethodConfiguration: ClientesService().listarDomiciliosConfiguration(_idCliente),
                      parentName: "Domicilios",
                      labelName: "Seleccione un domicilio",
                      displayedName: "Domicilio",
                      valueName: "IdDomicilio",
                      allOption: false,
                      errorMessage:
                        "Debe seleccionar un domicilio",
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8)
                      ),
                      onChanged: (idSelected) {
                        setState(() {
                          _idDomicilio = idSelected;
                        });
                      },
                    )
                  ),
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Container(
                    child: Text("Total: \$" + _total.toString()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cuerpo(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            Expanded(
              child: detallePresupuesto()
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal*1.5,
            ),
            Expanded(
              child: detalleVenta()
            ),
          ],
        ),
      ),
    );
  }

  Widget detallePresupuesto(){
    return Card(
      elevation: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical*5,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24)
                  )
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:2.5),
                  child: Text(
                    "Detalles de presupuestos",
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color
                    ),  
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Cantidad",
                  textAlign: TextAlign.center,
                )
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "Detalle",
                  textAlign: TextAlign.center,
                )
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Precio Unitario",
                  textAlign: TextAlign.center,  
                )
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Total",
                  textAlign: TextAlign.center,
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
          Divider(),
          Container(
            height: SizeConfig.blockSizeVertical*40,
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
                        flex: 2,
                        child: Text(
                          _lineaProducto.cantidad.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
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
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1)
                          ),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Text(
                          "\$"+_lineaProducto.precioUnitario.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                          ),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Text(
                          "\$"+(_lineaProducto.precioUnitario * _lineaProducto.cantidad).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
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
                          onPressed: (){
                            setState(() {
                              _lineasVenta.add(_lineaProducto);
                              _lineasPresupuesto.remove(_lineaProducto);
                              _total = _total + (_lineaProducto.cantidad * _lineaProducto.precioUnitario);
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
        ],
      ),
    );
  }

  Widget detalleVenta(){
    return Card(
      elevation: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: SizeConfig.blockSizeVertical*5,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(24)
                  )
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:2.5),
                  child: Text(
                    "Detalles de venta",
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color
                    ),  
                  ),
                ),
              ),
              Positioned(
                right: 2.5,
                top: SizeConfig.blockSizeVertical*2.5 - 24 ,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white70,
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
                              _total = _total + (lineaProducto.cantidad * lineaProducto.precioUnitario);
                            });
                          },
                        );
                      },
                    );
                  }
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Cantidad",
                  textAlign: TextAlign.center,
                )
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "Detalle",
                  textAlign: TextAlign.center,
                )
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Precio Unitario",
                  textAlign: TextAlign.center,  
                )
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Total",
                  textAlign: TextAlign.center,
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
          Divider(),
          Container(
            height: SizeConfig.blockSizeVertical*40,
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
                        flex: 2,
                        child: Text(
                          _lineaProducto.cantidad.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
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
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1)
                          ),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Text(
                          "\$"+_lineaProducto.precioUnitario.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                          ),
                        ),
                      ),
                      Expanded(
                        flex:2,
                        child: Text(
                          "\$"+(_lineaProducto.precioUnitario * _lineaProducto.cantidad).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
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
                          onPressed: (){
                            setState(() {
                              _lineasVenta.remove(_lineaProducto);
                              if(_lineaProducto.idLineaProducto != null){
                                _lineasPresupuesto.add(_lineaProducto);
                              }
                              _total = _total - (_lineaProducto.cantidad * _lineaProducto.precioUnitario);
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
        ],
      ),
    );
  }
}