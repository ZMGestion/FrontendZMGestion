import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Ciudades.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Paises.dart';
import 'package:zmgestion/src/models/Provincias.dart';
import 'package:zmgestion/src/models/TiposDocumento.dart';
import 'package:zmgestion/src/services/Services.dart';

class ProvinciasService extends Services {
  RequestScheduler scheduler;
  BuildContext context;

  ProvinciasService({RequestScheduler scheduler, BuildContext context}) {
    this.scheduler = scheduler;
    this.context = context;
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    // TODO: implement crearConfiguration
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    // TODO: implement bajaConfiguration
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration borraConfiguration() {
    // TODO: implement borraConfiguration
    throw UnimplementedError();
  }

  @override
  Models getModel() {
    // TODO: implement getModel
    return Paises();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    throw UnimplementedError();
  }

  ListMethodConfiguration listar(Paises pais) {
    throw UnimplementedError();
  }

  ListMethodConfiguration listarCiudadesConfiguration(
      String idPais, int idCiudad) {
    return ListMethodConfiguration(
      method: Methods.POST,
      model: Ciudades(),
      path: "/ciudades",
      payload: {
        "Provincias": {"IdPais": idPais, "IdProvincia": idCiudad}
      },
      scheduler: scheduler,
    );
  }
}
