import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class ProductosFinalesStockDialog extends StatefulWidget {
  final ProductosFinales productoFinal;
  final Function(Map<String, dynamic> response) onAccept;
  final int cantidadSolicitada;

  const ProductosFinalesStockDialog({Key key, this.productoFinal, this.onAccept, this.cantidadSolicitada}) : super(key: key);
  @override
  _ProductosFinalesStockDialogState createState() => _ProductosFinalesStockDialogState();
}

class _ProductosFinalesStockDialogState extends State<ProductosFinalesStockDialog> {
  final _formKey = GlobalKey<FormState>();

  ProductosFinales productoFinal;
  int idUbicacion;
  int cantidad;
  int _cantidadTotal;
  int _cantidadSolicitada;

  @override
  void initState() {
    if(widget.productoFinal != null){
      productoFinal = widget.productoFinal;
    }
    if(widget.cantidadSolicitada != null){
      _cantidadSolicitada = widget.cantidadSolicitada;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(
      builder: (scheduler) {
        return AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(6,6,6,0),
          contentPadding: EdgeInsets.all(4),
          insetPadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(4),
          buttonPadding: EdgeInsets.all(4),
          elevation: 1.5,
          scrollable: true,
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          actions: [
            ZMStdButton(
              text: Text(
                "Aceptar",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              color: Colors.green,
              disabledColor: Colors.grey,
              disable: idUbicacion == null || idUbicacion == 0,
              onPressed: (){
                if(_formKey.currentState.validate()){
                  Map<String, dynamic> response = new Map<String, dynamic>();
                  response.addAll(
                    {
                      "IdUbicacion": idUbicacion,
                        //"Ubicacion": ubicacion,
                      "Cantidad": cantidad,
                    }
                  );
                  widget.onAccept(response);
                }
              },
            ),
          ],
          content: Container(
            width: SizeConfig.blockSizeHorizontal*35,
            constraints: BoxConstraints(
              minWidth: 600,
              maxWidth: 1000,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                    child: Card(
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _cardItem(
                              title: "Producto",
                              content: productoFinal.producto.producto
                            ),
                            _cardItem(
                              title: "Lustre",
                              content: productoFinal.lustre != null ? productoFinal.lustre.lustre != null ? productoFinal.lustre.lustre : "-" : "-"
                            ),
                            _cardItem(
                              title: "Tela",
                              content: productoFinal.tela != null ? productoFinal.tela.tela != null ? productoFinal.tela.tela : "-" : "-"
                            ),
                            _cardItem(
                              title: "Cantidad Solicitada",
                              content: _cantidadSolicitada.toString()
                            ),
                            _cardItem(
                              title: "Stock Disponible",
                              content: productoFinal.cantidad.toString()
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TopLabel(
                              labelText: "Ubicación",
                            ),
                            DropDownModelView(
                              service: UbicacionesService(),
                              listMethodConfiguration: UbicacionesService().listar(),
                              parentName: "Ubicaciones",
                              labelName: "Seleccione una ubicación",
                              displayedName: "Ubicacion",
                              valueName: "IdUbicacion",
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 8)
                              ),
                              onChanged: (idSelected) async{
                                await ProductosFinalesService().doMethod(ProductosFinalesService().dameStock({
                                  "Ubicaciones":{
                                    "IdUbicacion": idSelected
                                  },
                                  "ProductosFinales":{
                                    "IdProductoFinal": productoFinal.idProductoFinal
                                  }
                                })).then((response){
                                  if(response.status == RequestStatus.SUCCESS){
                                    ProductosFinales _productoFinal = ProductosFinales().fromMap(response.message);
                                    setState(() {
                                      _cantidadTotal = _productoFinal.cantidad;
                                    });
                                  }
                                });
                                setState(() {
                                  idUbicacion = idSelected;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:8),
                              child: Visibility(
                                visible: idUbicacion != null && idUbicacion != 0 && _cantidadTotal > 0,
                                child: Form(
                                  key: _formKey,
                                  child: SpinBox(
                                    enabled: idUbicacion != null && idUbicacion != 0 && _cantidadTotal > 0,
                                    direction: Axis.horizontal,
                                    max: _cantidadSolicitada.toDouble(),
                                    decimals: 0,
                                    validator: (value){
                                      return Validator.greaterValidator(int.parse(value), 0);
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Cantidad"
                                    ),
                                    onChanged: (value){
                                      setState(() {
                                        cantidad = value.toInt();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 4,
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
                                  "Total Disponible",
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
                                        idUbicacion == null ? "-" : _cantidadTotal.toString(),
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
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  Widget _cardItem({String title = "", String content = ""}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title+": ",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.85),
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              content,
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(1),
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
  }
}