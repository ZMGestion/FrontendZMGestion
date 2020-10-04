import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Ciudades.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Paises.dart';
import 'package:zmgestion/src/models/Provincias.dart';

class Domicilios extends Models {
  /* -Mysql Model-*/
  final int idDomicilio;
  final int idCiudad;
  final int idProvincia;
  final String idPais;
  final String domicilio;
  final String codigoPostal;
  final String fechaAlta;
  final String observaciones;

  /* -Other-*/
  final Ciudades ciudad;
  final Provincias provincia;
  final Paises pais;

  Domicilios(
      {this.idDomicilio,
      this.idCiudad,
      this.idProvincia,
      this.idPais,
      this.domicilio,
      this.codigoPostal,
      this.fechaAlta,
      this.observaciones,
      this.ciudad,
      this.provincia,
      this.pais});

  @override
  Domicilios fromMap(Map<String, dynamic> mapModel) {
    return Domicilios(
        idDomicilio: mapModel["Domicilios"]["IdDomicilio"],
        idCiudad: mapModel["Domicilios"]["IdCiudad"],
        idProvincia: mapModel["Domicilios"]["IdProvincia"],
        idPais: mapModel["Domicilios"]["IdPais"],
        domicilio: mapModel["Domicilios"]["Domicilio"],
        codigoPostal: mapModel["Domicilios"]["CodigoPostal"],
        fechaAlta: mapModel["Domicilios"]["FechaAlta"],
        observaciones: mapModel["Domicilios"]["Observaciones"],
        ciudad: mapModel["Ciudades"] != null
            ? Ciudades().fromMap(mapModel)
            : null,
        provincia: mapModel["Provincias"] != null
            ? Provincias().fromMap(mapModel)
            : null,
        pais: mapModel["Paises"] != null
            ? Paises().fromMap(mapModel)
            : null);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    Map<String, dynamic> domicilios = {
      "Domicilios": {
        "IdDomicilio": this.idDomicilio,
        "IdCiudad": this.idCiudad,
        "IdProvincia": this.idProvincia,
        "IdPais": this.idPais,
        "Domicilio": this.domicilio,
        "CodigoPostal": this.codigoPostal,
        "FechaAlta": this.fechaAlta,
        "Observaciones": this.observaciones
      }
    };
    Map<String, dynamic> ciudades = this.ciudad?.toMap();
    Map<String, dynamic> provincias = this.provincia?.toMap();
    Map<String, dynamic> paises = this.pais?.toMap();

    Map<String, dynamic> result = {};
    result.addAll(domicilios);
    result.addAll(ciudades != null ? ciudades : {});
    result.addAll(provincias != null ? provincias : {});
    result.addAll(paises != null ? paises : {});
    return result;
  }

  @override
  Widget viewModel(BuildContext context) {
    // TODO: implement viewModel
    throw UnimplementedError();
  }
}
