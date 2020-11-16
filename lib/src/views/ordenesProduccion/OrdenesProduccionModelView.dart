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
        _lineasOrdenProduccion.add(detalleLineaOrdenProduccion(element, context));
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.blockSizeHorizontal*50,
      constraints: BoxConstraints(
        minWidth: 500,
        maxWidth: 800,
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
                                        labelText: "Usuario",
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
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
                                flex:1,
                                child: Text(
                                  "Estado",
                                  textAlign: TextAlign.center,
                                )
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                flex:1,
                                child: Text(
                                  ""
                                )
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Column(
                            children: _lineasOrdenProduccion,
                          )
                        ],
                      ),
                    ),
                  ),
                  AppLoader(
                    builder: (RequestScheduler scheduler){ 
                      return actions(context, scheduler);
                    }),
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
    Widget detalleLineaOrdenProduccion(LineasProducto lp, BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              lp.cantidad?.toString()??"",
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
              lp.productoFinal.producto.producto + 
              " " + (lp.productoFinal.tela?.tela??"") +
              " " + (lp.productoFinal.lustre?.lustre??""),
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
                    LineasProducto().mapEstados()[lp.estado??""]??"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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
            flex:1,
            child: Row(
              children: [
                ZMTooltip(
                  message: "Ver tareas",
                  child: IconButtonTableAction(
                    iconData: Icons.alt_route,
                    color: Colors.blue,
                    onPressed: () async{
                      await showDialog(
                        context: context,
                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                        builder: (BuildContext context) {
                          return TareasAlertDialog(
                            lineaOrdenProduccion: lp,
                          );
                        },
                      );
                    },
                  ),
                ),
                ZMTooltip(
                  message: lp.estado == 'C' ? "Reanudar producción" : "Cancelar producción",
                  theme: lp.estado == 'C' ? ZMTooltipTheme.BLUE : ZMTooltipTheme.RED,
                  child: IconButtonTableAction(
                    iconData: lp.estado == 'C' ? Icons.play_circle_fill : Icons.cancel_outlined,
                    color: lp.estado == 'C' ? Colors.blue : Colors.orange,
                    onPressed: () async{
                      await showDialog(
                        context: context,
                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              lp.estado == 'C' ? "Reanudar linea de orden de producción" : "Cancelar linea de orden de producción",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            content: Text(
                              lp.estado == 'C' ? "¿Está seguro que desea reanudar la línea?" : "¿Está seguro que desea cancelar la línea?",                 
                            ),
                            actions: [
                              ZMTextButton(
                                text: "Aceptar",
                                color: Theme.of(mainContext).primaryColor,
                                onPressed: () async{
                                  if(lp.estado == 'C'){
                                    await OrdenesProduccionService(scheduler: scheduler).doMethod(OrdenesProduccionService().reanudarLineaOrdenProduccion({
                                      "LineasProducto":{
                                        "IdLineaProducto":lp.idLineaProducto
                                      }
                                    })).then((response) async{
                                      if (response.status == RequestStatus.SUCCESS){
                                        await OrdenesProduccionService(scheduler: scheduler).damePor(OrdenesProduccionService().dameConfiguration(ordenProduccion.idOrdenProduccion)).then((response){
                                          if (response.status == RequestStatus.SUCCESS){
                                            setState(() {
                                              ordenProduccion = response.message;
                                              _lineasOrdenProduccion = [];
                                              ordenProduccion.lineasProducto.forEach((element) {
                                                _lineasOrdenProduccion.add(detalleLineaOrdenProduccion(element, context));
                                              });
                                            });
                                          }
                                        });
                                      }
                                    });
                                  }else{
                                    await OrdenesProduccionService(scheduler: scheduler).doMethod(OrdenesProduccionService().cancelarLineaOrdenProduccio({
                                      "LineasProducto":{
                                        "IdLineaProducto":lp.idLineaProducto
                                      }
                                    })).then((response) async{
                                      if (response.status == RequestStatus.SUCCESS){
                                        await OrdenesProduccionService(scheduler: scheduler).damePor(OrdenesProduccionService().dameConfiguration(ordenProduccion.idOrdenProduccion)).then((response){
                                          if (response.status == RequestStatus.SUCCESS){
                                            ordenProduccion = response.message;
                                            List<Widget> _nuevasLineas = [];
                                            ordenProduccion.lineasProducto.forEach((element) {
                                              _nuevasLineas.add(detalleLineaOrdenProduccion(element, context));
                                            });
                                            setState(() {
                                              _lineasOrdenProduccion = _nuevasLineas;
                                            });
                                          }
                                        });
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