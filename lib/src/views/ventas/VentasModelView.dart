import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/main.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/comprobantes/OperacionesComprobanteAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

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
  String cliente;
  String domicilio;
  List<Widget> _lineasVenta = [];
  bool _loading = false;

  @override
  void initState() {

    if(widget.venta != null){
      venta = widget.venta;
      if (venta.cliente.apellidos != null && venta.cliente.nombres != null){
        cliente = venta.cliente.nombres + " " + venta.cliente.apellidos;
      }else{
        cliente = venta.cliente.razonSocial;
      }
      if(venta.domicilio != null){
        domicilio = venta.domicilio.domicilio ?? '' ; 
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
        default:{
          color = Theme.of(mainContext).primaryColor;
        }
      }
      venta.lineasProducto.forEach((element) {
        _lineasVenta.add(detalleLineaVenta(element, context));
      });
    }
    _loading = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.blockSizeHorizontal*60,
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
                        text: 'Venta: ',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: Ventas().mapEstados()[venta.estado],
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
              padding: const EdgeInsets.fromLTRB(12,6,12,6),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TopLabel(
                                  padding: const EdgeInsets.all(0),
                                  labelText:"Fecha de alta",
                                  fontSize: 12,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    dateFormat.format(venta.fechaAlta),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.5
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*2.5,),
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
                                        labelText: "Empleado",
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
                        ],
                      ),
                    ),
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
                                flex: 2,
                                child: Text(
                                  "Cantidad",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.85)
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
                                flex: 2,
                                child: Text(
                                  "Precio Unitario",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,  
                                )
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Total",
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
                              Expanded(
                                flex:2,
                                child: Text(
                                  ""
                                )
                              ),
                            ],
                          ),
                        ),
                        _loading ? CircularProgressIndicator(): Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            children: _lineasVenta,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xfff7f7f7),
                            border: Border(
                              top: BorderSide(
                                color: Colors.black.withOpacity(0.1),
                                width: 1
                              )
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                flex:1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Facturado: ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "\$" + venta.facturado.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                flex:1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Pagado: ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "\$" + venta.pagado.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                flex:1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Total: ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "\$" + venta.precioTotal.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ),
                            ],
                          ),
                        )
                      ],
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
      final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(context);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ZMTextButton(
                text: "Ver Comprobantes",
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  final NavigationService _navigationService = locator<NavigationService>();
                  _navigationService.navigateTo("/comprobantes?IdVenta="+venta.idVenta.toString());
                },
              ),
            ],
          ),
          Visibility(
            visible: _usuariosProvider.usuario.idRol == 1 && venta.estado == "R",
            child: Row(
              children: [
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
              flex:2,
              child: Text(
                "\$"+lp.precioUnitario.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
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
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              flex:1,
              child: Text(
                LineasProducto().mapEstados()[lp.estado??""]??"",
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 12
                ),
              ),
            ),
            Expanded(
              flex:2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZMTooltip(
                    message: "Ver orden de producción",
                    theme: ZMTooltipTheme.BLUE,
                    child: IconButtonTableAction(
                      iconData: FontAwesomeIcons.hammer,
                      iconSize: 12,
                      disabledBackgroundColor: Colors.black.withOpacity(0.05),
                      color: Colors.blue,
                      onPressed: lp.idOrdenProduccion == null ? null : () async{
                        final NavigationService _navigationService = locator<NavigationService>();
                        _navigationService.navigateTo("/ordenes-produccion?IdOrdenProduccion="+lp.idOrdenProduccion.toString());
                      },
                    ),
                  ),
                  ZMTooltip(
                    message: "Ver remito",
                    theme: ZMTooltipTheme.BLUE,
                    child: IconButtonTableAction(
                      iconData: FontAwesomeIcons.truck,
                      iconSize: 12,
                      disabledBackgroundColor: Colors.black.withOpacity(0.05),
                      color: Colors.blue,
                      onPressed: lp.idRemito == null ? null : () async{
                        final NavigationService _navigationService = locator<NavigationService>();
                        _navigationService.navigateToWithReplacement('/remitos?IdRemito='+ lp.idRemito.toString());
                      },
                    ),
                  ),
                  Visibility(
                    visible: lp.estado != 'C' && venta.estado == 'C',
                    child: ZMTooltip(
                      message: "Cancelar linea",
                      theme: ZMTooltipTheme.RED,
                      child: IconButtonTableAction(
                        iconData: Icons.cancel_outlined,
                        color: Colors.orange,
                        onPressed: () async{
                          await showDialog(
                            context: context,
                            barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Cancelar linea de venta",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                content: Text(
                                  "¿Está seguro que desea cancelar la línea?",                     
                                ),
                                actions: [
                                  ZMTextButton(
                                    text: "Aceptar",
                                    color: Theme.of(mainContext).primaryColor,
                                    onPressed: () async{
                                      if((venta.precioTotal - lp.precioUnitario * lp.cantidad) < venta.facturado){
                                        await showDialog(
                                          context: context,
                                          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                          builder: (BuildContext context) {
                                            return OperacionesComprobanteAlertDialog(
                                              title: "Crear Comprobante",
                                              comprobante: Comprobantes(idVenta: venta.idVenta,),
                                              operacion: "Crear",
                                              
                                            );
                                          },
                                        ).then((value) async{
                                          await VentasService(scheduler: scheduler).damePor(VentasService().dameConfiguration(venta.idVenta)).then((response){
                                            if (response.status == RequestStatus.SUCCESS){
                                              setState(() {
                                                _loading = true;
                                                venta = response.message;
                                                _lineasVenta = [];
                                                venta.lineasProducto.forEach((element) {
                                                  _lineasVenta.add(detalleLineaVenta(element, context));
                                                });
                                                _loading = false;
                                              });
                                            }
                                          });
                                        });
                                      }
                                      Navigator.pop(context, true);
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
                                        _loading = true;
                                        venta = response.message;
                                        _lineasVenta = [];
                                        venta.lineasProducto.forEach((element) {
                                          _lineasVenta.add(detalleLineaVenta(element, context));
                                        });
                                        _loading = false;
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
            ),
          ],
        ),
      );
  }
}