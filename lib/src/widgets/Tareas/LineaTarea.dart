import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/models/Tareas.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class LineaTarea extends StatefulWidget {
  final Tareas tarea;
  final int idLineaOrdenProduccion;
  final List<Tareas> tareas;
  final bool showDelete;
  final Usuarios usuarioFabricante;
  final Function(Tareas tarea) onCreate;
  final Function(Tareas tarea) onDelete;
  final Function(Tareas tarea) onUpdate;

  const LineaTarea({
    Key key, 
    this.tarea, 
    this.idLineaOrdenProduccion,
    this.tareas,
    this.showDelete = true,
    this.usuarioFabricante,
    this.onCreate,
    this.onDelete,
    this.onUpdate
  }) : super(key: key);

  @override
  _LineaTareaState createState() => _LineaTareaState();
}

class _LineaTareaState extends State<LineaTarea> {
  TextEditingController _tareaController = TextEditingController();
  List<DropdownMenuItem> _items = List<DropdownMenuItem>();
  int _idTareaSiguiente = 0;
  int _idUsuarioFabricante;
  String _usuarioFabricanteNombre;
  int _idUsuarioFabricanteOriginal;
  String _tareaOriginal;
  int _idTareaSiguienteOriginal;
  bool _editando = false;
  bool _tareaCambiada = false;


  @override
  void initState() {
    if(widget.tarea != null){
      _tareaOriginal = widget.tarea.tarea;
      _idUsuarioFabricanteOriginal = widget.tarea.idUsuarioFabricante;
      _idUsuarioFabricante = widget.tarea.idUsuarioFabricante;
      _tareaController.text = widget.tarea.tarea;
      _idTareaSiguienteOriginal = widget.tarea.idTareaSiguiente??0;
      _idTareaSiguiente = widget.tarea.idTareaSiguiente??0;
      _editando = true;
    }
    if(widget.usuarioFabricante != null){
      _usuarioFabricanteNombre = widget.usuarioFabricante.nombres+" "+widget.usuarioFabricante.apellidos;
    }
    _items.add(
      DropdownMenuItem<int>(
        value: 0,
        child: Text(
          "Sin tarea siguiente",
          style: TextStyle(
            color: Colors.black54
          ),
          textAlign: TextAlign.center,
        ),
      )
    );
    if(widget.tareas != null){
      widget.tareas.forEach((tarea) {
        _items.add(
          DropdownMenuItem<int>(
            value: tarea.idTarea,
            child: Text(
              tarea.tarea,
              textAlign: TextAlign.center,
            ),
          )
        );
      });
    }
    _tareaController.addListener(() {
      if(_editando){
        if(_tareaOriginal != _tareaController.text && !_tareaCambiada){
          setState((){
            _tareaCambiada = true;
          });
        }
        if(_tareaOriginal == _tareaController.text && _tareaCambiada){
          setState((){
            _tareaCambiada = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TextFormField(
                  controller: _tareaController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                        width: 0.5
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black12,
                        width: 0.5
                      )
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1
                      )
                    ),
                    labelStyle: TextStyle(
                      fontSize: 14
                    ),
                    labelText: "Tarea",
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoCompleteField(
                    labelText: "Fabricante",
                    hintText: "Ingrese un fabricante",
                    labelStyle: TextStyle(
                      fontSize: 14
                    ),
                    initialValue: _usuarioFabricanteNombre,
                    parentName: "Usuarios",
                    keyNameFunc: (mapModel){
                      return mapModel["Usuarios"]["Nombres"]+" "+mapModel["Usuarios"]["Apellidos"];
                    },
                    service: UsuariosService(),
                    paginate: true,
                    pageLength: 4,
                    onClear: (){
                      setState(() {
                        _idUsuarioFabricante = null;
                      });
                    },
                    listMethodConfiguration: (searchText){
                      return UsuariosService().buscarUsuarios({
                        "Usuarios": {
                          "Nombres": searchText,
                          "IdRol": 3,
                        }
                      });
                    },
                    onSelect: (mapModel){
                      if(mapModel != null){
                        Usuarios usuario = Usuarios().fromMap(mapModel);
                        setState(() {
                          _idUsuarioFabricante = usuario.idUsuario;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Tarea siguiente",
                  border: InputBorder.none,
                ),
                isExpanded: true,
                value: _idTareaSiguiente,
                items: _items,
                onChanged: (value){
                  setState(() {
                    _idTareaSiguiente = value;
                  });
                }
              )
            ),
            ZMTooltip(
              theme: ZMTooltipTheme.BLUE,
              message: _editando ? "Modificar tarea" : "Agregar tarea",
              child: IconButtonTableAction(
                iconData: Icons.check,
                color: Colors.blue,
                disabledBackgroundColor: Colors.black.withOpacity(0.05),
                disabledColor: Colors.black.withOpacity(0.8),
                onPressed: _editando ? (
                  (
                    (//Revisamos que haya cambiado algo
                      _idUsuarioFabricante == _idUsuarioFabricanteOriginal
                      && _idTareaSiguienteOriginal == _idTareaSiguiente
                      && !_tareaCambiada 
                    )
                    || 
                    (//Revisamos que sea un cambio válido
                      _tareaController.text == "" || _idUsuarioFabricante == null
                    )
                  ) ?
                  null
                  :
                  (){

                  }
                ) 
                : (
                  _tareaController.text == "" || _idUsuarioFabricante == null ?
                  null :
                  (){
                    OrdenesProduccionService().doMethod(
                      OrdenesProduccionService().crearTarea(
                        Tareas(
                          idLineaProducto: widget.idLineaOrdenProduccion,
                          idTareaSiguiente: _idTareaSiguiente,
                          tarea: _tareaController.text,
                          idUsuarioFabricante: _idUsuarioFabricante
                        )
                      )
                    ).then(
                      (response){
                        if(response.status == RequestStatus.SUCCESS){
                          ScreenMessage.push("Tarea agregada con éxito", MessageType.Success);
                          if(widget.onCreate != null){
                            widget.onCreate(
                              Tareas().fromMap(response.message)
                            );
                          }
                        }
                      } 
                    );
                  }
                ),
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Visibility(
              visible: widget.showDelete,
              child: ZMTooltip(
                theme: ZMTooltipTheme.RED,
                message: "Eliminar tarea",
                child: IconButtonTableAction(
                  iconData: Icons.delete_outline,
                  color: Colors.blue,
                  disabledBackgroundColor: Colors.black.withOpacity(0.05),
                  disabledColor: Colors.black.withOpacity(0.8),
                  onPressed: !_editando ? null : (){},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}