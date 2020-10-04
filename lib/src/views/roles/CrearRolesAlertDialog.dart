import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Permisos.dart';
import 'package:zmgestion/src/models/Roles.dart';
import 'package:zmgestion/src/services/PermisosService.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';


class CrearRolesAlertDialog extends StatefulWidget {

  final String title;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const CrearRolesAlertDialog(
      {Key key, this.title, this.onSuccess, this.onError})
      : super(key: key);
  
  @override
  _CrearRolesAlertDialogState createState() => _CrearRolesAlertDialogState();
}

class _CrearRolesAlertDialogState extends State<CrearRolesAlertDialog> {
  final TextEditingController _rolController = new TextEditingController();
  final TextEditingController _descripcionController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool creatingRol = false;


  @override
   Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AppLoader(builder: (scheduler) {
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
          title: AlertDialogTitle(title: widget.title),
          content: Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
            height: SizeConfig.blockSizeVertical * 60,
            width: SizeConfig.blockSizeHorizontal * 75,
            constraints: BoxConstraints(
              minHeight: 500
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _rolField(_rolController),
                      SizedBox(
                        width: 12,
                      ),
                      _descripcionField(_descripcionController)
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: ZMTable(
                    padding: const EdgeInsets.all(0),
                    model: Permisos(),
                    service: PermisosService(),
                    listMethodConfiguration: PermisosService(scheduler: scheduler).listarPermisos({}),
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
                    bottomAction: (permisos){
                      return _createButton(scheduler, permisos);
                    },
                  ),
                ),
              ],
            )
          ));
    });
  }

  _rolField(TextEditingController controller){
    return Expanded(
      flex: 1,
      child: TextFormFieldDialog(
          controller: controller,
          validator: Validator.notEmptyValidator,
          labelText: "Rol"
      ),
    );
  }

  _descripcionField(TextEditingController controller){
    return Expanded(
      flex: 2,
      child: TextFormFieldDialog(
          controller: controller,
          labelText: "Descripción"
      ),
    );
  }

  _createButton(RequestScheduler scheduler, List<Models> permisos){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProgressButton.icon(
          radius: 7,
          iconedButtons: {
            ButtonState.idle: IconedButton(
                text: "Crear Rol",
                icon: Icon(Icons.person_add, color: Colors.white),
                color: Colors.blueAccent),
            ButtonState.loading: IconedButton(
                text: "Cargando", color: Colors.grey.shade400),
            ButtonState.fail: IconedButton(
                text: "Error",
                icon: Icon(Icons.cancel, color: Colors.white),
                color: Colors.red.shade300),
            ButtonState.success: IconedButton(
                text: "Éxito",
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                color: Colors.green.shade400)
          },
          padding: EdgeInsets.all(4),
          onPressed: () async{
            setState(() {
              creatingRol = true;
            });
            if (_formKey.currentState.validate()) {
              Roles _rol = new Roles(
                rol: _rolController.text,
                descripcion: _descripcionController.text
              );
              await RolesService(scheduler: scheduler).crear(_rol).then((response) async{
                if(response.status == RequestStatus.SUCCESS){
                  Roles _rolCreado = new Roles().fromMap(response.message);
                  List<Map> _permisos = new List<Map>();
                  permisos.forEach((permiso) {
                    _permisos.add(permiso.toMap()["Permisos"]);
                  });
                  await RolesService(scheduler: scheduler).doMethod(RolesService(scheduler: scheduler).asignarPermisosConfiguration({
                    "Roles":{
                      "IdRol": _rolCreado.idRol
                    },
                    "Permisos":_permisos
                  })).then((responsePermisos) async{
                    if(responsePermisos.status == RequestStatus.SUCCESS){
                      if (widget.onSuccess != null){
                        widget.onSuccess();
                      }
                    }
                    //Rollback del rol creado
                    if(responsePermisos.status == RequestStatus.ERROR){
                      await RolesService(scheduler: scheduler).borra(_rol.toMap());
                    }
                  });
                  
                }
              });
              setState(() {
                creatingRol = false;
              });
            }
          },
          state: creatingRol
              ? ButtonState.loading
              : ButtonState.idle,
        ),
      ],
    );
  }
}