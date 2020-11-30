import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Tareas.dart';
import 'package:graphview/GraphView.dart';

class GraficoTareas extends StatefulWidget {
  final Map<int, dynamic> graphMap;
  final Function(int idTarea) onPressed;
  final List<Tareas> tareas;

  const GraficoTareas({
    Key key, 
    this.graphMap, 
    this.onPressed,
    this.tareas
  }) : super(key: key);
  

  @override
  _GraficoTareasState createState() => _GraficoTareasState();
}

class _GraficoTareasState extends State<GraficoTareas> {
  /*
  Map<int, List<Tareas>> _tareasPorNivel = Map<int, List<Tareas>>();

  @override
  void initState() {
    _tareasPorNivel = determinarTareasPorNivel(widget.graphMap, _tareasPorNivel, 0);
    print("TAREAS POR NIVEL "+_tareasPorNivel.toString());
    super.initState();
  }

  Map<int, List<Tareas>> determinarTareasPorNivel(Map<int, dynamic> map, Map<int, List<Tareas>> levelMap, int level){
    if(map.isEmpty){
      return levelMap;
    }else{
      map.keys.forEach((id) {
        levelMap.update(level, (value){
          value.add(widget.tareas[widget.tareas.indexWhere(
            (element) => (element.idTarea == id)
          )]);
          return value;
        },
        ifAbsent: (){
          return [
            widget.tareas[widget.tareas.indexWhere(
              (element) => (element.idTarea == id)
            )]
          ];
        });
      });
      if(map.values.isNotEmpty){
        map.values.forEach((internalMap) {
          Map<int, dynamic> _internalMap = Map.castFrom<dynamic, dynamic, int, dynamic>(internalMap);
          return determinarTareasPorNivel(_internalMap, levelMap, level+1);
        });
      }
    }
    return levelMap;
  }

  @override
  Widget build(BuildContext context) {
    int _totalNiveles = _tareasPorNivel.keys.length;
    return Container(
      child: ListView.builder(
        itemCount: _totalNiveles,
        itemBuilder: (context, index){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _tareasPorNivel[_totalNiveles-index-1].map(
              (tarea) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tarea.tarea),
                ),
              )
            ).toList(),
          );
        }
      ),
    );
  }
  */

  Widget node(Tareas tarea) {
    if(tarea.idTarea == 0){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue,
            width: 2
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.blue,
            child: SizedBox(
              width: 8,
              height: 8,
            ),
          ),
        ),
      );
    }

    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue,
          width: 1.5
        )
      ),
      onPressed: widget.onPressed == null ? null : (){
        widget.onPressed(tarea.idTarea);
      },
      child: Container(
        width: 100,
        child: Column(
          children: [
            Text(
              tarea.tarea,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: Tareas().mapColors[tarea.estado],
                borderRadius: BorderRadius.circular(4)
              ),
              child: Text(
                Tareas().mapEstados()[tarea.estado],
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  color: tarea.estado == "V" ? Colors.white : Colors.black,
                  fontSize: 12
                ),
              ),
            ),
          ],
        ),
      ));
  }

  final Graph graph = Graph();
  int _selectedId;
  SugiyamaConfiguration builder = SugiyamaConfiguration();

  @override
  void initState() {
    Map<int, Node> mapNodes = Map<int, Node>();
    mapNodes.addAll({
      0: Node(node(Tareas(idTarea: 0)))..size = Size(120, 70)
    });
    widget.tareas.forEach((tarea) {
      if(!mapNodes.containsKey(tarea.idTarea)){
        mapNodes.addAll({
          tarea.idTarea: Node(node(tarea))..size = Size(120, 70)
        });
      }
      graph.addNode(mapNodes[tarea.idTarea]);
    });

    widget.tareas.forEach((tarea) {
      int _idTareaSiguiente = 0;
      if(tarea.idTareaSiguiente != null){
        _idTareaSiguiente = tarea.idTareaSiguiente;
      }
      graph.addEdge(mapNodes[tarea.idTarea], mapNodes[_idTareaSiguiente]);
    });

    builder
      ..levelSeparation = (70)
      ..nodeSeparation = (140);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      minScale: 0.2,
      maxScale: 3,
      scaleEnabled: true,
      boundaryMargin: EdgeInsets.all(100),
      child: GraphView(
        graph: graph,
        paint: Paint()..color = Colors.blue..strokeWidth = 1.5..style = PaintingStyle.stroke,
        algorithm: SugiyamaAlgorithm(builder),
      )
    );
  }
}