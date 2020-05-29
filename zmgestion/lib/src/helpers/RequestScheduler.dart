import 'dart:async';
import 'dart:convert';

import 'package:zmgestion/src/helpers/ScreenMessage.dart';

import 'Request.dart';

class RequestScheduler{

  StreamController<bool> loaderStateController;
  bool closed = false;

  RequestScheduler(StreamController<bool> loaderState){
    this.loaderStateController = loaderState;
  }

  List<Request> requests = [];

  bool isLoading(){
    bool anyPending = false;
    requests.forEach((request){
      if(request.status == RequestStatus.PENDING){
        if(request.requestConfiguration.showLoading){
          anyPending = true;
        }
      }
    });
    return anyPending;
  }

  _sendState(){
    if(!loaderStateController.isClosed){
      loaderStateController.add(isLoading());
    }
  }

  add(Request request) async{
    requests.add(request);
    try{
      request.status = RequestStatus.PENDING;
      this._sendState();
      await request.sendRequest().then((response){
        Map<String, dynamic> responseJson = json.decode(response.body);
        if(!closed){
          if (response.statusCode ~/ 100 == 2) {
            if(responseJson["error"] == null) {
              request.status = RequestStatus.SUCCESS;
              this._sendState();
              if(request.requestConfiguration.successMessage != null && request.requestConfiguration.showSuccess){
                ScreenMessage.push(request.requestConfiguration.successMessage, MessageType.Success);
              }
              if(request.actionsConfiguration.onSuccess != null){
                return request.actionsConfiguration.onSuccess(responseJson["respuesta"]);
              }
            }else{
              if(request.requestConfiguration.showError){
                ScreenMessage.push(responseJson["error"], MessageType.Error);
              }
            }
          }
          request.status = RequestStatus.ERROR;
          this._sendState();
          if(responseJson["error"] != null){
            if(responseJson["error"]["mensaje"] != null){
              ScreenMessage.push(responseJson["error"]["mensaje"], MessageType.Error);
            }
          }else if(request.requestConfiguration.errorMessage != null && request.requestConfiguration.showError){
            ScreenMessage.push(request.requestConfiguration.errorMessage, MessageType.Error);
          }
          if(request.actionsConfiguration.onError != null){
            return request.actionsConfiguration.onError(responseJson["error"]);
          }
        }else{
          request.status = RequestStatus.ERROR;
          print("ERROR POR CLOSE");
          if (request.actionsConfiguration.onError != null){
            return request.actionsConfiguration.onError({"mensaje": "Ha ocurrido un error mientras se procesaba su peticion", "codigo": "SEND_ERROR"});
          }
          this._sendState();
        }
      });
    }catch(e){
      print(e);
      if(!closed) {
        request.status = RequestStatus.ERROR;
        this._sendState();
        if(request.requestConfiguration.errorMessage != null && request.requestConfiguration.showError){
          ScreenMessage.push(request.requestConfiguration.errorMessage, MessageType.Error);
          /*
          * No mostramos su errorMessage personalizado dado que ocurrio la captura de una excepcion
          * pero nos fijamos si errorMessage != null para saber si queria recibir mensajes de error
          * */
        }
        if (request.actionsConfiguration.onError != null){
          return request.actionsConfiguration.onError({"mensaje": "Ha ocurrido un error mientras se procesaba su peticion", "codigo": "SEND_ERROR"});
        }
      }else{
        request.status = RequestStatus.ERROR;
        this._sendState();
      }
    }
  }
}
