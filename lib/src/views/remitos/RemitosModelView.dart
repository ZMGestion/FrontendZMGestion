import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:zmgestion/src/helpers/PDFManager.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Remitos.dart';
import 'package:zmgestion/src/services/RemitosService.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class RemitosModelView extends StatefulWidget {

  final Remitos remito;
  final BuildContext context;
  final RequestScheduler scheduler;

  const RemitosModelView({Key key, this.remito, this.context, this.scheduler}) : super(key: key);

  @override
  _RemitosModelViewState createState() => _RemitosModelViewState();
}

class _RemitosModelViewState extends State<RemitosModelView> {

  Remitos remito;
  String ubicacion;
  var dateFormat;
  List<Widget> _lineasRemito;
  Color stateColor;
  bool change = false;
  String direccionEntrega = "";

  @override
  void initState() {
    _lineasRemito = new List<Widget>();
    if(widget.remito != null){
      remito = widget.remito;
      if(remito.tipo == 'E' || remito.tipo == 'X'){
        if(remito.ubicacion.ubicacion != null){
          direccionEntrega = remito.ubicacion.ubicacion; 
        }
      }else{
        if(remito.venta?.idVenta != null){
          direccionEntrega = remito.venta.domicilio.domicilio;
        }
      }
      remito.lineasProducto.forEach((lr) {
        _lineasRemito.add(_detalleLineaRemito(lr));
      });
      switch (remito.estado){
        case "B":  {
          stateColor = Colors.red;
          break;
        }
        case "N": {
          stateColor = Colors.green;
          break;
        }
        default :{
          stateColor = Colors.blue;
          break;
        }
      }

    }else{
      direccionEntrega = "-";
    }
    dateFormat = DateFormat("dd/MM/yyyy HH:mm");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.blockSizeHorizontal*50,
      constraints: BoxConstraints(
        minWidth: 600,
        maxWidth: 1000,
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
                        text: 'Remito: ',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: Remitos().mapEstados()[remito.estado],
                            style: TextStyle(
                              color: stateColor
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
                    Navigator.of(context).pop(change);
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12,6,12,6),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TopLabel(
                                padding: const EdgeInsets.all(0),
                                labelText:"Código",
                                fontSize: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  remito.idRemito.toString(),
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
                      SizedBox(width: SizeConfig.blockSizeHorizontal*1.5,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  dateFormat.format(remito.fechaAlta),
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
                      SizedBox(width: SizeConfig.blockSizeHorizontal*1.5,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TopLabel(
                                padding: const EdgeInsets.all(0),
                                labelText:"Fecha de entrega",
                                fontSize: 13,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  remito.fechaEntrega != null ? dateFormat.format(remito.fechaEntrega) : "No se ha entregado aún",
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
                      SizedBox(width: SizeConfig.blockSizeHorizontal*1.5,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TopLabel(
                                padding: const EdgeInsets.all(0),
                                labelText:"Tipo de Remito",
                                fontSize: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  Remitos().mapTipos()[remito.tipo],
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
                    ],
                  ),
                  Container(
                    child: Card(
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
                                            remito.usuario.nombres + " " + remito.usuario.apellidos,
                                            style: TextStyle(
                                              color: Color(0xff97D2FF).withOpacity(1),
                                              fontWeight: FontWeight.w600
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
                                          labelText: "Direccón de entrega",
                                          fontSize: 14,
                                          color: Color(0xff97D2FF).withOpacity(1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text(
                                            direccionEntrega,
                                            style: TextStyle(
                                              color: Color(0xff97D2FF).withOpacity(1),
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6
                            ),
                            remito.venta?.idVenta != null ? 
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
                                            Utils.clientName(remito.venta.cliente),
                                            style: TextStyle(
                                              color: Color(0xff97D2FF).withOpacity(1),
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*2.5,),
                                Expanded(
                                  child: Container(),
                                ),
                              ],
                            ): Container(),
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
                                          labelText: "Observaciones",
                                          fontSize: 14,
                                          color: Color(0xff97D2FF).withOpacity(1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text(
                                            remito.observaciones != null ? remito.observaciones : '',
                                            style: TextStyle(
                                              color: Color(0xff97D2FF).withOpacity(1),
                                              fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.blockSizeHorizontal*2.5,),
                                Expanded(
                                  child: Container(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Cantidad",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Detalle",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Ubicación de Salida",
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    ), 
                                  )
                                ),
                                Expanded(
                                  flex:1,
                                  child: Text(
                                    "Estado",
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Column(
                              children: _lineasRemito,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppLoader(
                    builder: (RequestScheduler scheduler){ 
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: remito.estado == "C",
                            child: ZMTextButton(
                              text: "Entregar Remito",
                              color: Colors.green,
                              onPressed: () async{
                                await RemitosService(scheduler: scheduler).doMethod(RemitosService().entregar({"Remitos": {"IdRemito": remito.idRemito}})).then((response) async{
                                  if(response.status == RequestStatus.SUCCESS){
                                    setState(() { 
                                      remito = Remitos().fromMap(response.message);
                                      stateColor = Colors.green;
                                      change = true;                                      
                                    });
                                    await Printing.layoutPdf(onLayout: (format) => PDFManager.generarRemitoPDF(
                                      format, 
                                      remito
                                    ));
                                  }
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: remito.estado == "N",
                                child: ZMTextButton(
                                  text: "Ver Documento",
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async{
                                    await Printing.layoutPdf(onLayout: (format) => PDFManager.generarRemitoPDF(
                                      format, 
                                      remito
                                    ));
                                  },
                                ),
                              ),
                            ],
                          )
                        ] 
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detalleLineaRemito(LineasProducto lp){
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
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
            flex:3,
            child: Text(
              lp.idUbicacion != null ? lp.ubicacion.ubicacion : "-",
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
              LineasProducto().mapEstados()[lp.estado],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}