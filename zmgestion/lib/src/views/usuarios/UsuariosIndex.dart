import 'package:flutter/material.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/widgets/ZMTable/ModelDataSource.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class UsuariosIndex extends StatefulWidget {
  @override
  _UsuariosIndexState createState() => _UsuariosIndexState();
}

class _UsuariosIndexState extends State<UsuariosIndex> {

  List<Models> usuarios = new List<Models>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UsuariosService(scheduler: null).listMethod(UsuariosService().buscarUsuarios({"Usuarios":{"IdRol": 1}})).then(
      (response){
        if(response.status == RequestStatus.SUCCESS){
          setState(() {
            usuarios = response.message;
          });
        }else{
          ScreenMessage.push("No se han podido cargar los usuarios.", MessageType.Error);
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ZMTable(
        header: Text("Usuarios tablita"),
        rowsPerPage: 20,
        sortAscending: true,
        source: ModelDataSource(
          cellBuilder: {
            "Usuarios": {
              "Nombres": (value){return Text(value.toString());},
              "Apellidos": (value){return Text(value.toString());},
              "Documento": (value){return Text(value.toString());}
            }
          },
          models: usuarios
        ),
      ),
    );
  }
}