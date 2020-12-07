import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Paises.dart';
import 'package:zmgestion/src/models/Provincias.dart';
import 'package:zmgestion/src/models/TiposDocumento.dart';
import 'package:zmgestion/src/services/Services.dart';

class PaisesService extends Services {
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

  ListMethodConfiguration listarProvinciasConfiguration(String idPais) {
    return ListMethodConfiguration(
      method: Methods.POST,
      model: Provincias(),
      path: "/provincias",
      payload: {"Paises":{"IdPais":idPais}},
      scheduler: scheduler,
    );
  }
}
