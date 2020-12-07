import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/RolesService.dart';
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

class ModificarUsuariosAlertDialog extends StatefulWidget{
  final String title;
  final Usuarios usuario;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const ModificarUsuariosAlertDialog({
    Key key,
    this.title,
    this.onSuccess,
    this.usuario,
    this.onError
  }) : super(key: key);

  @override
  _ModificarUsuariosAlertDialogState createState() => _ModificarUsuariosAlertDialogState();
}

class _ModificarUsuariosAlertDialogState extends State<ModificarUsuariosAlertDialog> {
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
  int idRol;
  int idUbicacion;
  int idTipoDocumento;
  String estadoCivil;
  int cantidadHijos = 0;

  @override
  initState(){
    nombresController.text = widget.usuario.nombres;
    apellidosController.text = widget.usuario.apellidos;
    idRol = widget.usuario.idRol;
    idUbicacion = widget.usuario.idUbicacion;
    usuarioController.text = widget.usuario.usuario;
    emailController.text = widget.usuario.email;
    idTipoDocumento = widget.usuario.idTipoDocumento;
    documentoController.text = widget.usuario.documento;
    fechaNacimientoController.text = DateFormat('dd/MM/yyyy').format(widget.usuario.fechaNacimiento);
    fechaInicioController.text = DateFormat('dd/MM/yyyy').format(widget.usuario.fechaInicio);
    estadoCivil = widget.usuario.estadoCivil;
    cantidadHijos = widget.usuario.cantidadHijos;
    telefonoController.text = widget.usuario.telefono;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
        title: widget.title,
        
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
                        initialValue: idRol,
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
                        initialValue: idUbicacion,
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
                        initialValue: idTipoDocumento,
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
                      child: DropDownMap(
                        map: Usuarios().mapEstadosCivil(),
                        hint: Text("Estado civil"),
                        initialValue: estadoCivil,
                        onChanged: (idSelected){
                          estadoCivil = idSelected;
                        }
                      )
                    ),
                    SizedBox(width: 12,),
                    Expanded(
                      child: NumberInputWithIncrementDecrement(
                        labelText: "Cantidad de hijos",
                        initialValue: cantidadHijos,
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
                          Usuarios usuario = Usuarios(
                            idUsuario: widget.usuario.idUsuario,
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
                            fechaNacimiento: fechaNacimientoController.text != "" ? DateTime.parse(Jiffy(fechaNacimientoController.text, "dd/MM/yyyy").format("yyyy-MM-dd")) : null,
                            fechaInicio: fechaInicioController.text != "" ? DateTime.parse(Jiffy(fechaInicioController.text, "dd/MM/yyyy").format("yyyy-MM-dd")) : null
                          );
                          UsuariosService().modifica(usuario.toMap()).then(
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