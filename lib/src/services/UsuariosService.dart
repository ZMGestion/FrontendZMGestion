import 'dart:html';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
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
  DoMethodConfiguration crearConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/crear",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
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
  DoMethodConfiguration altaConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/darAlta",
      authorizationHeader: true,
      requestConfiguration: RequestConfiguration(
        successMessage: "El usuario se ha activado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido activar el usuario, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/darBaja",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        successMessage: "El usuario se ha dado de baja con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido dar de baja el usuario, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/borrar",
      authorizationHeader: true,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        successMessage: "El usuario ha sido eliminado con éxito",
        showSuccess: true,
        errorMessage: "No se ha podido eliminar el usuario, intentelo nuevamente más tarde",
        showError: true
      )
    );
  }

  @override
  Models getModel() {
    return Usuarios();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
        return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/modificar",
      authorizationHeader: true,
      scheduler: scheduler,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        successMessage: "El usuario ha sido modificado con éxito"
      )
    );
  }

  ListMethodConfiguration buscarUsuarios(Map<String, dynamic> payload){
    return ListMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Usuarios(),
      path: "/usuarios",
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showError: true,
        errorMessage: "Ha ocurrido un error mientras se buscaba el usuario"
      )
    );
  }

  DoMethodConfiguration iniciarSesion(Map<String, dynamic> payload){
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/iniciarSesion",
      scheduler: scheduler,
      model: Usuarios(),
      payload: payload
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

  GetMethodConfiguration dameConfiguration(int idUsuario){
    return GetMethodConfiguration(
      method: Methods.POST,
      authorizationHeader: true,
      model: Usuarios(),
      path: "/usuarios/dame",
      payload: {
        "Usuarios": {
          "IdUsuario": idUsuario
        }
      },
      scheduler: scheduler
    );
  }

  DoMethodConfiguration modificarPassConfiguration(Map<String, dynamic> payload) {
    return DoMethodConfiguration(
      method: Methods.POST,
      path: "/usuarios/modificarPassword",
      authorizationHeader: true,
      scheduler: scheduler,
      payload: payload,
      requestConfiguration: RequestConfiguration(
        showSuccess: true,
        showLoading: true,
        showError: true,
        successMessage: "La contraseña ha sido modificada con éxito"
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