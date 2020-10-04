import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:zmgestion/src/widgets/ZMCharts/ZMPointsLineChart.dart';

class Telas extends Equatable with Models{
  /* -Mysql Model-*/
  final int idTela;
  final String tela;
  final DateTime fechaAlta;
  final DateTime fechaBaja;
  final String estado;
  final String observaciones;

  /* -Other-*/
  final Precios precio;

  Telas({
    this.idTela, 
    this.tela,
    this.fechaAlta,
    this.fechaBaja,
    this.estado,
    this.observaciones,
    this.precio,
  });

  @override
  List<Object> get props => [idTela];

  Map<String, String> mapEstados(){
    return {
      "A": "Activo",
      "B": "Baja"
    };
  }

  @override
  Telas fromMap(Map<String, dynamic> mapModel) {
    return Telas(
        idTela:         mapModel["Telas"]["IdTela"],
        tela:           mapModel["Telas"]["Tela"],
        fechaAlta:      mapModel["Telas"]["FechaAlta"] != null ? DateTime.parse(mapModel["Telas"]["FechaAlta"]) : null,
        fechaBaja:      mapModel["Telas"]["FechaBaja"] != null ? DateTime.parse(mapModel["Telas"]["FechaBaja"]) : null,
        observaciones:  mapModel["Telas"]["Observaciones"],
        estado:         mapModel["Telas"]["Estado"],
        precio:         mapModel["Precios"] != null ? Precios().fromMap({"Precios": mapModel["Precios"]}) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> telas = {
      "Telas": {
        "IdTela":         this.idTela,
        "Tela":           this.tela,
        "Estado":         this.estado,
        "FechaAlta":      this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
        "FechaBaja":      this.fechaBaja != null ? this.fechaBaja.toIso8601String() : null,
        "Observaciones":  this.observaciones
      }
    };

    Map<String, dynamic> precios = this.precio?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(telas);
    result.addAll(precios != null ? precios : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Column(
      children: [
        AlertDialogTitle(
          title: tela,
          width: SizeConfig.blockSizeHorizontal * 50,
        ),
        Container(
          width: SizeConfig.blockSizeHorizontal * 50,
          height: SizeConfig.blockSizeVertical * 40,
          padding: EdgeInsets.all(20),
          child: ZMPointsLineChart(
            service: TelasService(),
            listMethodConfiguration: TelasService().listarPreciosTela({"Telas":{"IdTela": idTela}}),
            domainFn: (mapModel, _){
              Precios precios = Precios().fromMap(mapModel);
              return precios.fechaAlta;
            },
            measureFn: (mapModel, _){
              return mapModel["Precios"]["Precio"];
            },
          ),
        ),
      ],
    );
  }
}
