import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
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

class ModificarTelasAlertDialog extends StatefulWidget{
  final String title;
  final Telas tela;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const ModificarTelasAlertDialog({
    Key key,
    this.title,
    this.onSuccess,
    this.tela,
    this.onError
  }) : super(key: key);

  @override
  _ModificarTelasAlertDialogState createState() => _ModificarTelasAlertDialogState();
}

class _ModificarTelasAlertDialogState extends State<ModificarTelasAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController telaController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  int idRol;
  int idUbicacion;
  int idTipoDocumento;
  String estadoCivil;
  int cantidadHijos = 0;

  @override
  initState(){
    telaController.text = widget.tela.tela;
    precioController.text = widget.tela.precio.precio.toString();
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
                          controller: telaController,
                          validator: Validator.notEmptyValidator,
                          labelText: "Tela"
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
                          Telas tela = Telas(
                            idTela: widget.tela.idTela,
                            tela: telaController.text,
                            precio: Precios(
                              precio: double.parse(precioController.text)
                            )
                          );
                          TelasService().modifica(tela.toMap()).then(
                            (response){
                              if(response.status == RequestStatus.SUCCESS){
                                TelasService().doMethod(TelasService().modificaPrecioConfiguration(tela)).then(
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