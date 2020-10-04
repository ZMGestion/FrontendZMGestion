import 'package:flutter/src/widgets/framework.dart';
import 'package:zmgestion/src/models/Models.dart';

class Precios extends Models {
  /* -Mysql Model-*/
  final int idPrecio;
  final double precio;
  final String tipo;
  final int idReferencia;
  final DateTime fechaAlta;

  /* -Other-*/

  Precios({
    this.idPrecio, 
    this.precio,
    this.tipo, 
    this.idReferencia,
    this.fechaAlta
  });

  @override
  Precios fromMap(Map<String, dynamic> mapModel) {
    return Precios(
        idPrecio:     mapModel["Precios"]["IdPrecio"],
        precio:       mapModel["Precios"]["Precio"],
        tipo:         mapModel["Precios"]["Tipo"],
        idReferencia: mapModel["Precios"]["IdReferencia"],
        fechaAlta:    mapModel["Precios"]["FechaAlta"] != null ? DateTime.parse(mapModel["Precios"]["FechaAlta"]) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      "Precios": {
        "IdPrecio":     this.idPrecio,
        "Precio":       this.precio,
        "Tipo":         this.tipo,
        "IdReferencia": this.idReferencia,
        "FechaAlta":    this.fechaAlta != null ? this.fechaAlta.toIso8601String() : null,
      }
    };
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
