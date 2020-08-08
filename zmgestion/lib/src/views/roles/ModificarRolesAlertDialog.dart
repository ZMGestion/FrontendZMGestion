import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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


class ModificarRolesAlertDialog extends StatefulWidget {

  final String title;
  final Function() onSuccess;
  final Function(dynamic) onError;
  final Roles rol;

  const ModificarRolesAlertDialog(
      {Key key, this.title, this.onSuccess, this.onError, this.rol})
      : super(key: key);
  
  @override
  _ModificarRolesAlertDialogState createState() => _ModificarRolesAlertDialogState();
}

class _ModificarRolesAlertDialogState extends State<ModificarRolesAlertDialog> {
  final TextEditingController _rolController = new TextEditingController();
  final TextEditingController _descripcionController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Roles _rol;
  final List<Permisos> _permisos = new List<Permisos>();
  bool isLoading = true;
  bool hasError = false;

  void initState(){
    super.initState();
    
    if (widget.rol != null){
      _rol = widget.rol;
      _rolController.text = _rol.rol;
      _descripcionController.text = _rol.descripcion;
      SchedulerBinding.instance.addPostFrameCallback((_) async{ 
        await RolesService().listMethod(RolesService().listarPermisosConfiguration({
          "Roles":{
            "IdRol": _rol.idRol
          }
        })).then((response) async {
          if (response.status == RequestStatus.SUCCESS) {
            response.message.forEach((permiso) {
              _permisos.add(permiso);
            });
          }
          setState(() {
            isLoading = false;
            if (response.status == RequestStatus.ERROR) {
              hasError = true;
            }
          });
        });
      });
    }
  }


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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: AlertDialogTitle(title: widget.title),
          content: Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
            width: SizeConfig.blockSizeHorizontal * 75,
            
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
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
                ),
                !isLoading ? 
                  !hasError ? 
                    ZMTable(
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
                      showCheckbox: true,
                      initialSelection: _permisos,
                      bottomAction: (permisos){
                        return _createButton(scheduler, permisos);
                      },
                    )
                    : Text("Ha ocurrido un error")
                  : CircularProgressIndicator(),
                //_createButton(scheduler)
                
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
          labelText: "Rol"),
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

  Widget _createButton(RequestScheduler scheduler, List<Models> permisos){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProgressButton.icon(
          radius: 7,
          iconedButtons: {
            ButtonState.idle: IconedButton(
                text: "Modificar Rol",
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
          onPressed: () {
            if (_formKey.currentState.validate()) {
              //_crearCliente(scheduler);
            }
          },
          state: scheduler.isLoading()
              ? ButtonState.loading
              : ButtonState.idle,
        ),
      ],
    );
  }
}