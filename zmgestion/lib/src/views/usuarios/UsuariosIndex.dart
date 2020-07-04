import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/views/usuarios/CrearUsuariosAlertDialog.dart';
import 'package:zmgestion/src/views/usuarios/ModificarUsuariosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/IconButtonTableAction.dart';
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

  String searchText = "";
  int searchIdRol = 0;

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 200
                          ),
                          child: DropDownModelView(
                            service: RolesService(),
                            listMethodConfiguration: RolesService().listar(),
                            parentName: "Roles",
                            labelName: "Seleccione un rol",
                            displayedName: "Rol",
                            valueName: "IdRol",
                            errorMessage: "Debe seleccionar un rol",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8)
                            ),
                            onChanged: (idSelected){
                              setState(() {
                                searchIdRol = idSelected;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Buscar",
                            contentPadding: EdgeInsets.symmetric(horizontal: 20)
                          ),
                          onChanged: (value){
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppLoader(
                builder: (scheduler){
                  return ZMTable(
                    key: Key(searchText+searchIdRol.toString()),
                    model: Usuarios(),
                    service: UsuariosService(),
                    listMethodConfiguration: UsuariosService().buscarUsuarios({"Usuarios":{"IdRol": searchIdRol, "Usuario": searchText}}),
                    cellBuilder: {
                      "Usuarios": {
                        "Nombres": (value){return Text(value.toString(), textAlign: TextAlign.center,);},
                        "Apellidos": (value){return Text(value.toString(), textAlign: TextAlign.center);},
                        "Documento": (value){return Text(value.toString(), textAlign: TextAlign.center);},
                        "Telefono": (value){return Text(value.toString(), textAlign: TextAlign.center);},
                      },
                      "Roles": {
                        "Rol": (value){return Text(value.toString(), textAlign: TextAlign.center);}
                      },
                      "Ubicaciones": {
                        "Ubicacion": (value){return Text(value.toString(), textAlign: TextAlign.center);}
                      }
                    },
                    tableLabels: {
                      "Usuarios": {
                        "Telefono": "Teléfono",
                      },
                      "Ubicaciones": {
                        "Ubicacion": "Ubicación"
                      }
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
                              return CrearUsuariosAlertDialog(
                                title: "Crear Usuarios",
                                onSuccess: (){
                                  Navigator.of(context).pop();
                                },                      
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
                    rowActions: (mapModel, index, itemsController){
                      Usuarios usuario;
                      String estado = "A";
                      int idUsuario = 0;
                      if(mapModel != null){
                        usuario = Usuarios().fromMap(mapModel);
                        if(mapModel["Usuarios"] != null){
                          if(mapModel["Usuarios"]["Estado"] != null){
                            estado = mapModel["Usuarios"]["Estado"];
                          }
                          if(mapModel["Usuarios"]["IdUsuario"] != null){
                            idUsuario = mapModel["Usuarios"]["IdUsuario"];
                          }

                        }
                      }
                      return <Widget>[
                        IconButtonTableAction(
                          iconData: Icons.remove_red_eye,
                          onPressed: (){
                          },
                        ),
                        IconButtonTableAction(
                          iconData: (estado == "A" ? Icons.arrow_downward : Icons.arrow_upward),
                          color: estado == "A" ? Colors.redAccent : Colors.green,
                          onPressed: (){
                            if(idUsuario != 0){
                              if(estado == "A"){
                                UsuariosService(scheduler: scheduler).baja({"Usuarios":{"IdUsuario": idUsuario}}).then(
                                  (response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      itemsController.add(ItemAction(
                                        event: ItemEvents.Update,
                                        index: index,
                                        updateMethodConfiguration: UsuariosService().dameConfiguration(usuario.idUsuario)
                                      ));
                                    }
                                  }
                                );
                              }else{
                                UsuariosService().alta({"Usuarios":{"IdUsuario": idUsuario}}).then(
                                  (response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      itemsController.add(ItemAction(
                                        event: ItemEvents.Update,
                                        index: index,
                                        updateMethodConfiguration: UsuariosService().dameConfiguration(usuario.idUsuario)
                                      ));
                                    }
                                  }
                                );
                              }
                              
                            }
                          },
                        ),
                        IconButtonTableAction(
                          iconData: Icons.edit,
                          onPressed: (){
                            showDialog(
                            context: context,
                            barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return ModificarUsuariosAlertDialog(
                                title: "Modificar usuario",
                                usuario: Usuarios().fromMap(mapModel),
                                onSuccess: (){
                                  Navigator.of(context).pop();
                                  itemsController.add(ItemAction(
                                    event: ItemEvents.Update,
                                    index: index,
                                    updateMethodConfiguration: UsuariosService().dameConfiguration(usuario.idUsuario)
                                  ));
                                },                      
                              );
                            },
                          );
                          },
                        ),
                        IconButtonTableAction(
                          iconData: Icons.delete_outline,
                          onPressed: (){
                            if(idUsuario != 0){
                              UsuariosService().borra({"Usuarios":{"IdUsuario": idUsuario}}).then(
                                (response){
                                  if(response.status == RequestStatus.SUCCESS){
                                    itemsController.add(ItemAction(
                                      event: ItemEvents.Hide,
                                      index: index
                                    ));
                                  }
                                }
                              );
                            }
                          },
                        )
                      ];
                    }
                  );
                }
              ),
            ],
          ),
        )
    );
  }
}