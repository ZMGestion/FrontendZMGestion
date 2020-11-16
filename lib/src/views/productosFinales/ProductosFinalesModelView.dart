import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/views/productosFinales/MoverProductoAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class ProductosFinalesModelView extends StatefulWidget {
  final ProductosFinales productoFinal;

  const ProductosFinalesModelView({Key key, this.productoFinal}) : super(key: key);

  @override
  _ProductosFinalesModelViewState createState() => _ProductosFinalesModelViewState();
}

class _ProductosFinalesModelViewState extends State<ProductosFinalesModelView> {

  ProductosFinales productoFinal;
  int _idUbicacion;
  int _cantidadTotal;

  @override
  void initState() {
    if(widget.productoFinal != null){
      this.productoFinal = widget.productoFinal;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Mueble',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                          children: <TextSpan>[],
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
                        title: "Longitud de Tela",
                        content: productoFinal.producto.longitudTela != 0 ? productoFinal.producto.longitudTela.toString() + " metros / unidad" : "-"
                      ),
                      _cardItem(
                        title: "Precio por Unidad",
                        content: productoFinal.precioTotal != null ? "\$" + productoFinal.precioTotal.toString() : "-"
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
                            _idUbicacion = idSelected;
                          });
                        },
                      ),
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
                                  _idUbicacion == null ? "-" : _cantidadTotal.toString(),
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
            ),
            productoFinal.cantidad > 0 ?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ZMTextButton(
                  text: "Mover producto",
                  color: Colors.blue,
                  onPressed: (){
                    showDialog(
                      context: context,
                      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return MoverProductoAlertDialog(
                          productoFinal: productoFinal,
                        );
                      },
                    ).then((value) async{
                      if(value){
                        setState(() {
                          _idUbicacion = null;
                        });
                      }
                    });
                  },
                ),
              ],
            ): Container()
          ],
        ),
      ),
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