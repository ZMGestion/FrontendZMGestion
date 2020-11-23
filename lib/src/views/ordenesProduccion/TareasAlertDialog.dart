import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmgestion/main.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Tareas.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/Tareas/GraficoTareas.dart';
import 'package:zmgestion/src/widgets/Tareas/LineaTarea.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class TareasAlertDialog extends StatefulWidget{
  final String title;
  final LineasProducto lineaOrdenProduccion;
  final Function onClose;

  const TareasAlertDialog({
    Key key,
    this.title = "Tareas",
    this.lineaOrdenProduccion,
    this.onClose
  }) : super(key: key);

  @override
  _TareasAlertDialogState createState() => _TareasAlertDialogState();
}

class _TareasAlertDialogState extends State<TareasAlertDialog> {

  Map<int, dynamic> mapGraph = Map<int, dynamic>();
  List<Tareas> tareas = List<Tareas>();
  bool modificandoTareas = false;
  bool agregandoTarea = false;
  int _idTareaSeleccionada;

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((_) {
      OrdenesProduccionService().listarPor(OrdenesProduccionService().listarTareas(widget.lineaOrdenProduccion.idLineaProducto)).then(
        (response){
          if(response.status == RequestStatus.SUCCESS){
            List<Tareas> _tareas = List<Tareas>();
            for(Tareas tarea in response.message){
              _tareas.add(tarea);
            }
            setState(() {
              tareas = _tareas;
            });
            _refreshGraph(tareas);
          }
        }
      );
    });
    super.initState();
  }

  void _refreshGraph(List<Tareas> _tareas){
    Map<int, dynamic> _maps = {};
    Map<int, int> _parents = {};
    int _cantidadTareas = _tareas.length;
    _tareas.map((e) => print("IdTarea: "+e.idTarea.toString()+" - IdTareaSiguiente: "+e.idTareaSiguiente.toString()));
    _tareas.forEach((t) {
      int _idTareaSiguiente = t.idTareaSiguiente;
      bool doit = true;
      if(_idTareaSiguiente == null){
        doit = false;
      }
      if(doit){
        Map<int, dynamic> _entry;
        if(_maps.containsKey(t.idTarea)){
          _entry = {_idTareaSiguiente: {t.idTarea: _maps[t.idTarea]}};
          _maps.remove(t.idTarea);
        }else{
          _entry = {_idTareaSiguiente: {t.idTarea: {}}};
        }
        if(_parents.containsKey(_idTareaSiguiente)){
          List<int> _path = [];
          int _siguiente = _parents[_idTareaSiguiente];
          _path.add(_siguiente);
          int index = 0;
          while(_parents.containsKey(_siguiente)||index==_cantidadTareas){
            _siguiente = _parents[_siguiente];
            _path.add(_siguiente);
            index++;
          }
          _maps = _updateMap(_maps, _path.reversed.toList(), _entry);
        }else{
          if(_maps.containsKey(_idTareaSiguiente)){
            _maps[_idTareaSiguiente] = Map.castFrom<dynamic,dynamic,int,dynamic>({}..addAll(_maps[_idTareaSiguiente])..addAll(Map.castFrom<dynamic,dynamic,int,dynamic>(_entry[_idTareaSiguiente])));
          }else{
            _maps..addAll(_entry);
          }
        }
        _parents.addAll({t.idTarea:_idTareaSiguiente});
      }
    });
    setState(() {
      mapGraph = _maps;
    });
  }

  Map<int, dynamic> _updateMap(Map<int, dynamic> map, List<int> path, Map<int, dynamic> entry){
    int key = path.elementAt(0);
    if(path.length == 1){
      int updateKey = entry.keys.elementAt(0);
      map[key][updateKey] = map[key][updateKey]..addAll(entry[updateKey]);
      return map;
    }else{
      path.removeAt(0);
      map[key] = _updateMap(Map.castFrom<dynamic, dynamic, int, dynamic>(map[key]), path, entry);
      return map;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0,0,0,0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            elevation: 1.5,
            scrollable: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Container(
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        child: Text(
                          widget.title,
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            color: Colors.black.withOpacity(0.6),
                            fontWeight: FontWeight.w800,
                            shadows: <Shadow>[
                              Shadow(
                                color: Colors.white.withOpacity(0.3),
                                offset: Offset(1, 1),
                              )
                            ]
                          )
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    right: 12,
                    top: 10,
                    child: IconButtonTableAction(
                      iconData: Icons.clear,
                      iconSize: 22,
                      onPressed: (){
                        if(widget.onClose != null){
                          widget.onClose();
                        }
                        Navigator.of(context).pop(true);
                      },
                    ),
                  )
                ],
              ),
            ),
            content: Container(
              width: SizeConfig.blockSizeHorizontal * 60,
              height: SizeConfig.blockSizeVertical * 70,
              constraints: BoxConstraints(
                minHeight: 200,
                maxHeight: 700
              ),
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                border: Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Colors.black.withOpacity(0.2)
                  )
                )
              ),
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: modificandoTareas,
                            child: Expanded(
                              flex: 5,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            key: Key(tareas.map((e) => e.toMap()).toList().toString()),
                                            shrinkWrap: true,
                                            itemCount: tareas.length,
                                            itemBuilder: (context, index){
                                              return LineaTarea(
                                                key: Key(tareas.map((e) => e.toMap()).toList().toString()),
                                                idLineaOrdenProduccion: widget.lineaOrdenProduccion.idLineaProducto,
                                                tarea: tareas[index],
                                                tareas: tareas,
                                                usuarioFabricante: tareas[index].usuarioFabricante,
                                                onCreate: (tarea){
                                                  setState(() {
                                                    tareas.add(tarea);
                                                  });
                                                },
                                              );
                                            }
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.02),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Visibility(
                                          visible: agregandoTarea,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        color: Colors.transparent,
                                                        child: Column(
                                                          children: [
                                                            LineaTarea(
                                                              key: Key(tareas.map((e) => e.toMap()).toList().toString()),
                                                              showDelete: false,
                                                              idLineaOrdenProduccion: widget.lineaOrdenProduccion.idLineaProducto,
                                                              tareas: tareas,
                                                              tarea: null,
                                                              onCreate: (tarea){
                                                                setState(() {
                                                                  tareas.add(tarea);
                                                                  _refreshGraph(tareas);
                                                                });
                                                              }
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Column(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Visibility(
                                                          visible: tareas.length > 0,
                                                          child: Flexible(
                                                            fit: FlexFit.tight,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: GraficoTareas(
                                                                    key:   Key(tareas.map((e) => e.toMap()).toList().toString()),
                                                                    graphMap: mapGraph,
                                                                    tareas: tareas,
                                                                    onPressed: (idTarea){
                                                                      setState(() {
                                                                        _idTareaSeleccionada = idTarea;
                                                                      });
                                                                    },    
                                                                  )
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: tareas.length == 0,
                                                          child: Flexible(
                                                            fit: FlexFit.tight,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    "Sin tareas para mostrar",
                                                                    style: TextStyle(
                                                                      color: Colors.black.withOpacity(0.5),
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 18
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Positioned(
                                                      bottom: 12,
                                                      right: 24,
                                                      child: ZMTooltip(
                                                        theme: ZMTooltipTheme.BLUE,
                                                        message: modificandoTareas ? "Cerrar lista":"Ver tareas",
                                                        child: GFIconButton(
                                                          key: Key(modificandoTareas.toString()),
                                                          icon: Icon(
                                                            Icons.list,
                                                            size: 18,
                                                            color: modificandoTareas ? Colors.white : Colors.blue,
                                                          ),
                                                          shape: GFIconButtonShape.circle,
                                                          borderShape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            side: BorderSide(
                                                              color: Colors.black12,
                                                              width: 2
                                                            ),
                                                          ),
                                                          color: modificandoTareas ? Colors.blue : Colors.white,
                                                          hoverColor: Colors.black.withOpacity(0.1),
                                                          disabledColor: Colors.black.withOpacity(0.07),
                                                          onPressed: (){
                                                            setState(() {
                                                              modificandoTareas = !modificandoTareas;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ),
                                                    Positioned(
                                                      top: 12,
                                                      right: 24,
                                                      child: ZMTooltip(
                                                        theme: ZMTooltipTheme.BLUE,
                                                        message: "Agregar tarea",
                                                        child: GFIconButton(
                                                          key: Key(agregandoTarea.toString()),
                                                          icon: Icon(
                                                            Icons.add,
                                                            size: 18,
                                                            color: agregandoTarea ? Colors.white : Colors.blue,
                                                          ),
                                                          shape: GFIconButtonShape.circle,
                                                          borderShape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20),
                                                            side: BorderSide(
                                                              color: Colors.black12,
                                                              width: 2
                                                            ),
                                                          ),
                                                          color: agregandoTarea ? Colors.blue : Colors.white,
                                                          hoverColor: Colors.black.withOpacity(0.1),
                                                          disabledColor: Colors.black.withOpacity(0.07),
                                                          onPressed: (){
                                                            setState(() {
                                                              agregandoTarea = !agregandoTarea;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: _idTareaSeleccionada != null && tareas.length > 0,
                                          child: Builder(
                                            builder: (context){
                                              Tareas tareaSeleccionada = _idTareaSeleccionada != null ? tareas[tareas.indexWhere((tarea) => (tarea.idTarea == _idTareaSeleccionada))] : null;
                                              if(tareaSeleccionada == null){
                                                return Container();
                                              }
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Stack(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                height: 200,
                                                                color: _idTareaSeleccionada == 0 ? Colors.transparent : Colors.white,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(24,12,24,12),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            tareaSeleccionada.tarea,
                                                                            style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 21
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          Container(
                                                                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                                            decoration: BoxDecoration(
                                                                              color: Tareas().mapColors[tareaSeleccionada.estado??"P"],
                                                                              borderRadius: BorderRadius.circular(4)
                                                                            ),
                                                                            child: Text(
                                                                              Tareas().mapEstados()[tareaSeleccionada.estado??"P"],
                                                                              textAlign: TextAlign.center,
                                                                              softWrap: true,
                                                                              style: TextStyle(
                                                                                color: tareaSeleccionada.estado == "V" ? Colors.white : Colors.black,
                                                                                fontSize: 14
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 8,
                                                                          ),
                                                                          Expanded(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                ZMTooltip(
                                                                                  theme: ZMTooltipTheme.GREEN,
                                                                                  message: tareaSeleccionada.estado == "P" ? "Iniciar" : "Reanudar",
                                                                                  child: GFIconButton(
                                                                                    icon: Icon(
                                                                                      Icons.play_arrow,
                                                                                      size: 12,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    shape: GFIconButtonShape.circle,
                                                                                    color: Colors.transparent,
                                                                                    hoverColor: Colors.green.withOpacity(0.3),
                                                                                    disabledColor: Colors.black.withOpacity(0.07),
                                                                                    onPressed: tareaSeleccionada.estado == "E" ? null : (){
                                                                                      DoMethodConfiguration config;
                                                                                      if(tareaSeleccionada.estado == "P"){
                                                                                        config = OrdenesProduccionService().ejecutarTarea(tareaSeleccionada);
                                                                                      }else{
                                                                                        config = OrdenesProduccionService().reanudarTarea(tareaSeleccionada);
                                                                                      }
                                                                                      OrdenesProduccionService().doMethod(config).then(
                                                                                        (response){
                                                                                          if(response.status == RequestStatus.SUCCESS){
                                                                                            Tareas _tareaActualizada = Tareas().fromMap(response.message);
                                                                                            setState(() {
                                                                                              tareas[tareas.indexWhere((tarea) => tarea.idTarea == tareaSeleccionada.idTarea)] = _tareaActualizada;
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                ZMTooltip(
                                                                                  theme: ZMTooltipTheme.YELLOW,
                                                                                  message: "Pausar",
                                                                                  child: GFIconButton(
                                                                                    icon: Icon(
                                                                                      Icons.pause,
                                                                                      size: 12,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    shape: GFIconButtonShape.circle,
                                                                                    color: Colors.transparent,
                                                                                    hoverColor: Colors.yellow.withOpacity(0.3),
                                                                                    disabledColor: Colors.black.withOpacity(0.07),
                                                                                    onPressed: tareaSeleccionada.estado != "E" ? null : (){
                                                                                      DoMethodConfiguration config;
                                                                                      config = OrdenesProduccionService().pausarTarea(tareaSeleccionada);
                                                                                      OrdenesProduccionService().doMethod(config).then(
                                                                                        (response){
                                                                                          if(response.status == RequestStatus.SUCCESS){
                                                                                            Tareas _tareaActualizada = Tareas().fromMap(response.message);
                                                                                            setState(() {
                                                                                              tareas[tareas.indexWhere((tarea) => tarea.idTarea == tareaSeleccionada.idTarea)] = _tareaActualizada;
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                ZMTooltip(
                                                                                  theme: ZMTooltipTheme.RED,
                                                                                  message: "Cancelar",
                                                                                  child: GFIconButton(
                                                                                    icon: Icon(
                                                                                      Icons.stop,
                                                                                      size: 12,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    shape: GFIconButtonShape.circle,
                                                                                    color: Colors.transparent,
                                                                                    hoverColor: Colors.red.withOpacity(0.3),
                                                                                    disabledColor: Colors.black.withOpacity(0.07),
                                                                                    onPressed: tareaSeleccionada.estado == "P" || tareaSeleccionada.estado == "V" || tareaSeleccionada.estado == "C" ? null : (){
                                                                                      DoMethodConfiguration config;
                                                                                      config = OrdenesProduccionService().cancelarTarea(tareaSeleccionada);
                                                                                      OrdenesProduccionService().doMethod(config).then(
                                                                                        (response){
                                                                                          if(response.status == RequestStatus.SUCCESS){
                                                                                            Tareas _tareaActualizada = Tareas().fromMap(response.message);
                                                                                            setState(() {
                                                                                              tareas[tareas.indexWhere((tarea) => tarea.idTarea == tareaSeleccionada.idTarea)] = _tareaActualizada;
                                                                                            });
                                                                                          }
                                                                                        }
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Flexible(
                                                                        fit: FlexFit.tight,
                                                                        child: Column(
                                                                          children: [
                                                                            Flexible(
                                                                              fit: FlexFit.tight,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 2.5),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            TopLabel(
                                                                                              padding: EdgeInsets.zero,
                                                                                              labelText: "Fabricante",
                                                                                              fontSize: 14,
                                                                                              color: Colors.black.withOpacity(0.7),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                                                                              child: Text(
                                                                                                tareaSeleccionada.usuarioFabricante.nombres + " " + tareaSeleccionada.usuarioFabricante.apellidos,
                                                                                                style: TextStyle(
                                                                                                  color: Colors.black.withOpacity(0.8),
                                                                                                  fontWeight: FontWeight.w600
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: SizeConfig.blockSizeHorizontal*2.5,),
                                                                                      Visibility(
                                                                                        visible: tareaSeleccionada.idUsuarioRevisor != null,
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.symmetric(horizontal: 2.5),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              TopLabel(
                                                                                                padding: EdgeInsets.zero,
                                                                                                labelText: "Revisor",
                                                                                                fontSize: 14,
                                                                                                color: Colors.black.withOpacity(0.7),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.symmetric(vertical: 4),
                                                                                                child: Text(
                                                                                                  tareaSeleccionada.usuarioRevisor != null ? (tareaSeleccionada.usuarioRevisor.nombres + " " + tareaSeleccionada.usuarioRevisor.apellidos) : "",
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.black.withOpacity(0.8),
                                                                                                    fontWeight: FontWeight.w600
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      //BottomActions
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              children: [
                                                                                Text(
                                                                                  "Fecha creación: "+Utils.cuteDateTimeText(DateTime.parse(tareaSeleccionada.fechaAlta.toString())),
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    fontSize: 13
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Visibility(
                                                                                visible: tareaSeleccionada.estado == "F",
                                                                                child: ZMStdButton(
                                                                                  color: Theme.of(context).primaryColorLight,
                                                                                  icon: Icon(
                                                                                    Icons.check,
                                                                                    color: Colors.white,
                                                                                    size: 15,
                                                                                  ),
                                                                                  text: Text(
                                                                                    "Verificar",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 12
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: tareaSeleccionada.estado != "F" ? null : (){
                                                                                    DoMethodConfiguration config = OrdenesProduccionService().verificarTarea(tareaSeleccionada);
                                                                                    OrdenesProduccionService().doMethod(config).then(
                                                                                      (response){
                                                                                        if(response.status == RequestStatus.SUCCESS){
                                                                                          Tareas _tareaActualizada = Tareas().fromMap(response.message);
                                                                                          setState(() {
                                                                                            tareas[tareas.indexWhere((tarea) => tarea.idTarea == tareaSeleccionada.idTarea)] = _tareaActualizada;
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              Visibility(
                                                                                visible: tareaSeleccionada.estado == "E",
                                                                                child: ZMStdButton(
                                                                                  color: Theme.of(context).primaryColorLight,
                                                                                  icon: Icon(
                                                                                    Icons.check,
                                                                                    color: Colors.white,
                                                                                    size: 15,
                                                                                  ),
                                                                                  text: Text(
                                                                                    "Finalizar",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 12
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: tareaSeleccionada.estado != "E" ? null : (){
                                                                                    DoMethodConfiguration config = OrdenesProduccionService().finalizarTarea(tareaSeleccionada);
                                                                                    OrdenesProduccionService().doMethod(config).then(
                                                                                      (response){
                                                                                        if(response.status == RequestStatus.SUCCESS){
                                                                                          Tareas _tareaActualizada = Tareas().fromMap(response.message);
                                                                                          setState(() {
                                                                                            tareas[tareas.indexWhere((tarea) => tarea.idTarea == tareaSeleccionada.idTarea)] = _tareaActualizada;
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 8,
                                                                              ),
                                                                              Visibility(
                                                                                visible: tareaSeleccionada.estado == 'C' || tareaSeleccionada.estado == 'P',
                                                                                child: ZMStdButton(
                                                                                  color: Colors.red,
                                                                                  icon: Icon(
                                                                                    Icons.delete_outline,
                                                                                    color: Colors.white,
                                                                                    size: 15,
                                                                                  ),
                                                                                  text: Text(
                                                                                    "Eliminar",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 12
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: tareaSeleccionada.estado != "C" && tareaSeleccionada.estado != "P" ? null : () async{
                                                                                    await showDialog(
                                                                                      context: context,
                                                                                      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                                                                      barrierDismissible: false,
                                                                                      builder: (context) {
                                                                                        return AlertDialog(
                                                                                          title: Text(
                                                                                            "Eliminar tarea",
                                                                                            style: TextStyle(
                                                                                              color: Colors.black87,
                                                                                              fontSize: 20,
                                                                                              fontWeight: FontWeight.w600
                                                                                            ),
                                                                                          ),
                                                                                          content: Text(
                                                                                            "¿Está seguro que desea eliminar la tarea?",                 
                                                                                          ),
                                                                                          actions: [
                                                                                            ZMTextButton(
                                                                                              text: "Aceptar",
                                                                                              color: Theme.of(mainContext).primaryColor,
                                                                                              onPressed: () async{
                                                                                                DoMethodConfiguration config = OrdenesProduccionService().eliminarTarea(tareaSeleccionada);
                                                                                                OrdenesProduccionService().doMethod(config).then(
                                                                                                  (response){
                                                                                                    if(response.status == RequestStatus.SUCCESS){
                                                                                                      setState(() {
                                                                                                        _idTareaSeleccionada = null;
                                                                                                        tareas.removeAt(tareas.indexWhere((tarea) => tarea.idTarea == tareaSeleccionada.idTarea));
                                                                                                      });
                                                                                                    }
                                                                                                  }
                                                                                                );
                                                                                                Navigator.pop(context, false);
                                                                                              },
                                                                                            ),
                                                                                            ZMTextButton(
                                                                                              text: "Cancelar",
                                                                                              color: Theme.of(mainContext).primaryColor,
                                                                                              onPressed: (){
                                                                                                Navigator.pop(context, false);
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      }
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Positioned(
                                                          top: 6,
                                                          right: 24,
                                                          child: Visibility(
                                                            visible: _idTareaSeleccionada != 0,
                                                            child: GFIconButton(
                                                              icon: Icon(
                                                                Icons.clear,
                                                                size: 18,
                                                                color: Colors.black,
                                                              ),
                                                              shape: GFIconButtonShape.circle,
                                                              color: Colors.black.withOpacity(0.05),
                                                              hoverColor: Colors.black.withOpacity(0.1),
                                                              disabledColor: Colors.black.withOpacity(0.07),
                                                              onPressed: (){
                                                                setState(() {
                                                                  _idTareaSeleccionada = null;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } 
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        );
      }
    );
  }
}