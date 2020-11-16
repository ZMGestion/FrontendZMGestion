import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zmgestion/src/helpers/Constants.dart';
import 'package:zmgestion/src/helpers/SendRequest.dart';

enum RequestStatus{
  PENDING,
  SENDED,
  ERROR,
  SUCCESS
}

enum Methods{
  POST,
  GET
}

class Request{
  String url;
  @required final String path;
  @required final Methods method;
  @required final Object payload;
  final Map<String,String> headers;
  RequestStatus status = RequestStatus.PENDING;
  RequestConfiguration requestConfiguration;
  ActionsConfiguration actionsConfiguration;

  Request({
    this.url = Constants.URL,
    this.method,
    this.path, // usuarios/listar
    this.headers,
    this.payload,
    this.actionsConfiguration = const ActionsConfiguration(),
    this.requestConfiguration
  });

  Future<http.Response> sendRequest() async {
    var body = jsonEncode(payload);
    http.Response response;
    try {
      switch(method){
        case Methods.POST:
          response = await http.post(
            url+path,
            headers: headers != null ? headers : {'Content-Type': 'application/json'},
            body: body).
          timeout(Duration(seconds: 10));
          break;
        case Methods.GET:
          response = await http.get(
            url+path,
            headers: headers != null ? headers : {'Content-Type': 'application/json'}).
          timeout(Duration(seconds: 10));
          break;
        default:
          break;

      }
      
      return response;
    }catch(e){
      this.status = RequestStatus.ERROR;
      return null;
    }
  }

  cancel(){

  }

}
