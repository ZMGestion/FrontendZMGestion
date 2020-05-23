import 'package:flutter/material.dart';

abstract class Models<T>{

  Map<String, dynamic> toMap();

  T fromMap(Map<String, dynamic> mapModel);

  Map<String, dynamic> getAttributes(List<String> attributesNames){
    Map<String, dynamic> respuesta = {};
    Map<String, dynamic> mapModel = this.toMap();
    attributesNames.forEach((attrName){
      respuesta.addAll({attrName: mapModel[attrName]});
    });

    return respuesta;
  }

}
