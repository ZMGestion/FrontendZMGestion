import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zmgestion/main.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';

class SendRequest{
  String url;
  final String path;
  @required final Methods method;
  @required final Object payload;
  final Map<String,String> headers;
  Function(dynamic response) onSuccess;
  final Function(Map<String,dynamic> error) onError;
  final Function onLoading;
  final bool waitForSuccess;
  final BuildContext keyBoardContext;
  final RequestScheduler scheduler;
  final RequestConfiguration requestConfiguration;
  Request request;

  SendRequest({ /*MEJORAR LOADING, MEJORAR RESPUESTAS, MEJORAR MANEJO DE PETICIONES EN SEGUNDO PLANO, QUE LAS QUE SON EN PRIMER PLANO SE CANCELEN AL CAMBIAR DE PANTALLA...*/
    this.url,
    this.path,
    @required this.method,
    @required this.payload,
    this.onSuccess,
    this.onLoading,
    this.headers,
    this.onError,
    this.waitForSuccess = true,
    this.keyBoardContext,
    this.scheduler,
    this.requestConfiguration
  }){
    this.url = "http://127.0.0.1:3000";
    this.request = Request(
      url: url,
      path: path,
      method: method,
      payload: payload,
      headers: headers,
      actionsConfiguration: ActionsConfiguration(
        onSuccess: onSuccess,
        onLoading: onLoading,
        onError: onError,
      ),
      requestConfiguration: requestConfiguration != null ? requestConfiguration : RequestConfiguration()
    );
  }

  send() async{
    /*if(keyBoardContext!=null){
      dismissKeyboard(keyBoardContext);
    }*/
    if(scheduler != null){
      await scheduler.add(request);
    }else{
      /*
      * Se esta pidiendo ejecutar en segundo plano aqui
      * */
      await mainRequestScheduler.add(request);
    }
  }
}

class ActionsConfiguration{
  final Function onSuccess;
  final Function onError;
  final Function onLoading;

  const ActionsConfiguration({
    this.onSuccess,
    this.onError,
    this.onLoading,
  });
}

class RequestConfiguration {
  final String loadingMessage;
  final String successMessage;
  final String errorMessage;
  bool showLoading;
  bool showError;
  bool showSuccess;
  final AlertOnExit alertOnExit; //Si quiere informar que deberia esperar a que se envie la peticion

  RequestConfiguration({
    this.loadingMessage,
    this.successMessage,
    this.errorMessage,
    this.alertOnExit,
    this.showLoading = true,
    this.showError = true,
    this.showSuccess = false
  });
}

class AlertOnExit{
  final String title;
  final String description;

  const AlertOnExit({
    this.title,
    this.description
  });
}
