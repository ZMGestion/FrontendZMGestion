import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
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

class UsuariosModelView extends StatefulWidget{
  final String title;
  final Usuarios usuario;

  const UsuariosModelView({
    Key key,
    this.title,
    this.usuario,
  }) : super(key: key);

  @override
  _UsuariosModelViewState createState() => _UsuariosModelViewState();
}

class _UsuariosModelViewState extends State<UsuariosModelView> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
   final TextEditingController cantidadHijosController = TextEditingController();
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
    cantidadHijosController.text = cantidadHijos.toString();
    telefonoController.text = widget.usuario.telefono;
    super.initState();
  }

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
  return Container(
      width: SizeConfig.blockSizeHorizontal*50,
      constraints: BoxConstraints(
        minWidth: 600,
        maxWidth: 1000,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: AlertDialogTitle(
                    title: "Empleados",
                  ),
                )
              ],
            ),
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
                        labelText: "Nombres",
                        disabled: true,
                      ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: TextFormFieldDialog(
                        controller: apellidosController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Apellidos",
                        disabled: true,
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
                        labelText: "Usuario",
                        disabled: true,
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: TextFormFieldDialog(
                        controller: emailController,
                        validator: Validator.emailValidator,
                        labelText: "Email",
                        disabled: true,
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
                      disable: true,
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: TextFormFieldDialog(
                      controller: documentoController,
                      validator: Validator.notEmptyValidator,
                      labelText: "Documento",
                      disabled: true,
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
                      hintText: "dd/mm/yyyy",
                      disabled: true,
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: TextFormFieldDialog(
                      inputFormatters: [DateTextFormatter()],
                      controller: fechaInicioController,
                      labelText: "Fecha inicio actividad laboral",
                      hintText: "dd/mm/yyyy",
                      disabled: true,
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

                    )
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: TextFormFieldDialog(
                      labelText: "Cantidad Hijos",
                      controller: cantidadHijosController,
                      disabled: true,
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
                        controller: telefonoController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Teléfono",
                        disabled: true,
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: Container()
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}