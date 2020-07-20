import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TiposDocumentoService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';

class ModificarProductosAlertDialog extends StatefulWidget{
  final String title;
  final Productos producto;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const ModificarProductosAlertDialog({
    Key key,
    this.title,
    this.onSuccess,
    this.producto,
    this.onError
  }) : super(key: key);

  @override
  _ModificarProductosAlertDialogState createState() => _ModificarProductosAlertDialogState();
}

class _ModificarProductosAlertDialogState extends State<ModificarProductosAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController productoController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  int idRol;
  int idUbicacion;
  int idTipoDocumento;
  String estadoCivil;
  int cantidadHijos = 0;

  @override
  initState(){
    productoController.text = widget.producto.producto;
    precioController.text = widget.producto.precio.precio.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextFormFieldDialog(
                          controller: productoController,
                          validator: Validator.notEmptyValidator,
                          labelText: "Producto"
                        ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormFieldDialog(
                                controller: precioController,
                                validator: Validator.notEmptyValidator,
                                labelText: "Precio"
                            ),
                          ),
                        ],
                      ),
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
                      text: Text(
                        "Aceptar",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      color: Colors.blueGrey,
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          Productos producto = Productos(
                            idProducto: widget.producto.idProducto,
                            producto: productoController.text,
                            precio: Precios(
                              precio: double.parse(precioController.text)
                            )
                          );
                          ProductosService().modifica(producto.toMap()).then(
                            (response){
                              if(response.status == RequestStatus.SUCCESS){
                                ProductosService().doMethod(ProductosService().modificaPrecioConfiguration(producto)).then(
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}