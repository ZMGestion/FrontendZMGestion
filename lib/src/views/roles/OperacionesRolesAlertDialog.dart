import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Permisos.dart';
import 'package:zmgestion/src/models/Roles.dart';
import 'package:zmgestion/src/services/PermisosService.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class OperacionesRolesAlertDialog extends StatefulWidget {

  final Roles rol;
  final String operacion;

  const OperacionesRolesAlertDialog({Key key, this.rol, this.operacion}) : super(key: key);

  @override
  _OperacionesRolesAlertDialogState createState() => _OperacionesRolesAlertDialogState();
}

class _OperacionesRolesAlertDialogState extends State<OperacionesRolesAlertDialog> {
  Roles rol;
  final TextEditingController _rolController = new TextEditingController();
  final TextEditingController _descripcionController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _title;

  @override
  void initState() {
    if(widget.rol != null){
      rol = widget.rol;
      if(widget.operacion == 'Modificar'){
        _rolController.text = rol.rol;
        _descripcionController.text = rol.descripcion;
        _title = 'Modificar rol';
      }
    }else{
      _title = 'Crear rol';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.fromLTRB(16,16,16,0),
      elevation: 1.5,
      scrollable: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: AlertDialogTitle(
        title: _title, 
        titleColor: Theme.of(context).primaryColorLight.withOpacity(0.8),
        backgroundColor: Theme.of(context).cardColor,
      ),
      content: Container(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
        width: SizeConfig.blockSizeHorizontal * 60,
        height: SizeConfig.blockSizeVertical * 70,
        constraints: BoxConstraints(
          minHeight: 500
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormFieldDialog(
                        controller: _rolController,
                        validator: Validator.notEmptyValidator,
                        labelText: "Rol"
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormFieldDialog(
                        controller: _descripcionController,
                        labelText: "Descripción"
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: ZMTable(
                padding: const EdgeInsets.all(0),
                model: Permisos(),
                service: PermisosService(),
                listMethodConfiguration: PermisosService().listarPermisos({}),
                pageLength: 7,
                paginate: true,
                cellBuilder: {
                  "Permisos":{
                    "Permiso": (value) {
                      return Text(value.toString(),
                          textAlign: TextAlign.center);
                    },
                    "Descripcion": (value) {
                      return Text(value.toString(),
                          textAlign: TextAlign.left);
                    },
                  }
                },
                tableLabels: {
                  "Permisos":{
                    "Descripcion":"Descripción"
                  }
                },
                showCheckbox: true,
                initialSelectionConfiguration: widget.operacion == 'Modificar' ?  RolesService().listarPermisosConfiguration({
                  "Roles":{
                    "IdRol": rol.idRol
                  }
                }) : null,
                initialService: widget.operacion == 'Modificar' ? RolesService() : null,
                bottomAction: (permisos){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZMStdButton(
                        text: Text(
                          _title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        color: Colors.green,
                        icon: Icon(
                          Icons.vpn_key,
                          color: Colors.white70,
                        ),
                        onPressed: (){
                          if(widget.operacion == 'Crear'){
                            crearRol(permisos: permisos);
                          }
                          if(widget.operacion == 'Modificar'){
                            modificarRol(permisos: permisos);
                          }
                        },
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ), 
    );
  }

  void crearRol({List<Models> permisos}) async{
    if (_formKey.currentState.validate()) {
      Roles _rol = new Roles(
        rol: _rolController.text,
        descripcion: _descripcionController.text
      );
      await RolesService().crear(_rol).then((response) async{
        if(response.status == RequestStatus.SUCCESS){
          Roles _rolCreado = new Roles().fromMap(response.message);
          List<Map> _permisos = new List<Map>();
          permisos.forEach((permiso) {
            _permisos.add(permiso.toMap()["Permisos"]);
          });
          await RolesService().doMethod(RolesService().asignarPermisosConfiguration({
            "Roles":{
              "IdRol": _rolCreado.idRol
            },
            "Permisos":_permisos
          })).then((responsePermisos) async{
            if(responsePermisos.status == RequestStatus.SUCCESS){
              Navigator.of(context).pop(true);
            }
            //Rollback del rol creado
            if(responsePermisos.status == RequestStatus.ERROR){
              await RolesService().borra(_rol.toMap());
            }
          });
        }
      });
    }
  }

  void modificarRol({List<Models> permisos}) async{
    if (_formKey.currentState.validate()) {
      await RolesService().modifica({
        "Roles":{
          "IdRol": rol.idRol,
          "Rol":_rolController.text,
          "Descripcion":_descripcionController.text
        }
      }).then((response) async{
        if(response.status == RequestStatus.SUCCESS){
          Roles _rolCreado = new Roles().fromMap(response.message);
          List<Map> _permisos = new List<Map>();
          permisos.forEach((permiso) {
            _permisos.add(permiso.toMap()["Permisos"]);
          });
          await RolesService().doMethod(RolesService().asignarPermisosConfiguration({
            "Roles":{
              "IdRol": _rolCreado.idRol
            },
            "Permisos":_permisos
          })).then((responsePermisos){
            if(responsePermisos.status == RequestStatus.SUCCESS){
              Navigator.of(context).pop(true);
            }
          });
        }
      });
    }
  }

}