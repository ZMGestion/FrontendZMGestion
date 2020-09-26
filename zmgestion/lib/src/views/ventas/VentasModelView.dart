import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/ventas/VentaCreadaAlertDialog.dart';
import 'package:zmgestion/src/views/ventas/VentaRevisionAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';

class VentasModelView extends StatefulWidget {
  final Ventas venta;
  final BuildContext context;
  final RequestScheduler scheduler;

  const VentasModelView({Key key, this.venta, this.context, this.scheduler}) : super(key: key);
  @override
  _VentasModelViewState createState() => _VentasModelViewState();
}

class _VentasModelViewState extends State<VentasModelView> {

  Ventas venta;
  RequestScheduler scheduler;
  var dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  Color color;
  String cliente, domicilio;
  List<Widget> _lineasVenta = [];

  @override
  void initState() {
    // TODO: implement initState
    if(widget.venta != null){
      venta = widget.venta;
      if (venta.cliente.apellidos != null && venta.cliente.nombres != null){
        cliente = venta.cliente.nombres + " " + venta.cliente.apellidos;
      }else{
        cliente = venta.cliente.razonSocial;
      }
      if(venta.cliente.domicilio?.domicilio != null){
      domicilio = venta.cliente.domicilio.domicilio;
      }else{
        domicilio = "";
      }
      switch (venta.estado) {
        case 'A':{
          color = Colors.red;
        }
        break;
        case 'N':{
          color = Colors.green;
        }
        break;
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    venta.lineasProducto.forEach((element) {
      _lineasVenta.add(detalleLineaVenta(element, context));
    });
    if(color == null){
      color = Theme.of(context).primaryColor;   
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12,6,12,6),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            dateFormat.format(venta.fechaAlta),
                            style: TextStyle(
                              fontSize: 12
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            Ventas().mapEstados()[venta.estado],
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                                    venta.usuario.nombres + " " + venta.usuario.apellidos,
                                    style: TextStyle(
                                      color: Color(0xff97D2FF).withOpacity(1),
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
                                  labelText: "Ubicación",
                                  fontSize: 14,
                                  color: Color(0xff97D2FF).withOpacity(1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    venta.ubicacion?.ubicacion,
                                    style: TextStyle(
                                      color: Color(0xff97D2FF).withOpacity(1),
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
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
                                  color: Color(0xff97D2FF).withOpacity(1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    cliente,
                                    style: TextStyle(
                                      color: Color(0xff97D2FF).withOpacity(1),
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
                                  labelText: "Domicilio",
                                  fontSize: 14,
                                  color: Color(0xff97D2FF).withOpacity(1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    domicilio,
                                    style: TextStyle(
                                      color: Color(0xff97D2FF).withOpacity(1),
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                     Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:2.5),
                        child: Text(
                          "Detalles de venta",
                           style: TextStyle(
                            color: Color(0xff97D2FF).withOpacity(1),
                            fontWeight: FontWeight.bold
                          ), 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                          flex:1,
                          child: Text(
                            "Estado"
                          )
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
                      thickness: 2,
                    ),
                    Column(
                      children: _lineasVenta,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container()
                        ),
                        Expanded(
                          flex:1,
                          child: Text(
                            "Total: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                            ),
                          )
                        ),
                        Expanded(
                          flex:2,
                          child: Text(
                            "\$" + venta.precioTotal.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                            ),
                          )
                        ),
                        Expanded(
                          flex:1,
                          child: Text(
                            ""
                          )
                        ),
                      ],
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
    );
  }
    Widget actions(BuildContext context, RequestScheduler scheduler){
      final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(context);
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: venta.estado == 'E',
            child: ZMTextButton(
              text: "Finalizar venta",
              color: Theme.of(context).primaryColor,
              onPressed: () async{
                await VentasService(scheduler: scheduler).doMethod(VentasService().chequearVentaConfiguration(venta.idVenta)).then((response) async{
                  if (response.status == RequestStatus.SUCCESS){
                    Ventas venta = new Ventas().fromMap(response.message);
                    if (venta.estado == 'C'){
                      await showDialog(
                        context: context,
                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return VentaCreadaDialog(
                            venta: venta
                          );
                        },
                      );
                    }else{
                      await showDialog(
                        context: context,
                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                        barrierDismissible: false,
                        builder: (BuildContext context){
                          return VentaRevisionAlertDialog(
                            venta: venta
                          );
                        }
                      );
                    }
                    Navigator.pop(context, true);
                  }
                });
              },
            )
          ),
          Visibility(
            visible: _usuariosProvider.usuario.idRol == 1 && venta.estado == "R",
            child: Row(
              children: [
                ZMTextButton(
                  text: "No Autorizar",
                  color: Colors.red,
                  onPressed: () async{
                    await VentasService(scheduler: scheduler).doMethod(VentasService().cancelarVentaConfiguration(venta.idVenta)).then((response) async{
                      if (response.status == RequestStatus.SUCCESS){
                        Navigator.pop(context, true);
                      }
                    });
                  },
                ),
                ZMTextButton(
                  text: "Autorizar",
                  color: Colors.green,
                  onPressed: () async{
                    await VentasService(scheduler: scheduler).doMethod(VentasService().revisarVentaConfiguration(venta.idVenta)).then((response) async{
                      if (response.status == RequestStatus.SUCCESS){
                        Navigator.pop(context, true);
                      }
                    });
                  },
                ),
              ],
            )
          ),
        ],
      );
    }
    Widget detalleLineaVenta(LineasProducto lp, BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              lp.cantidad.toString(),
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
              lp.productoFinal.producto.producto + 
              " " + (lp.productoFinal.tela?.tela??"") +
              " " + (lp.productoFinal.lustre?.lustre??""),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1)
              ),
            ),
          ),
          Expanded(
            flex:2,
            child: Text(
              "\$"+lp.precioUnitario.toString(),
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
              "\$"+(lp.precioUnitario * lp.cantidad).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
              ),
            ),
          ),
          Expanded(
            flex:1,
            child: Text(
              lp.estado,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
              ),
            ),
          ),
          Expanded(
            flex:1,
            child: Visibility(
              visible: lp.estado != 'C' && venta.estado == 'C',
              child: IconButtonTableAction(
                iconData: Icons.arrow_downward,
                color: Colors.red,
                onPressed: () async{
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Cancelar Venta",
                          style: TextStyle(
                            color: Theme.of(context).primaryTextTheme.bodyText1.color,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        content: Text(
                          "¿Está seguro que desea cancelar la línea?",                     
                        ),
                        actions: [
                          ZMTextButton(
                            text: "Cancelar",
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              Navigator.pop(context, false);
                            },
                          ),
                          ZMTextButton(
                            text: "Aceptar",
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      );
                    },
                  ).then((value) async{
                    if(value){
                      await VentasService(scheduler: scheduler).doMethod(VentasService().cancelarLineaVentaConfiguration({
                        "LineasProducto":{
                          "IdLineaProducto":lp.idLineaProducto
                        }
                      })).then((response) async{
                        if (response.status == RequestStatus.SUCCESS){
                          await VentasService(scheduler: scheduler).damePor(VentasService().dameConfiguration(venta.idVenta)).then((response){
                            if (response.status == RequestStatus.SUCCESS){
                              setState(() {
                                venta = response.message;
                              });
                            }
                          });
                        }
                      });
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}