import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/services/Services.dart';

class ClientesService extends Services {
  RequestScheduler scheduler;
  BuildContext context;

  ClientesService({RequestScheduler scheduler, BuildContext context}) {
    this.scheduler = scheduler;
    this.context = context;
  }

  @override
  DoMethodConfiguration crearConfiguration() {
    return null;
  }

  DoMethodConfiguration crearClienteConfiguration(
      Map<String, dynamic> payload) {
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/clientes/crear",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            showSuccess: true,
            showLoading: true,
            successMessage: "El cliente se ha creado con éxito"),
        payload: payload);
  }

  @override
  DoMethodConfiguration altaConfiguration() {
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/clientes/darAlta",
        authorizationHeader: true,
        requestConfiguration: RequestConfiguration(
            successMessage: "El cliente se ha activado con éxito",
            showSuccess: true,
            errorMessage:
                "No se ha podido activar el cliente, intentelo nuevamente más tarde",
            showError: true));
  }

  @override
  DoMethodConfiguration bajaConfiguration() {
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/clientes/darBaja",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            successMessage: "El cliente se ha dado de baja con éxito",
            showSuccess: true,
            errorMessage:
                "No se ha podido dar de baja el cliente, intentelo nuevamente más tarde",
            showError: true));
  }

  @override
  DoMethodConfiguration borraConfiguration({Map<String, dynamic> payload}) {
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/clientes/borrar",
        authorizationHeader: true,
        payload: payload,
        requestConfiguration: RequestConfiguration(
            successMessage: "El cliente ha sido eliminado con éxito",
            showSuccess: true,
            errorMessage:
                "No se ha podido eliminar el cliente, intentelo nuevamente más tarde",
            showError: true));
  }

  @override
  Models getModel() {
    return Clientes();
  }

  @override
  DoMethodConfiguration modificaConfiguration() {
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/clientes/modificar",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            showSuccess: true,
            showLoading: true,
            successMessage: "El cliente ha sido modificado con éxito"));
  }

  ListMethodConfiguration buscarClientes(Map<String, dynamic> payload) {
    return ListMethodConfiguration(
        method: Methods.POST,
        authorizationHeader: true,
        model: Clientes(),
        path: "/clientes",
        scheduler: scheduler,
        payload: payload,
        requestConfiguration: RequestConfiguration(
            showError: true,
            errorMessage:
                "Ha ocurrido un error mientras se buscaba el cliente"));
  }

  GetMethodConfiguration dameConfiguration(int idCliente) {
    return GetMethodConfiguration(
        method: Methods.POST,
        authorizationHeader: true,
        model: Clientes(),
        path: "/clientes/dame",
        payload: {
          "Clientes": {"IdCliente": idCliente}
        },
        scheduler: scheduler);
  }

  ListMethodConfiguration listarDomiciliosConfiguration(int idCliente) {
    return ListMethodConfiguration(
        method: Methods.POST,
        authorizationHeader: true,
        model: Domicilios(),
        path: "/clientes/domicilios",
        payload: {
          "Clientes": {"IdCliente": idCliente}
        });
  }

  DoMethodConfiguration agregarDomicilioConfiguration(
      Map<String, dynamic> payload) {
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/clientes/domicilios/agregar",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            showSuccess: true,
            showLoading: true,
            successMessage: "El domicilio se ha creado con éxito"),
        payload: payload);
  }

  DoMethodConfiguration quitarDomicilioConfiguration(
      Map<String, dynamic> payload) {
    return DoMethodConfiguration(
        method: Methods.POST,
        path: "/clientes/domicilios/quitar",
        authorizationHeader: true,
        scheduler: scheduler,
        requestConfiguration: RequestConfiguration(
            showSuccess: true,
            showLoading: true,
            successMessage: "El domicilio se ha eliminado con éxito"),
        payload: payload);
  }
}
