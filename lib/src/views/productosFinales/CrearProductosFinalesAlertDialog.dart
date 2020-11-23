import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/GruposProducto.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/GruposProductoService.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class CrearProductosFinalesAlertDialog extends StatefulWidget{
  final String title;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const CrearProductosFinalesAlertDialog({
    Key key,
    this.title,
    this.onSuccess,
    this.onError
  }) : super(key: key);

  @override
  _CrearProductosAlertDialogState createState() => _CrearProductosAlertDialogState();
}

class _CrearProductosAlertDialogState extends State<CrearProductosFinalesAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  Productos producto;
  Telas tela;
  int idLustre;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _cardItem({String title = "", String content = ""}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title+": ",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.85),
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          SizedBox(
            width: 6,
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

  String _precioTotal({Productos producto, Telas tela}){
    double precioProducto = 0;
    double longitudTela = 0;
    double precioTela = 0;
    if(producto != null){
      precioProducto = producto.precio.precio;
      longitudTela = producto.longitudTela;
    }
    if(tela != null){
      precioTela = tela.precio.precio;
    }
    double total = precioProducto + longitudTela * precioTela;
    return "\$"+total.toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0,0,0,0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            elevation: 1.5,
            scrollable: true,
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: AlertDialogTitle(
              title: widget.title
            ),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AutoCompleteField(
                                        labelText: "Producto",
                                        service: ProductosService(),
                                        paginate: true,
                                        pageLength: 6,
                                        parentName: "Productos",
                                        keyName: "Producto",
                                        listMethodConfiguration: (searchText){
                                          return ProductosService().buscarProductos({
                                            "Productos": {
                                              "Producto": searchText
                                            }
                                          });
                                        },
                                        onClear: (){
                                          setState(() {
                                            producto = null;
                                          });
                                        },
                                        onSelect: (mapModel){
                                          if(mapModel != null){
                                            Productos _producto = Productos().fromMap(mapModel);
                                            setState(() {
                                              producto = _producto;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AutoCompleteField(
                                        labelText: "Tela",
                                        service: TelasService(),
                                        paginate: true,
                                        pageLength: 6,
                                        parentName: "Telas",
                                        keyName: "Tela",
                                        listMethodConfiguration: (searchText){
                                          return TelasService().buscarTelas({
                                            "Telas": {
                                              "Tela": searchText
                                            }
                                          });
                                        },
                                        onClear: (){
                                          setState(() {
                                            tela = null;
                                          });
                                        },
                                        onSelect: (mapModel){
                                          if(mapModel != null){
                                            Telas _tela = Telas().fromMap(mapModel);
                                            setState(() {
                                              tela = _tela;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropDownModelView(
                                        service: ProductosFinalesService(),
                                        listMethodConfiguration: ProductosFinalesService().listarLustres(),
                                        parentName: "Lustres",
                                        labelName: "Seleccione un lustre",
                                        displayedName: "Lustre",
                                        valueName: "IdLustre",
                                        //initialValue: UsuariosProvider.idUbicacion,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 8)
                                        ),
                                        onChanged: (idSelected) {
                                          setState(() {
                                            idLustre = idSelected;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 18,
                                        color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.6),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Detalle mueble:",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.6),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                  Card(
                                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          _cardItem(
                                            title: "Producto",
                                            content: producto != null ? producto.producto : "-"
                                          ),
                                          _cardItem(
                                            title: "Precio producto",
                                            content: (producto != null ? "\$"+producto.precio.precio.toString() : "-")
                                          ),
                                          _cardItem(
                                            title: "Longitud tela",
                                            content: producto != null ? producto.longitudTela.toString() : "-"
                                          ),
                                          _cardItem(
                                            title: "Tela",
                                            content: tela != null ? tela.tela : "-"
                                          ),
                                          _cardItem(
                                            title: "Precio tela",
                                            content: tela != null ? "\$"+tela.precio.precio.toString() : "-"
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Total:",
                                            style: TextStyle(
                                              color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.8)
                                            ),
                                          ),
                                          Text(
                                            _precioTotal(producto: producto, tela: tela),
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 22
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                    //Button zone
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ZMStdButton(
                            color: Theme.of(context).primaryColor,
                            text: Text(
                              "Crear",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            onPressed: scheduler.isLoading() ? null : (){
                              if(_formKey.currentState.validate()){
                                ProductosFinales productoFinal = ProductosFinales(
                                  idProducto: producto.idProducto,
                                  idTela: tela?.idTela,
                                  idLustre: idLustre
                                );
                                ProductosFinalesService(scheduler: scheduler).crear(productoFinal).then(
                                  (response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      if(widget.onSuccess != null){
                                        widget.onSuccess();
                                      }
                                    }else{
                                      if(widget.onError != null){
                                        widget.onError(response.message);
                                      }
                                    }
                                  }
                                );
                              }
                            },
                          ),
                          SizedBox(
                            width: 15
                          ),
                          ZMTextButton(
                            color: Theme.of(context).primaryColor,
                            text: "Cancelar",
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            outlineBorder: false,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        );
      }
    );
  }
}
