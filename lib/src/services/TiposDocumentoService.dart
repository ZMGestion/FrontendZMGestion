import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/TiposDocumento.dart';
import 'package:zmgestion/src/services/Services.dart';


class TiposDocumentoService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  TiposDocumentoService({RequestScheduler scheduler, BuildContext context}){
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
    return TiposDocumento();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    throw UnimplementedError();
  }

  ListMethodConfiguration listar(){
    return ListMethodConfiguration(
      method: Methods.GET, 
      model: TiposDocumento(),
      path: "/usuarios/tiposDocumento",
      scheduler: scheduler
    );
  }

}