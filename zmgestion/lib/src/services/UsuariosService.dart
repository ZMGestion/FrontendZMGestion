import 'dart:html';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/views/ZMLoader.dart';

class UsuariosService extends Services{

  RequestScheduler scheduler;
  BuildContext context;

  UsuariosService({RequestScheduler scheduler, BuildContext context}){
    this.scheduler = scheduler;
    this.context = context;
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
    return Usuarios();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    // TODO: implement modificaConfiguration
    throw UnimplementedError();
  }

  ListMethodConfiguration buscarUsuarios(){
    return ListMethodConfiguration(
      method: Methods.POST,
      //model: Usuarios(),
      path: "/usuarios/buscar",
      scheduler: scheduler,
      payload: {
        "Usuarios":{
          "IdRol": 1
        }
      }
    );
  }

  DoMethodConfiguration iniciarSesion(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/iniciarSesion",
      scheduler: scheduler,
      model: Usuarios(),
      payload: payload,
      actionsConfiguration: ActionsConfiguration(
        onSuccess: (response){
          Usuarios usuario = Usuarios().fromMap(response);
          var localStorage = window.localStorage;
          localStorage["tokenType"] = "JWT";
          localStorage["token"] = usuario.token;
          ZMLoader.of(context).rebuild();
        },
        onError: (error){
          ScreenMessage.push(error["mensaje"], MessageType.Error);
        }
      )
    );
  }

  cerrarSesion(){
    var localStorage = window.localStorage;
    localStorage.remove("token");
    localStorage.remove("tokenType");
    ZMLoader.of(context).rebuild();
  }

}