import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/TiposDocumentoService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropDownModelView(
                      service: RolesService(),
                      listMethodConfiguration: RolesService().listar(),
                      parentName: "Roles",
                      labelName: "Seleccione un rol",
                      displayedName: "Rol",
                      valueName: "IdRol",
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
                children: [
                  Expanded(
                      child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nombres",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Apellidos",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Usuario",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropDownModelView(
                      service: TiposDocumentoService(),
                      listMethodConfiguration: TiposDocumentoService().listar(),
                      parentName: "TiposDocumento",
                      labelName: "Seleccione un tipo de documento",
                      displayedName: "TipoDocumento",
                      valueName: "IdTipoDocumento",
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8)
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Documento",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [DateTextFormatter()],
                      decoration: InputDecoration(
                        labelText: "Fecha nacimiento",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        hintText: "dd/mm/yyyy"
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [DateTextFormatter()],
                      decoration: InputDecoration(
                        labelText: "Fecha inicio actividad laboral",
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        hintText: "dd/mm/yyyy"
                      ),
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
                    },
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