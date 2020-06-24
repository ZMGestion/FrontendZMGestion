abstract class Models<T>{

  bool selected = false;

  Map<String, dynamic> toMap();

  T fromMap(Map<String, dynamic> mapModel);

  /*
  "Usuarios": ["Nombres","Apellidos"]
  */
  Map<String, dynamic> getAttributes(Map<String, List<String>> attributes){
    Map<String, dynamic> respuesta = {};
    Map<String, dynamic> mapModel = this.toMap();
    
    attributes.forEach((parent, searchedAttributes){
      if(mapModel.containsKey(parent)){
        if(mapModel[parent] != null){
          mapModel[parent].forEach((attr, value){
            if(searchedAttributes.contains(attr)){
              if(respuesta.containsKey(parent)){
                respuesta[parent].addAll({attr: value});
              }else{
                respuesta.addAll({
                  parent: {
                    attr: value
                  }
                });
              }
              respuesta.addAll({});
            }
          });
        }
      }
    });
    return respuesta;
  }

}
