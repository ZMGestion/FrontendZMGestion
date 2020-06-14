import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/views/usuarios/UsuariosAlertDialog.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ZMAlertDialog/ZMFormAlertDialog.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class UsuariosIndex extends StatefulWidget {
  @override
  _UsuariosIndexState createState() => _UsuariosIndexState();
}

class _UsuariosIndexState extends State<UsuariosIndex> {

  Map<int, Usuarios> usuarios = {};

  bool selected = false;

  List<String> columnNames = ["Nombres", "Apellidos","Usuario", "Telefono", "Email"];

  List<Widget> columns = new List<Widget>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ZMTable(
          model: Usuarios(),
          service: UsuariosService(),
          listMethodConfiguration: UsuariosService().buscarUsuarios({"Usuarios":{"IdRol": 0}}),
          cellBuilder: {
            "Usuarios": {
              "Nombres": (value){return Text(value.toString(), textAlign: TextAlign.center,);},
              "Apellidos": (value){return Text(value.toString(), textAlign: TextAlign.center);},
              "Documento": (value){return Text(value.toString(), textAlign: TextAlign.center);},
              "Telefono": (value){return Text(value.toString(), textAlign: TextAlign.center);},
            },
            "Roles": {
              "Rol": (value){return Text(value.toString(), textAlign: TextAlign.center);}
            }
          },
          tableLabels: {
            "Telefono": "Teléfono"
          },
          fixedActions: [
            ZMStdButton(
              color: Colors.green,
              text: Text(
                "Nuevo usuario",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
              onPressed: (){
                // show the dialog
                showDialog(
                  context: context,
                  barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                  builder: (BuildContext context) {
                    return UsuariosAlertDialog(
                      title: "Crear Usuarios"
                    );
                  },
                );
              },
            )
          ],
          onSelectActions: (usuarios){
            return <Widget>[
              ZMStdButton(
                color: Colors.red,
                text: Text(
                  "Borrar ("+usuarios.length.toString()+")",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: (){},
              )
            ];
          },
          rowActions: (mapModel){
            Usuarios usuario;
            if(mapModel != null){
              usuario = Usuarios().fromMap(mapModel);
            }
            
            return <Widget>[
              GFIconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7),
                ),
                shape: GFIconButtonShape.circle,
                color: Colors.white,
                onPressed: (){
                  print("OJO SOBRE "+usuario.idUsuario.toString());
                },
              ),
              GFIconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7),
                ),
                shape: GFIconButtonShape.circle,
                color: Colors.white,
                onPressed: (){},
              ),
              GFIconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent.withOpacity(0.9),
                ),
                shape: GFIconButtonShape.circle,
                color: Colors.white,
                onPressed: (){},
              )
            ];
          }
        )
        
        /*ZMTable(
        header: Text("Usuarios tablita"),
        rowsPerPage: 20,
        sortAscending: true,
        service: UsuariosService(scheduler: null),
        listMethodConfiguration: UsuariosService().buscarUsuarios({"Usuarios":{"IdRol": 1}}),
        //autocompleteMethodConfiguration: UsuariosService().autocompletar(),
        cellBuilder: {
          "Usuarios": {
            "Nombres": (value){return Text(value.toString());},
            "Apellidos": (value){return Text(value.toString());},
            "Documento": (value){return Text(value.toString());},
          },
          "Roles": {
            "Rol": (value){return Text(value.toString());}
          }
        }
      ),*/
    );
  }
}