import 'package:flutter/material.dart';
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
    UsuariosService(scheduler: null).listMethod(UsuariosService().buscarUsuarios()).then(
      (users){
        if(users != null){
          usuarios = users.message;
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
          attributes: ["Nombres","Apellidos","Documento"],
          cellBuilder: {
            "Nombres": (value){return Text(value.toString());},
            "Apellidos": (value){return Text(value.toString());},
            "Documento": (value){return Text(value.toString());}
          },
          models: <Usuarios>[
            Usuarios(
              nombres: "Nicolas",
              apellidos: "Bachs",
              cantidadHijos: 0,
              documento: "39282822"
            ),
            Usuarios(
              nombres: "Loik",
              apellidos: "Puto",
              cantidadHijos: 0,
              documento: "22222222"
            )
          ]
        ),
      ),
    );
  }
}