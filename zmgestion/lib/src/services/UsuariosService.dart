import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/RequestScheduler.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/Services.dart';

class UsuariosService extends Services{

  RequestScheduler scheduler;

  UsuariosService({RequestScheduler scheduler}){
    this.scheduler = scheduler;
  }


  @override
  DoMethodConfiguration altaConfiguration() {
    // TODO: implement altaConfiguration
    throw UnimplementedError();
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

  ListMethodConfiguration buscarUsuarios(){
    return ListMethodConfiguration(
      method: Methods.POST,
      //model: Usuarios(),
      path: "/usuarios/buscar",
      scheduler: scheduler,
      payload: {
        "Usuarios":{
          "IdRol": 1
        }
      }
    );
  }

}