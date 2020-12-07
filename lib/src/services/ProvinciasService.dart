import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Ciudades.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Paises.dart';
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
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    
    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    

    throw UnimplementedError();
  }

  @override
  DoMethodConfiguration borraConfiguration() {
    throw UnimplementedError();
  }

  @override
  Models getModel() {
    return Paises();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
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
