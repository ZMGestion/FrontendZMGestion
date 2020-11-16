import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:zmgestion/src/widgets/ZMCharts/ZMPointsLineChart.dart';

class Tareas extends Equatable with Models{
  /* -Mysql Model-*/
  final int idTarea;
  final int idLineaProducto;
  final int idTareaSiguiente;
  final int idUsuarioFabricante;
  final int idUsuarioRevisor;
  final String tarea;
  final DateTime fechaInicio;
  final DateTime fechaPausa;
  final DateTime fechaFinalizacion;
  final DateTime fechaRevision;
  final DateTime fechaAlta;
  final DateTime fechaCancelacion;
  final String observaciones;
  final String estado;

  /* -Other-*/
  final LineasProducto lineaProducto;
  final Usuarios usuarioFabricante;
  final Usuarios usuarioRevisor;

  Tareas({
    this.idTarea, 
    this.idLineaProducto, 
    this.idTareaSiguiente, 
    this.idUsuarioFabricante, 
    this.idUsuarioRevisor, 
    this.tarea,
    this.fechaInicio,
    this.fechaPausa,
    this.fechaFinalizacion,
    this.fechaRevision,
    this.fechaAlta,
    this.fechaCancelacion,
    this.observaciones,
    this.estado,
    this.lineaProducto,
    this.usuarioFabricante,
    this.usuarioRevisor
  });

  @override
  List<Object> get props => [idTarea];

  Map<String, String> mapEstados(){
    return {
      "P": "Pendiente",
      "E": "En proceso",
      "S": "Pausada",
      "F": "Finalizada",
      "C": "Cancelada",
      "V": "Verificada"
    };
  }

  Map<String, Color> mapColors = {
      "P": Colors.blue.withOpacity(0.2),
      "E": Colors.yellow.withOpacity(0.2),
      "S": Colors.orangeAccent.withOpacity(0.2),
      "F": Colors.green.withOpacity(0.2),
      "C": Colors.red.withOpacity(0.2),
      "V": Colors.green.withOpacity(1),
    };

  @override
  Tareas fromMap(Map<String, dynamic> mapModel) {
    return Tareas(
        idTarea:              mapModel["Tareas"]["IdTarea"],
        idLineaProducto:      mapModel["Tareas"]["IdLineaProducto"],
        idTareaSiguiente:     mapModel["Tareas"]["IdTareaSiguiente"],
        idUsuarioFabricante:  mapModel["Tareas"]["IdUsuarioFabricante"],
        idUsuarioRevisor:     mapModel["Tareas"]["IdUsuarioRevisor"],
        tarea:                mapModel["Tareas"]["Tarea"],
        fechaInicio:          mapModel["Tareas"]["FechaInicio"] != null ? DateTime.parse(mapModel["Tareas"]["FechaInicio"]) : null,
        fechaPausa:           mapModel["Tareas"]["FechaPausa"] != null ? DateTime.parse(mapModel["Tareas"]["FechaPausa"]) : null,
        fechaFinalizacion:    mapModel["Tareas"]["FechaFinalizacion"] != null ? DateTime.parse(mapModel["Tareas"]["FechaFinalizacion"]) : null,
        fechaRevision:        mapModel["Tareas"]["FechaRevision"] != null ? DateTime.parse(mapModel["Tareas"]["FechaRevision"]) : null,
        fechaAlta:            mapModel["Tareas"]["FechaAlta"] != null ? DateTime.parse(mapModel["Tareas"]["FechaAlta"]) : null,
        fechaCancelacion:     mapModel["Tareas"]["FechaCancelacion"] != null ? DateTime.parse(mapModel["Tareas"]["FechaCancelacion"]) : null,
        observaciones:        mapModel["Tareas"]["Observaciones"],
        estado:               mapModel["Tareas"]["Estado"],
        lineaProducto:        mapModel["LineasProducto"] != null ? LineasProducto().fromMap(mapModel) : null,
        usuarioFabricante:    mapModel["UsuariosFabricante"] != null ? Usuarios().fromMap({"Usuarios": mapModel["UsuariosFabricante"]}) : null,
        usuarioRevisor:       mapModel["UsuariosRevisor"] != null ? Usuarios().fromMap({"Usuarios": mapModel["UsuariosRevisor"]}) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> tareas = {
      "Tareas": {
        "IdTarea":              this.idTarea,
        "IdLineaProducto":      this.idLineaProducto,
        "IdTareaSiguiente":     this.idTareaSiguiente,
        "IdUsuarioFabricante":  this.idUsuarioFabricante,
        "IdUsuarioRevisor":     this.idUsuarioRevisor,
        "Tarea":                this.tarea,
        "FechaInicio":          this.fechaInicio != null ? this.fechaInicio.toIso8601String() : null,
        "FechaPausa":           this.fechaPausa != null ? this.fechaPausa.toIso8601String() : null,
        "FechaFinalizacion":    this.fechaFinalizacion != null ? this.fechaFinalizacion.toIso8601String() : null,
        "FechaRevision":        this.fechaRevision != null ? this.fechaRevision.toIso8601String() : null,
        "FechaAlta":            this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaCancelacion":     this.fechaCancelacion != null ? this.fechaCancelacion.toIso8601String() : null,
        "Observaciones":        this.observaciones,
        "Estado":               this.estado,
      }
    };

    Map<String, dynamic> lineasProducto = this.lineaProducto?.toMap();
    Map<String, dynamic> usuariosFabricante = this.usuarioFabricante?.toMap();
    Map<String, dynamic> usuariosRevisor = this.usuarioRevisor?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(tareas);
    result.addAll(lineasProducto != null ? lineasProducto : {});
    result.addAll(usuariosFabricante != null ? {"UsuariosFabricante": usuariosFabricante["Usuarios"]} : {});
    result.addAll(usuariosRevisor != null ? {"UsuariosRevisor": usuariosRevisor["Usuarios"]} : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Text("Tareas: Nada por aquí...");
  }
}
