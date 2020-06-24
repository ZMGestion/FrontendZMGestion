import 'dart:html';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Roles.dart';
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
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/crear",
      authorizationHeader: true,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        successMessage: "El usuario se ha creado con éxito"
      ),
      attributes: {
        "Usuarios": [
          "IdRol",
          "IdUbicacion",
          "IdTipoDocumento",
          "Documento",
          "Nombres",
          "Apellidos",
          "EstadoCivil",
          "Telefono",
          "Email",
          "CantidadHijos",
          "Usuario",
          "Password",
          "FechaNacimiento",
          "FechaInicio"
        ]
      },
    );
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

  ListMethodConfiguration buscarUsuarios(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Usuarios(),
      path: "/usuarios/buscar",
      scheduler: scheduler,
      payload: payload
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
          print(response);
          ZMLoader.of(context).rebuild();
        },
        onError: (error){
          ScreenMessage.push(error["mensaje"], MessageType.Error);
        }
      )
    );
  }

  GetMethodConfiguration damePorTokenConfiguration(){
    return GetMethodConfiguration(
      method: Methods.GET,
      authorizationHeader: true,
      model: Usuarios(),
      path: "/usuarios/damePorToken",
      scheduler: scheduler
    );
  }

  cerrarSesion(){
    var localStorage = window.localStorage;
    localStorage.remove("token");
    localStorage.remove("tokenType");
    ZMLoader.of(context).rebuild();
  }

}