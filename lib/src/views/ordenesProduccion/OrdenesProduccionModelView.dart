import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/main.dart';
import 'package:zmgestion/src/helpers/PDFManager.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/comprobantes/OperacionesComprobanteAlertDialog.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionVerificarLinea.dart';
import 'package:zmgestion/src/views/ordenesProduccion/TareasAlertDialog.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class OrdenesProduccionModelView extends StatefulWidget {
  final OrdenesProduccion ordenProduccion;
  final BuildContext context;
  final RequestScheduler scheduler;

  const OrdenesProduccionModelView({
    Key key, 
    this.ordenProduccion, 
    this.context,
    this.scheduler
  }) : super(key: key);
  
  @override
  _OrdenesProduccionModelViewState createState() => _OrdenesProduccionModelViewState();
}

class _OrdenesProduccionModelViewState extends State<OrdenesProduccionModelView> {

  OrdenesProduccion ordenProduccion;
  RequestScheduler scheduler;
  var dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  Color color;
  String domicilio;
  List<Widget> _lineasOrdenProduccion = [];

  Map<int, bool> _idsLineas = Map<int, bool>();

  @override
  void initState() {
    if(widget.ordenProduccion != null){
      ordenProduccion = widget.ordenProduccion;
      switch (ordenProduccion.estado) {
        case 'C':
          color = Colors.red;
          break;
        case 'V':
          color = Colors.green;
          break;
        default:
          color = Theme.of(mainContext).primaryColor;
      }
      ordenProduccion.lineasProducto.forEach((element) {
        _lineasOrdenProduccion.add(
          DetalleLineaOrdenProduccion(
            lineaOrdenProduccion: element,
            ordenProduccion: ordenProduccion,
            onChanged: (idLineaOrdenProduccion, selected){
              if(_idsLineas.containsKey(idLineaOrdenProduccion)){
                _idsLineas[idLineaOrdenProduccion] = selected;
              }else{
                _idsLineas.addAll({idLineaOrdenProduccion: selected});
              }
              setState(() {
                if(_idsLineas.containsValue(true)){
                  _verifyEnabled = true;
                }else{
                  _verifyEnabled = false;
                }
              });
            },
            reloadFunc: _reload
          )
        );
      });
    }
    super.initState();
  }

  _reload() async{
    await OrdenesProduccionService().damePor(OrdenesProduccionService().dameConfiguration(widget.ordenProduccion.idOrdenProduccion)).then((response){
      if (response.status == RequestStatus.SUCCESS){
        OrdenesProduccion _ordenProduccion = response.message;
        List<Widget> _nuevasLineas = [];
        _ordenProduccion.lineasProducto.forEach((lop) {
          _nuevasLineas.add(DetalleLineaOrdenProduccion(
            lineaOrdenProduccion: lop,
            ordenProduccion: widget.ordenProduccion,
            reloadFunc: _reload,
            onChanged: (idLineaOrdenProduccion, selected){
              setState(() {
                if(_idsLineas.containsKey(idLineaOrdenProduccion)){
                  _idsLineas[idLineaOrdenProduccion] = selected;
                }else{
                  _idsLineas.addAll({idLineaOrdenProduccion: selected});
                }
                if(_idsLineas.containsValue(true)){
                  _verifyEnabled = true;
                }else{
                  _verifyEnabled = false;
                }
              });
            },
          ));
          setState(() {
            ordenProduccion = _ordenProduccion;
            _lineasOrdenProduccion = _nuevasLineas;
          });
        });
      }
    });
  }

  List<int> _idsLineasOrdenProduccion(Map<int, bool> _idsSelected){
    List<int> _ids = [];
    _idsSelected.forEach((id, selected) {
      if(selected){
        _ids.add(id);
      }
    });
    return _ids;
  }

  bool _verifyEnabled = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.blockSizeHorizontal*70,
      constraints: BoxConstraints(
        minWidth: 800,
        maxWidth: 1200,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Orden de producción: ',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: OrdenesProduccion().mapEstados()[ordenProduccion.estado],
                            style: TextStyle(
                              color: Colors.blue
                            )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GFIconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7),
                  ),
                  shape: GFIconButtonShape.circle,
                  color: Theme.of(context).cardColor,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12,0,12,6),
              child: Column(
                children: [
                  Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
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
                                        labelText: "Empleado",
                                        fontSize: 14,
                                        color: Color(0xff97D2FF).withOpacity(1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Text(
                                          ordenProduccion.usuario.nombres + " " + ordenProduccion.usuario.apellidos,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: SizeConfig.blockSizeHorizontal*2.5,),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TopLabel(
                                        padding: EdgeInsets.zero,
                                        labelText: "Fecha creación",
                                        fontSize: 14,
                                        color: Color(0xff97D2FF).withOpacity(1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Text(
                                          dateFormat.format(ordenProduccion.fechaAlta),
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Card(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: Color(0xfff7f7f7),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black.withOpacity(0.1),
                                width: 1
                              )
                            )
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container()
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Cantidad",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Detalle",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ),
                              Expanded(
                                flex:1,
                                child: Text(
                                  "Estado",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                flex:2,
                                child: Text(
                                  ""
                                )
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            children: _lineasOrdenProduccion,
                          ),
                        )
                      ],
                    ),
                  ),
                  actions(context, scheduler)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
    Widget actions(BuildContext context, RequestScheduler scheduler){
      //final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(context);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ZMStdButton(
              color: Theme.of(context).primaryColorLight,
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              text: Text(
                "Verificar",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: !_verifyEnabled ? null : ()async{
                await showDialog(
                  context: context,
                  barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                  barrierDismissible: false,
                  builder: (context) {
                    return OrdenesProduccionVerificarLinea(
                      idsLineaOrdenProduccion: _idsLineasOrdenProduccion(_idsLineas),
                      onSuccess: () async{
                        await _reload();
                      },
                    );
                  }
                );
              },
            ),
            SizedBox(
              width: 8,
            ),
            ZMStdButton(
              color: Theme.of(context).primaryColorLight,
              icon: Icon(
                Icons.print_outlined,
                color: Colors.white,
              ),
              text: Text(
                "Imprimir",
                style: TextStyle(
                  color: Colors.white
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
          ],
        ),
      );
    }
}

class DetalleLineaOrdenProduccion extends StatefulWidget {
  final OrdenesProduccion ordenProduccion;
  final Function(int idSeleccionado, bool value) onChanged;
  final LineasProducto lineaOrdenProduccion;
  final Function() reloadFunc;

  const DetalleLineaOrdenProduccion({
    Key key, 
    this.ordenProduccion,
    this.onChanged, 
    this.lineaOrdenProduccion,
    this.reloadFunc
  }) : super(key: key);

  @override
  _DetalleLineaOrdenProduccionState createState() => _DetalleLineaOrdenProduccionState();
}

class _DetalleLineaOrdenProduccionState extends State<DetalleLineaOrdenProduccion> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: CircularCheckBox(
              value: value,
              onChanged: widget.lineaOrdenProduccion.estado != 'I' ? null : (_value){
                setState(() {
                  value = !value;
                });
                if(widget.onChanged != null){
                  widget.onChanged(widget.lineaOrdenProduccion.idLineaProducto, _value);
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.lineaOrdenProduccion.cantidad?.toString()??"",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              widget.lineaOrdenProduccion.productoFinal.producto.producto + 
              " " + (widget.lineaOrdenProduccion.productoFinal.tela?.tela??"") +
              " " + (widget.lineaOrdenProduccion.productoFinal.lustre?.lustre??""),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87
              ),
            ),
          ),
          Expanded(
            flex:1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    LineasProducto().mapEstados()[widget.lineaOrdenProduccion.estado??""]??"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Expanded(
            flex:2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZMTooltip(
                  message: "Ver tareas",
                  child: IconButtonTableAction(
                    iconData: Icons.alt_route,
                    color: Colors.blue,
                    onPressed: () async{
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                        builder: (BuildContext context) {
                          return TareasAlertDialog(
                            lineaOrdenProduccion: widget.lineaOrdenProduccion,
                            onClose: widget.reloadFunc,
                          );
                        },
                      );
                    },
                  ),
                ),
                ZMTooltip(
                  message: widget.lineaOrdenProduccion.estado == 'C' ? "Reanudar producción" : "Cancelar producción",
                  theme: widget.lineaOrdenProduccion.estado == 'C' ? ZMTooltipTheme.BLUE : ZMTooltipTheme.RED,
                  child: IconButtonTableAction(
                    iconData: widget.lineaOrdenProduccion.estado == 'C' ? Icons.play_circle_fill : Icons.cancel_outlined,
                    color: widget.lineaOrdenProduccion.estado == 'C' ? Colors.blue : Colors.orange,
                    disabledBackgroundColor: Colors.black.withOpacity(0.05),
                    onPressed: () async{
                      await showDialog(
                        context: context,
                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              widget.lineaOrdenProduccion.estado == 'C' ? "Reanudar linea de orden de producción" : "Cancelar linea de orden de producción",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            content: Text(
                              widget.lineaOrdenProduccion.estado == 'C' ? "¿Está seguro que desea reanudar la línea?" : "¿Está seguro que desea cancelar la línea?",                 
                            ),
                            actions: [
                              ZMTextButton(
                                text: "Aceptar",
                                color: Theme.of(mainContext).primaryColor,
                                onPressed: () async{
                                  if(widget.lineaOrdenProduccion.estado == 'C'){
                                    await OrdenesProduccionService().doMethod(OrdenesProduccionService().reanudarLineaOrdenProduccion({
                                      "LineasProducto":{
                                        "IdLineaProducto":widget.lineaOrdenProduccion.idLineaProducto
                                      }
                                    })).then((response) async{
                                      if (response.status == RequestStatus.SUCCESS){
                                        if(widget.reloadFunc != null){
                                          widget.reloadFunc();
                                        }
                                      }
                                    });
                                  }else{
                                    await OrdenesProduccionService().doMethod(OrdenesProduccionService().cancelarLineaOrdenProduccio({
                                      "LineasProducto":{
                                        "IdLineaProducto":widget.lineaOrdenProduccion.idLineaProducto
                                      }
                                    })).then((response) async{
                                      if (response.status == RequestStatus.SUCCESS){
                                        if(widget.reloadFunc != null){
                                          widget.reloadFunc();
                                        }
                                      }
                                    });
                                  }
                                  Navigator.pop(context, false);
                                },
                              ),
                              ZMTextButton(
                                text: "Cancelar",
                                color: Theme.of(mainContext).primaryColor,
                                onPressed: (){
                                  Navigator.pop(context, false);
                                },
                              ),
                            ],
                          );
                        }
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}