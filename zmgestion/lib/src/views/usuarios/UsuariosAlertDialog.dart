import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:jiffy/jiffy.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/TiposDocumentoService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class UsuariosAlertDialog extends StatefulWidget{
  final String title;
  final Usuarios usuario;

  const UsuariosAlertDialog({
    Key key,
    this.title,
    this.usuario
  }) : super(key: key);

  @override
  _UsuariosAlertDialogState createState() => _UsuariosAlertDialogState();
}

class _UsuariosAlertDialogState extends State<UsuariosAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController fechaInicioController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();
  int idRol;
  int idUbicacion;
  int idTipoDocumento;
  String estadoCivil;
  int cantidadHijos = 0;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
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
      title: Material(
          child: Container(
          constraints: BoxConstraints(
            minWidth: 300,
            maxWidth: 700
          ),
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22))
          ),
          width: SizeConfig.blockSizeHorizontal * 40,
          child: Column(
            children: [
              Container(
                height: 60,
                child: Stack(
                  children: [
                    Container(
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title.trim(),
                            style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.1),
                              fontWeight: FontWeight.bold,
                              fontSize: 40
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      child: Row(
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Theme.of(context).primaryTextTheme.headline1.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 0,
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
                  ]
                ),
              ),
            ],
          ),
        ),
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
                      child: DropDownModelView(
                        service: RolesService(),
                        listMethodConfiguration: RolesService().listar(),
                        parentName: "Roles",
                        labelName: "Seleccione un rol",
                        displayedName: "Rol",
                        valueName: "IdRol",
                        errorMessage: "Debe seleccionar un rol",
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8)
                        ),
                        onChanged: (idSelected){
                          setState(() {
                            idRol = idSelected;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: DropDownModelView(
                        service: UbicacionesService(),
                        listMethodConfiguration: UbicacionesService().listar(),
                        parentName: "Ubicaciones",
                        labelName: "Seleccione una ubicación",
                        displayedName: "Ubicacion",
                        valueName: "IdUbicacion",
                        errorMessage: "Debe seleccionar una ubicación",
                        //initialValue: UsuariosProvider.idUbicacion,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8)
                        ),
                        onChanged: (idSelected){
                          setState(() {
                            idUbicacion = idSelected;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextFormFieldDialog(
                          controller: nombresController,
                          validator: Validator.notEmptyValidator,
                          labelText: "Nombres"
                        ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                        child: TextFormFieldDialog(
                          controller: apellidosController,
                          validator: Validator.notEmptyValidator,
                          labelText: "Apellidos"
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextFormFieldDialog(
                          controller: usuarioController,
                          validator: (value){
                            return Validator.lengthValidator(value, 3);
                          },
                          labelText: "Usuario"
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                        child: TextFormFieldDialog(
                          controller: emailController,
                          validator: Validator.emailValidator,
                          labelText: "Email"
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropDownModelView(
                        service: TiposDocumentoService(),
                        listMethodConfiguration: TiposDocumentoService().listar(),
                        parentName: "TiposDocumento",
                        labelName: "Seleccione un tipo de documento",
                        displayedName: "TipoDocumento",
                        valueName: "IdTipoDocumento",
                        errorMessage: "Debe seleccionar un tipo de documento",
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8)
                        ),
                        onChanged: (idSelected){
                          setState(() {
                            idTipoDocumento = idSelected;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: TextFormFieldDialog(
                        controller: documentoController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Documento"
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormFieldDialog(
                        inputFormatters: [DateTextFormatter()],
                        controller: fechaNacimientoController,
                        labelText: "Fecha nacimiento",
                        hintText: "dd/mm/yyyy"
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: TextFormFieldDialog(
                        inputFormatters: [DateTextFormatter()],
                        controller: fechaInicioController,
                        labelText: "Fecha inicio actividad laboral",
                        hintText: "dd/mm/yyyy"
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormFieldDialog(
                        obscureText: true,
                        controller: passController,
                        labelText: "Contraseña",
                        validator: Validator.passStrengthValidator,
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: TextFormFieldDialog(
                        obscureText: true,
                        controller: pass2Controller,
                        labelText: "Repita contraseña",
                        validator: (pass2){
                          String notEmptyError = Validator.notEmptyValidator(pass2);
                          if(notEmptyError == null){
                            if(passController.text != pass2Controller.text){
                              return "Las contraseñas no coinciden";
                            }
                          }else{
                            return notEmptyError;
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropDownMap(
                        map: Usuarios().mapEstadosCivil(),
                        hint: Text("Estado civil"),
                        onChanged: (idSelected){
                          estadoCivil = idSelected;
                        }
                      )
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: NumberInputWithIncrementDecrement(
                        labelText: "Cantidad de hijos",
                        onChanged: (value){
                          setState(() {
                            cantidadHijos = value;
                          });
                        },
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: TextFormFieldDialog(
                          controller: telefonoController,
                          validator: Validator.notEmptyValidator,
                          labelText: "Teléfono",
                      ),
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                        child: Container()
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
                          UsuariosService().alta(Usuarios(
                            idRol: idRol,
                            idUbicacion: idUbicacion,
                            idTipoDocumento: idTipoDocumento,
                            documento: documentoController.text,
                            nombres: nombresController.text,
                            apellidos: apellidosController.text,
                            estadoCivil: estadoCivil,
                            telefono: telefonoController.text,
                            email: emailController.text,
                            cantidadHijos: cantidadHijos,
                            usuario: usuarioController.text,
                            password: passController.text,
                            fechaNacimiento: fechaNacimientoController.text != "" ? DateTime.parse(Jiffy(fechaNacimientoController.text, "dd/MM/yyyy").format("yyyy-MM-dd")) : null,
                            fechaInicio: fechaInicioController.text != "" ? DateTime.parse(Jiffy(fechaInicioController.text, "dd/MM/yyyy").format("yyyy-MM-dd")) : null
                          ));
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