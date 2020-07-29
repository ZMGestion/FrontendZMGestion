import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:equatable/equatable.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Ubicaciones extends Equatable with Models {
  /* -Mysql Model-*/
  final int idUbicacion;
  final int idDomicilio;
  final String ubicacion;
  final String fechaAlta;
  final String fechaBaja;
  final String estado;
  final String observaciones;

  /* -Other-*/
  final Domicilios domicilio;

  Ubicaciones(
      {this.idUbicacion,
      this.idDomicilio,
      this.ubicacion,
      this.fechaAlta,
      this.fechaBaja,
      this.observaciones,
      this.estado,
      this.domicilio});

  @override
  List<Object> get props => [idUbicacion];

  @override
  Ubicaciones fromMap(Map<String, dynamic> mapModel) {
    return Ubicaciones(
        idUbicacion: mapModel["Ubicaciones"]["IdUbicacion"],
        idDomicilio: mapModel["Ubicaciones"]["IdDomicilio"],
        ubicacion: mapModel["Ubicaciones"]["Ubicacion"],
        fechaAlta: mapModel["Ubicaciones"]["FechaAlta"],
        fechaBaja: mapModel["Ubicaciones"]["FechaBaja"],
        estado: mapModel["Ubicaciones"]["Estado"],
        observaciones: mapModel["Ubicaciones"]["Observaciones"],
        domicilio: mapModel["Domicilios"] != null
            ? Domicilios().fromMap(mapModel)
            : null);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> ubicaciones = {
      "Ubicaciones": {
        "IdUbicacion": this.idUbicacion,
        "IdDomicilio": this.idDomicilio,
        "Ubicacion": this.ubicacion,
        "FechaAlta": this.fechaAlta,
        "FechaBaja": this.fechaBaja,
        "Estado": this.estado,
        "Observaciones": this.observaciones
      }
    };

    Map<String, dynamic> domicilios = this.domicilio?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(ubicaciones);
    result.addAll(domicilios != null ? domicilios : {});

    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    SizeConfig().init(context);
    return Column(
      children: [
        Container(
          width: SizeConfig.blockSizeHorizontal * 50,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Text(this.ubicacion),
                Text(this.observaciones != null
                    ? this.observaciones
                    : "No tiene observaciones..."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
