import 'dart:html';

import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';
import 'package:zmgestion/src/models/Models.dart';

abstract class Services<T>{

  Models getModel();
  DoMethodConfiguration altaConfiguration();
  DoMethodConfiguration bajaConfiguration();
  DoMethodConfiguration borraConfiguration();
  DoMethodConfiguration modificaConfiguration();

  Future<Response> alta(Models model) async{
    DoMethodConfiguration doMethodConfiguration = altaConfiguration();
    doMethodConfiguration.model = model;
    return await doMethod(doMethodConfiguration);
  }

  Future<Response> baja(Map<String, dynamic> payload){
    DoMethodConfiguration doMethodConfiguration = bajaConfiguration();
    doMethodConfiguration.model = getModel();
    doMethodConfiguration.payload = payload;
    return doMethod(doMethodConfiguration);
  }

  Future<Response> borra(Map<String, dynamic> payload){
    DoMethodConfiguration doMethodConfiguration = borraConfiguration();
    doMethodConfiguration.model = getModel();
    doMethodConfiguration.payload = payload;
    return doMethod(doMethodConfiguration);
  }

  Future<Response> modifica(Map<String, dynamic> payload, {showLoading = true, showError = true, showSuccess = false}){
    DoMethodConfiguration doMethodConfiguration = modificaConfiguration();
    doMethodConfiguration.model = getModel();
    doMethodConfiguration.payload = payload;
    if(doMethodConfiguration.requestConfiguration != null){
      RequestConfiguration requestConfiguration = doMethodConfiguration.requestConfiguration;
      requestConfiguration.showLoading = showLoading;
      requestConfiguration.showError = showError;
      requestConfiguration.showSuccess = showSuccess;
      doMethodConfiguration.requestConfiguration = requestConfiguration;
    }else{
      doMethodConfiguration.requestConfiguration = RequestConfiguration(
        showLoading: showLoading,
        showError: showError,
        showSuccess: showSuccess
      );
    }
    return doMethod(doMethodConfiguration);
  }

  Future<Response<List<Models>>> listarPor(ListMethodConfiguration config, {showLoading = true, showError = true}){
    ListMethodConfiguration listMethodConfiguration = config;
    listMethodConfiguration.model = getModel();
    if(config.requestConfiguration != null){
      RequestConfiguration requestConfiguration = config.requestConfiguration;
      requestConfiguration.showLoading = showLoading;
      requestConfiguration.showError = showError;
      listMethodConfiguration.requestConfiguration = requestConfiguration;
    }else{
      listMethodConfiguration.requestConfiguration = RequestConfiguration(
        showLoading: showLoading,
        showError: showError
      );
    }
    return listMethod(listMethodConfiguration);
  }


  Future<Response<Models>> damePor(GetMethodConfiguration config, {showLoading = true}){
    GetMethodConfiguration getMethodConfiguration = config;
    getMethodConfiguration.model = getModel();
    if(config.requestConfiguration != null){
      RequestConfiguration requestConfiguration = config.requestConfiguration;
      requestConfiguration.showLoading = showLoading;
      getMethodConfiguration.requestConfiguration = requestConfiguration;
    }else{
      getMethodConfiguration.requestConfiguration = RequestConfiguration(
          showLoading: showLoading
      );
    }
    return getMethod(getMethodConfiguration);
  }

  Future<Response> doMethod(DoMethodConfiguration config) async{
    if(config != null) {
      String token, tokenType;

      if (config.authorizationHeader) {
        final Storage _localStorage = window.localStorage;
        token = _localStorage['token'];
        tokenType = _localStorage['tokenType'];
      }

      Map<String, dynamic> payload;
      if (config.attributes != null){
        payload = config.model.getAttributes(config.attributes);
      } else {
        payload = config.payload;
      }
      Response respuesta;
      await SendRequest(
        method: config.method,
        path: config.path,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': config.authorizationHeader ? '$tokenType $token' : ''
        },
        keyBoardContext: config.keyboardContext,
        scheduler: config.scheduler,
        payload: payload,
        requestConfiguration: config.requestConfiguration,
        onSuccess: (message) async{
          if(config.actionsConfiguration != null){
            if(config.actionsConfiguration.onSuccess != null){
              await config.actionsConfiguration.onSuccess(message);
            }
          }
          respuesta = Response(
            status: RequestStatus.SUCCESS,
            message: message
          );
        },
        onError: (error) async{
          if(config.actionsConfiguration != null){
            if(config.actionsConfiguration.onError != null){
              await config.actionsConfiguration.onError(error);
            }
          }
          respuesta = Response(
              status: RequestStatus.ERROR,
              message: error
          );
        },
      ).send();
      return respuesta;
    }
    throw Exception("DoMethodConfiguration is not assigned.");
  }

  Future<Response<List<Models>>> listMethod(ListMethodConfiguration config) async{
    if(config != null){
      String token, tokenType;

      if(config.authorizationHeader){
        final Storage _localStorage = window.localStorage;
        token = _localStorage['token'];
        tokenType = _localStorage['tokenType'];
      }

      List<Models> respuesta = [];
      Response<List<Models>> responseList;

      await SendRequest(
          method: config.method,
          path: config.path,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': config.authorizationHeader ? '$tokenType $token' : ''
          },
          payload: config.payload,
          scheduler: config.scheduler,
          onSuccess: (response){
            response.forEach((item){
              print(item);
              Models itemModel = config.model.fromMap(item);
              respuesta.add(itemModel);
            });
            if(config.actionsConfiguration != null){
              if(config.actionsConfiguration.onSuccess != null){
                config.actionsConfiguration.onSuccess(response);
              }
            }
            responseList = Response<List<Models>>(
              status: RequestStatus.SUCCESS,
              message: respuesta
            );
          },
          onError: (error){
            if(config.requestConfiguration.showError){
              if(config.actionsConfiguration != null){
                if(config.actionsConfiguration.onError != null){
                  config.actionsConfiguration.onError(error);
                  return;
                }
              }
            }
            responseList = Response<List<Models>>(
              status: RequestStatus.ERROR,
              message: null
            );
          },
          requestConfiguration: config.requestConfiguration
      ).send();
      print("^"*100);
      print(respuesta);
      return responseList;
    }
    throw Exception("ListMethodConfiguration is not assigned.");
  }

  Future<Response<Models>> getMethod(GetMethodConfiguration config) async{
    if(config != null){
      String token, tokenType;

      if(config.authorizationHeader){
        final Storage _localStorage = window.localStorage;
        token = _localStorage['token'];
        tokenType = _localStorage['tokenType'];
      }

      Models respuesta;
      Response<Models> response;

      await SendRequest(
          method: config.method,
          path: config.path,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': config.authorizationHeader ? '$tokenType $token' : ''
          },
          payload: config.payload,
          scheduler: config.scheduler,
          onSuccess: (message){
            respuesta = config.model.fromMap(message[config.objectName]);
            if(config.actionsConfiguration != null){
              if(config.actionsConfiguration.onSuccess != null){
                config.actionsConfiguration.onSuccess(message);
              }
            }
            response = Response<Models>(
                status: RequestStatus.SUCCESS,
                message: respuesta
            );
          },
          onError: (error){
            if(config.requestConfiguration.showError){
              if(config.actionsConfiguration != null){
                if(config.actionsConfiguration.onError != null){
                  config.actionsConfiguration.onError(error);
                  return;
                }
              }
            }
            response = Response<Models>(
                status: RequestStatus.ERROR,
                message: null
            );
          },
          requestConfiguration: config.requestConfiguration
      ).send();
      return response;
    }
    throw Exception("ListMethodConfiguration is not assigned.");
  }
}

class DoMethodConfiguration{
  final Methods method;
  final String path;
  final List<String> attributes;
  Map<String, dynamic> payload;
  final bool authorizationHeader;
  final BuildContext keyboardContext;
  Models model;
  final bool showMessages;
  final String successMessage;
  final String errorMessage;
  final String loadingMessage;
  final RequestScheduler scheduler;
  RequestConfiguration requestConfiguration;
  final ActionsConfiguration actionsConfiguration;

  DoMethodConfiguration({
    @required this.method,
    this.attributes,
    this.payload,
    this.path,
    this.authorizationHeader = false,
    this.keyboardContext,
    this.model,
    this.showMessages = false,
    this.successMessage,
    this.errorMessage,
    this.loadingMessage,
    this.scheduler,
    this.requestConfiguration,
    this.actionsConfiguration,
  });

  setModel (Models model){
    this.model = model;
  }

}

class ListMethodConfiguration{
  final Methods method;
  final String path;
  final String listName;
  Map<String, dynamic> payload;
  final bool authorizationHeader;
  Models model;
  final RequestScheduler scheduler;
  RequestConfiguration requestConfiguration;
  final ActionsConfiguration actionsConfiguration;

  ListMethodConfiguration({
    @required this.method,
    @required this.listName,
    this.path,
    this.payload,
    this.authorizationHeader = false,
    this.model,
    this.scheduler,
    this.requestConfiguration,
    this.actionsConfiguration
  });
}

class GetMethodConfiguration{
  final Methods method;
  final String path;
  final String objectName;
  Map<String, dynamic> payload;
  final bool authorizationHeader;
  Models model;
  final RequestScheduler scheduler;
  RequestConfiguration requestConfiguration;
  final ActionsConfiguration actionsConfiguration;

  GetMethodConfiguration({
    @required this.method,
    @required this.objectName,
    this.payload,
    this.path,
    this.authorizationHeader = false,
    this.model,
    this.scheduler,
    this.requestConfiguration,
    this.actionsConfiguration
  });
}
