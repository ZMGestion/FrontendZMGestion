import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class Models<T>{

  bool selected = false;

  Map<String, dynamic> toMap();

  T fromMap(Map<String, dynamic> mapModel);

  /*
  "Usuarios": ["Nombres","Apellidos"]
  */
  Map<String, dynamic> getAttributes(List<String> attributes){
    Map<String, dynamic> respuesta = {};
    Map<String, dynamic> mapModel = this.toMap();
    attributes.forEach((searchedAttr){
      mapModel.forEach((key, internalMapModel) {
        if(internalMapModel.containsKey(searchedAttr)){
          respuesta.addAll({searchedAttr: internalMapModel[searchedAttr]});
        }
      });
    });
    

    return respuesta;
  }

}
