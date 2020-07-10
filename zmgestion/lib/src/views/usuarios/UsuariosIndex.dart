import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/RolesService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/views/usuarios/CrearUsuariosAlertDialog.dart';
import 'package:zmgestion/src/views/usuarios/ModificarUsuariosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/FilterChoiceChip.dart';
import 'package:zmgestion/src/widgets/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class UsuariosIndex extends StatefulWidget {
  @override
  _UsuariosIndexState createState() => _UsuariosIndexState();
}

class _UsuariosIndexState extends State<UsuariosIndex> {

  Map<int, Usuarios> usuarios = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  String searchText = "";
  int searchIdRol = 0;
  int searchIdUbicacion = 0;
  String searchIdEstado = "T"; 
  /*Search filters*/
  bool showFilters = false;
  bool searchByNombres = true;
  bool searchByApellidos = true;
  bool searchByUsuario = true;
  bool searchByEmail = false;
  bool searchByDocumento = false;
  bool searchByTelefono = false;

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
                        flex: 4,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Buscar",
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search
                                ),
                                alignLabelWithHint: true,
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 0)
                              ),
                              onChanged: (value){
                                setState(() {
                                  searchText = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showFilters = !showFilters;
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.filter,
                          size: 14,
                          color: showFilters ? Colors.blueAccent.withOpacity(0.8) : Theme.of(context).iconTheme.color.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 200
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TopLabel(
                                labelText: "Rol",
                              ),
                              DropDownModelView(
                                service: RolesService(),
                                listMethodConfiguration: RolesService().listar(),
                                parentName: "Roles",
                                labelName: "Seleccione un rol",
                                displayedName: "Rol",
                                valueName: "IdRol",
                                errorMessage: "Debe seleccionar un rol",
                                allOption: true,
                                allOptionText: "Todos",
                                allOptionValue: 0,
                                initialValue: 0,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8),
                                  //border: InputBorder.none
                                ),
                                onChanged: (idSelected){
                                  setState(() {
                                    searchIdRol = idSelected;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 200
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TopLabel(
                                labelText: "Ubicación",
                              ),
                              DropDownModelView(
                                service: UbicacionesService(),
                                listMethodConfiguration: UbicacionesService().listar(),
                                parentName: "Ubicaciones",
                                labelName: "Seleccione una ubicación",
                                displayedName: "Ubicacion",
                                valueName: "IdUbicacion",
                                allOption: true,
                                allOptionText: "Todas",
                                allOptionValue: 0,
                                initialValue: 0,
                                errorMessage: "Debe seleccionar una ubicación",
                                //initialValue: UsuariosProvider.idUbicacion,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 8)
                                ),
                                onChanged: (idSelected){
                                  setState(() {
                                    searchIdUbicacion = idSelected;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              !showFilters ?
              Container() :
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 6, right: 12),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: (){
                        setState(() {
                          showFilters = !showFilters;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                                    width: 0.25
                                  )
                                )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "Filtros de búsqueda",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                                    width: 0.25
                                  )
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Buscar por: ",
                                        textAlign: TextAlign.right,
                                      )
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Wrap(
                                        children: [
                                          FilterChoiceChip(
                                            text: "Nombres",
                                            initialValue: searchByNombres,
                                            onSelected: (value){
                                              setState(() {
                                                searchByNombres = value;
                                              });
                                            },
                                          ),
                                          FilterChoiceChip(
                                            text: "Apellidos",
                                            initialValue: searchByApellidos,
                                            onSelected: (value){
                                              setState(() {
                                                searchByApellidos = value;
                                              });
                                            },
                                          ),
                                          FilterChoiceChip(
                                            text: "Nombre de usuario",
                                            initialValue: searchByUsuario,
                                            onSelected: (value){
                                              setState(() {
                                                searchByUsuario = value;
                                              });
                                            },
                                          ),
                                          FilterChoiceChip(
                                            text: "Correo electrónico",
                                            initialValue: searchByEmail,
                                            onSelected: (value){
                                              setState(() {
                                                searchByEmail = value;
                                              });
                                            },
                                          ),
                                          FilterChoiceChip(
                                            text: "Documento",
                                            initialValue: searchByDocumento,
                                            onSelected: (value){
                                              setState(() {
                                                searchByDocumento = value;
                                              });
                                            },
                                          ),
                                          FilterChoiceChip(
                                            text: "Teléfono",
                                            initialValue: searchByTelefono,
                                            onSelected: (value){
                                              setState(() {
                                                searchByTelefono = value;
                                              });
                                            },
                                          ),
                                      ]),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Estado: ",
                                        textAlign: TextAlign.right,
                                      )
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 250,
                                            child: DropDownMap(
                                              map: Usuarios().mapEstados(),
                                              addAllOption: true,
                                              addAllText: "Todos",
                                              addAllValue: "T",
                                              initialValue: "T",
                                              onChanged: (value){
                                                setState(() {
                                                  searchIdEstado = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ],
                  )
                ]
              ),
              AppLoader(
                builder: (scheduler){
                  return ZMTable(
                    key: Key(searchText+searchIdRol.toString()+searchIdUbicacion.toString()+searchIdEstado.toString()+refreshValue.toString()
                    +searchByNombres.toString()+searchByApellidos.toString()+searchByUsuario.toString()+searchByEmail.toString()
                    +searchByDocumento.toString()+searchByTelefono.toString()),
                    model: Usuarios(),
                    service: UsuariosService(),
                    listMethodConfiguration: UsuariosService().buscarUsuarios({
                      "Usuarios":{
                        "IdRol": searchIdRol, 
                        "Nombres": searchByNombres ? searchText : null,
                        "Apellidos": searchByApellidos ? searchText : null,
                        "Usuario": searchByUsuario ? searchText : null,
                        "Email": searchByEmail ? searchText : null,
                        "Documento": searchByDocumento ? searchText : null,
                        "Telefono": searchByTelefono ? searchText : null,
                        "IdUbicacion": searchIdUbicacion,
                        "Estado": searchIdEstado
                      }
                    }),
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
                      bool estadosIguales = true;
                      String estado;
                      if(usuarios.length >= 1){
                        Map<String, dynamic> anterior;
                        for(Usuarios usuario in usuarios){
                          Map<String, dynamic> mapUsuario = usuario.toMap();
                          if(anterior != null){
                            if(anterior["Usuarios"]["Estado"] != mapUsuario["Usuarios"]["Estado"]){
                              estadosIguales = false;
                            }
                          }
                          if(!estadosIguales) break;
                          anterior = mapUsuario;
                        }
                        if(estadosIguales){
                          estado = usuarios[0].toMap()["Usuarios"]["Estado"];
                        }
                      }
                      return <Widget>[
                        Visibility(
                          visible: estadosIguales && estado != null,
                          child: Row(
                            children: [
                              ZMStdButton(
                                color: Colors.white,
                                text: Text(
                                  (estado == "A" ? "Dar de baja" : "Dar de alta")+" ("+usuarios.length.toString()+")",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                icon: Icon(
                                  estado == "A" ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: estado == "A" ? Colors.red : Colors.green,
                                  size: 20,
                                ),
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return MultipleRequestView(
                                        models: usuarios,
                                        title: (estado == "A" ? "Dar de baja" : "Dar de alta")+" "+usuarios.length.toString()+" usuarios",
                                        service: UsuariosService(),
                                        doMethodConfiguration: estado == "A" ? UsuariosService().bajaConfiguration() : UsuariosService().altaConfiguration(),
                                        payload: (mapModel){
                                          return {
                                            "Usuarios": {
                                              "IdUsuario": mapModel["Usuarios"]["IdUsuario"]
                                            }
                                          };
                                        },
                                        itemBuilder: (mapModel){
                                          return Text(
                                            mapModel["Usuarios"]["Nombres"]+" "+mapModel["Usuarios"]["Apellidos"]
                                          );
                                        },
                                        onFinished: (){
                                          setState(() {
                                            refreshValue = Random().nextInt(99999);
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(width: 15,)
                            ],
                          ),
                        ),
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
                          onPressed: (){
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return MultipleRequestView(
                                  models: usuarios,
                                  title: "Borrar "+usuarios.length.toString()+" usuarios",
                                  service: UsuariosService(),
                                  doMethodConfiguration: UsuariosService().borraConfiguration(),
                                  payload: (mapModel){
                                    return {
                                      "Usuarios": {
                                        "IdUsuario": mapModel["Usuarios"]["IdUsuario"]
                                      }
                                    };
                                  },
                                  itemBuilder: (mapModel){
                                    return Text(
                                      mapModel["Usuarios"]["Nombres"]+" "+mapModel["Usuarios"]["Apellidos"]
                                    );
                                  },
                                  onFinished: (){
                                    setState(() {
                                      refreshValue = Random().nextInt(99999);
                                    });
                                  },
                                );
                              },
                            );
                          },
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
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              builder: (BuildContext context) {
                                return ModelViewDialog(
                                  content: ModelView(
                                    service: UsuariosService(),
                                    getMethodConfiguration: UsuariosService().dameConfiguration(idUsuario),
                                    isList: false,
                                    itemBuilder: (mapModel, index, itemController){
                                      return Usuarios().fromMap(mapModel).viewModel(context);
                                    },
                                  ),
                                );
                              },
                            );
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
                    },
                    searchArea: 
                      !showFilters ? 
                        Container() 
                      : 
                        Container(),
                  );
                }
              ),
            ],
          ),
        )
    );
  }
}