import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/Remitos.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/RemitosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/views/remitos/OperacionesRemitosAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class RemitosIndex extends StatefulWidget {
  final Map<String, dynamic> args;

  const RemitosIndex({Key key, this.args}) : super(key: key);
  @override
  _RemitosIndexState createState() => _RemitosIndexState();
}

class _RemitosIndexState extends State<RemitosIndex> {
Map<int, Remitos> remitos = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  String searchText = "";
  String searchEstado = "T";
  String searchTipo = "T";
  int searchIdUsuario = 0;
  int searchIdUbicacion = 0;
  int searchIdProducto = 0;
  int searchIdTela = 0;
  int searchIdLustre = 0;
  /*Search filters*/
  bool showFilters = false;
  TextEditingController desdeController = new TextEditingController();
  TextEditingController hastaController = new TextEditingController();
  var dateFormat = DateFormat("yyyy-MM-dd");
  var dateFormatShow = DateFormat("dd/MM/yyyy");
  String fechaInicio = '';
  String fechaHasta = '';
  Timer _debounce;
  RegExp dateRegEx;
  int idRemito;
  Map<String, String> args = new Map<String, String>();
  Map<String, String> breadcrumb = new Map<String, String>();

  @override
  void dispose() {
    desdeController.dispose();
    hastaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    breadcrumb.addAll({
      "Inicio":"/inicio",
      "Remitos": null,
    });
    dateRegEx = RegExp(Utils.regExDate);
    desdeController.addListener(() {
      _debounce = Timer(Duration(milliseconds: 500), (){
        if(dateRegEx.hasMatch(desdeController.text) && fechaInicio != dateFormat.format(DateFormat('dd/MM/yyyy').parse(desdeController.text))){
          setState(() {
            fechaInicio = dateFormat.format(DateFormat('dd/MM/yyyy').parse(desdeController.text));
          });
        }
      });
    });
    hastaController.addListener(() {
      _debounce = Timer(Duration(milliseconds: 500), (){
        if(dateRegEx.hasMatch(hastaController.text) && fechaHasta != dateFormat.format(DateFormat('dd/MM/yyyy').parse(hastaController.text))){
          setState(() {
            fechaHasta = dateFormat.format(DateFormat('dd/MM/yyyy').parse(hastaController.text));
          });
        }
      });
    });
    // desdeController.text = dateFormatShow.format(DateTime.now().subtract(Duration(days: 14)));
    // hastaController.text = dateFormatShow.format(DateTime.now());
    if (widget.args != null){
      args.addAll(widget.args);
      if (args["IdRemito"] != null){
        idRemito = int.parse(args["IdRemito"]);
        SchedulerBinding.instance.addPostFrameCallback((_) { 
            verRemito(idRemito: idRemito);
        });
      }
    }
    super.initState();
  }

  verRemito({int idRemito, int index, StreamController<ItemAction> itemsController}) async{
    await showDialog(
      context: context,
      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ModelViewDialog(
          title: "Remito",
          content: ModelView(
            service: RemitosService(),
            getMethodConfiguration: RemitosService().dameConfiguration(idRemito),
            isList: false,
            itemBuilder: (mapModel, index, itemController) {
              return Remitos().fromMap(mapModel).viewModel(context);
            },
          ),
        );
      },
    ).then((value){
      if(value != null){
        if (value){
          if(itemsController != null && index != null ){
            itemsController.add(
              ItemAction(
                event: ItemEvents.Update,
                index: index,
                updateMethodConfiguration: RemitosService().dameConfiguration(idRemito),
              )
            );
          }else{
            setState(() {
              refreshValue ++;
            });
          }
        }
      }   
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Flexible(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ZMBreadCrumb(
                        config: breadcrumb,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TopLabel(
                                        labelText: "Empleado",
                                      ),
                                      AutoCompleteField(
                                        labelText: "",
                                        hintText: "Ingrese un empleado",
                                        parentName: "Usuarios",
                                        keyName: "Usuario",
                                        service: UsuariosService(),
                                        paginate: true,
                                        pageLength: 4,
                                        onClear: (){
                                          setState(() {
                                            searchIdUsuario = 0;
                                          });
                                        },
                                        listMethodConfiguration: (searchText){
                                          return UsuariosService().buscarUsuarios({
                                            "Usuarios": {
                                              "Usuario": searchText
                                            }
                                          });
                                        },
                                        onSelect: (mapModel){
                                          if(mapModel != null){
                                            Usuarios usuario = Usuarios().fromMap(mapModel);
                                            setState(() {
                                              searchIdUsuario = usuario.idUsuario;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    constraints: BoxConstraints(minWidth: 200),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopLabel(
                                          labelText: "Ubicación de Entrada",
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
                                          errorMessage:
                                            "Debe seleccionar una ubicación",
                                          //initialValue: UsuariosProvider.idUbicacion,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 8)
                                          ),
                                          onChanged: (idSelected) {
                                            setState(() {
                                              searchIdUbicacion = idSelected;
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
                                    constraints: BoxConstraints(minWidth: 200),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopLabel(
                                          labelText: "Tipo",
                                        ),
                                        Container(
                                          width: 250,
                                          child: DropDownMap(
                                            map: Remitos().mapTipos(),
                                            addAllOption: true,
                                            addAllText: "Todos",
                                            addAllValue: "T",
                                            initialValue: "T",
                                            onChanged: (value) {
                                              setState(() {
                                                searchTipo = value;
                                              });
                                            },
                                          ),
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
                                    constraints: BoxConstraints(minWidth: 200),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopLabel(
                                          labelText: "Estado",
                                        ),
                                        Container(
                                          width: 250,
                                          child: DropDownMap(
                                            map: Remitos().mapEstados(),
                                            addAllOption: true,
                                            addAllText: "Todos",
                                            addAllValue: "T",
                                            initialValue: "T",
                                            onChanged: (value) {
                                              setState(() {
                                                searchEstado = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TextFormFieldDialog(
                                    inputFormatters: [DateTextFormatter()],
                                    controller: desdeController,
                                    labelText: "Desde",
                                    hintText: "dd/mm/yyyy",
                                  ),
                                ),
                                SizedBox(width: 12,),
                                Expanded(
                                  child: TextFormFieldDialog(
                                    inputFormatters: [DateTextFormatter()],
                                    controller: hastaController,
                                    labelText: "Hasta",
                                    hintText: "dd/mm/yyyy",
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
                                    color: showFilters
                                        ? Colors.blueAccent.withOpacity(0.8)
                                        : Theme.of(context).iconTheme.color.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: showFilters,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TopLabel(
                                        labelText: "Producto",
                                      ),
                                      AutoCompleteField(
                                        labelText: "",
                                        hintText: "Ingrese un producto",
                                        parentName: "Productos",
                                        keyName: "Producto",
                                        service: ProductosService(),
                                        paginate: true,
                                        pageLength: 4,
                                        onClear: (){
                                          setState(() {
                                            searchIdProducto = 0;
                                          });
                                        },
                                        listMethodConfiguration: (searchText){
                                          return ProductosService().buscarProductos({
                                            "Productos": {
                                              "Producto": searchText
                                            }
                                          });
                                        },
                                        onSelect: (mapModel){
                                          if(mapModel != null){
                                            Productos producto = Productos().fromMap(mapModel);
                                            setState(() {
                                              searchIdProducto = producto.idProducto;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TopLabel(
                                        labelText: "Tela",
                                      ),
                                      AutoCompleteField(
                                        labelText: "",
                                        hintText: "Ingrese una tela",
                                        parentName: "Telas",
                                        keyName: "Tela",
                                        service: TelasService(),
                                        paginate: true,
                                        pageLength: 4,
                                        onClear: (){
                                          setState(() {
                                            searchIdTela = 0;
                                          });
                                        },
                                        listMethodConfiguration: (searchText){
                                          return TelasService().buscarTelas({
                                            "Telas": {
                                              "Tela": searchText
                                            }
                                          });
                                        },
                                        onSelect: (mapModel){
                                          if(mapModel != null){
                                            Telas tela = Telas().fromMap(mapModel);
                                            setState(() {
                                              searchIdTela = tela.idTela;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    constraints: BoxConstraints(minWidth: 200),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopLabel(
                                          labelText: "Lustre",
                                        ),
                                        DropDownModelView(
                                          service: ProductosFinalesService(),
                                          listMethodConfiguration:
                                            ProductosFinalesService().listarLustres(),
                                          parentName: "Lustres",
                                          labelName: "Seleccione un lustre",
                                          displayedName: "Lustre",
                                          valueName: "IdLustre",
                                          allOption: true,
                                          allOptionText: "Todos",
                                          allOptionValue: 0,
                                          initialValue: 0,
                                          errorMessage:
                                            "Debe seleccionar un lustre",
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 8)
                                          ),
                                          onChanged: (idSelected) {
                                            setState(() {
                                              searchIdLustre = idSelected;
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible( 
                  fit: FlexFit.tight,
                  child: AppLoader(builder: (scheduler) {
                    return ZMTable(
                      key: Key(searchText + refreshValue.toString() + searchEstado.toString() + searchTipo.toString() + searchIdUsuario.toString() + searchIdUbicacion.toString() + 
                      searchIdProducto.toString() + searchIdTela.toString() + searchIdLustre.toString() + fechaInicio + fechaHasta),
                      model: Remitos(),
                      service: RemitosService(),
                      listMethodConfiguration: RemitosService().buscarRemitos({
                        "Remitos": {
                          "Estado": searchEstado,
                          "Tipo": searchTipo,
                          "IdUsuario": searchIdUsuario,
                          "IdUbicacion": searchIdUbicacion,
                        },
                        "ProductosFinales": {
                          "IdProducto": searchIdProducto,
                          "IdTela": searchIdTela,
                          "IdLustre": searchIdLustre
                        },
                        "ParametrosBusqueda": {
                          "FechaEntregaDesde": fechaInicio,
                          "FechaEntregaHasta": fechaHasta,
                        },
                      }),
                      pageLength: 12,
                      paginate: true,
                      idName: "Cod.",
                      idValue: (mapModel){
                        return mapModel["Remitos"]["IdRemito"].toString();
                      },
                      cellBuilder: {
                        "LineasRemito": {
                          "*": (mapModel){
                            if(mapModel != null){
                              List<Widget> _lineasRemito = List<Widget>();
                              int index = 0;
                              mapModel["LineasRemito"].forEach(
                                (lineaRemito){
                                  if(index < 3){
                                    LineasProducto _lineaProducto = LineasProducto().fromMap(lineaRemito);
                                    _lineasRemito.add(
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _lineaProducto.cantidad.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7-index*0.15),
                                                      fontSize: 13
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      _lineaProducto.productoFinal.producto.producto + 
                                                      " " + (_lineaProducto.productoFinal.tela?.tela??"") +
                                                      " " + (_lineaProducto.productoFinal.lustre?.lustre??""),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(1-index*0.33),
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    );
                                  }
                                  index ++;
                                }
                              );
                              return Column(
                                children: _lineasRemito,
                              );
                            }
                            return Container();
                          }
                        },
                        "Remitos": {
                          "FechaAlta": (value){
                              if(value != null){
                                return Text(
                                  Utils.cuteDateTimeText(DateTime.parse(value)),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                );
                              }else{
                                return Text(
                                  "-",
                                  textAlign: TextAlign.center);
                              }
                            },
                          "FechaEntrega": (value){
                              if(value != null){
                                return Text(
                                  Utils.cuteDateTimeText(DateTime.parse(value)),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600
                                  ),
                                );
                              }else{
                                return Text(
                                  "-",
                                  textAlign: TextAlign.center);
                              }
                          },
                          "Tipo": (value) {
                            return Text(
                              Remitos().mapTipos()[value.toString()],
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                          "Estado": (value) {
                            return Text(
                              Remitos().mapEstados()[value.toString()],
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        },
                        "Ubicaciones": {
                          "Ubicacion": (value) {
                            return Text(
                              value != null ? value.toString() : "-",
                              textAlign: TextAlign.center,
                            );
                          },
                        }
                      },
                      tableLabels: {
                        "LineasRemito": {
                          "*": "Detalle"
                        },
                        "Remitos":{
                          "FechaAlta": "Fecha Alta",
                          "FechaEntrega": "Fecha de Entrega"
                        }
                      },
                      defaultWeight: 2,
                      tableWeights: {
                        "LineasRemito": {
                          "*": 5
                        }
                      },
                      fixedActions: [
                        ZMStdButton(
                          color: Colors.green,
                          text: Text(
                            "Crear remito",
                            style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold
                            ),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return OperacionesRemitosAlertDialog(
                                  title: "Crear remito",
                                  onSuccess: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      refreshValue = Random().nextInt(99999);
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                      rowActions: (mapModel, index, itemsController) {
                        Remitos remito;
                        String estado = "C";
                        String tipo;
                        int idRemito = 0;
                        if (mapModel != null) {
                          remito = Remitos().fromMap(mapModel);
                          if (mapModel["Remitos"] != null) {
                            if (mapModel["Remitos"]["Estado"] != null) {
                              estado = mapModel["Remitos"]["Estado"];
                            }
                            if (mapModel["Remitos"]["IdRemito"] != null) {
                              idRemito = mapModel["Remitos"]["IdRemito"];
                            }
                            if (mapModel["Remitos"]["Tipo"] != null) {
                              tipo = mapModel["Remitos"]["Tipo"];
                            }
                          }
                        }
                        return <Widget>[
                          ZMTooltip(
                            message: estado != "E" ? "Ver remito" : "Modificar remito",
                            visible: idRemito != 0,
                            child: IconButtonTableAction(
                              iconData: estado != "E" ? Icons.remove_red_eye : Icons.edit,
                              onPressed: idRemito == 0 ? null : estado == "E" && (tipo == "X" || tipo == "Y") ? null : () async{
                                if (idRemito != 0) {
                                  if(remito.estado != "E"){
                                    verRemito(idRemito: idRemito, index: index, itemsController: itemsController);
                                  }else{
                                    await RemitosService(scheduler: scheduler).damePor(RemitosService().dameConfiguration(idRemito)).then((response) async{
                                      if(response.status == RequestStatus.SUCCESS){
                                        setState(() {
                                          remito = response.message;
                                        });
                                        await showDialog(
                                          context: context,
                                          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return OperacionesRemitosAlertDialog(
                                              title: "Modificar remito",
                                              remito: remito,
                                              onSuccess: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  refreshValue = Random().nextInt(99999);
                                                });
                                              },
                                            );
                                          },
                                        ).then((value){
                                          if(value != null){
                                            if (value){
                                              setState(() {
                                                refreshValue = Random().nextInt(99999);
                                              });
                                            }
                                          }
                                        });
                                      }
                                    });
                                  }
                                }
                              }
                            ),
                          ),
                          ZMTooltip(
                            message: "Borrar",
                            theme: ZMTooltipTheme.RED,
                            visible: idRemito != 0,
                            child: IconButtonTableAction(
                              iconData: Icons.delete_outline,
                              onPressed: idRemito == 0 ? null : () {
                                if (idRemito != 0) {
                                  showDialog(
                                    context: context,
                                    barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                    builder: (BuildContext context) {
                                      return DeleteAlertDialog(
                                        title: "Borrar remito",
                                        message: "¿Está seguro que desea eliminar el remito?",
                                        onAccept: () async {
                                          await RemitosService().borra({
                                            "Remitos": {"IdRemito": idRemito}
                                          }).then((response) {
                                            if (response.status == RequestStatus.SUCCESS) {
                                              itemsController.add(
                                                ItemAction(
                                                  event: ItemEvents.Hide,
                                                  index: index
                                                )
                                              );
                                            }
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          (estado == "C" || estado == "B" ) ? ZMTooltip(
                            key: Key("Estadoremito"+estado),
                            message: estado == "C" ? "Cancelar" : "Descancelar",
                            theme: estado == "C" ? ZMTooltipTheme.RED : ZMTooltipTheme.GREEN,
                            visible: idRemito != 0,
                            child: IconButtonTableAction(
                              iconData: (estado == "C"
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward),
                              color: estado == "C" ? Colors.redAccent : Colors.green,
                              onPressed: idRemito == 0 ? null : () {
                                if (idRemito != 0) {
                                  if (estado == "C") {
                                    RemitosService(context: context, scheduler: scheduler).doMethod(RemitosService().cancelar({"Remitos":{"IdRemito": idRemito}})).then((response){
                                      if(response.status == RequestStatus.SUCCESS){
                                        itemsController.add(
                                          ItemAction(
                                            event: ItemEvents.Update,
                                            index: index,
                                            updateMethodConfiguration: RemitosService().dameConfiguration(idRemito)
                                          )
                                        );
                                      }
                                    });
                                  } else {
                                    RemitosService(context: context, scheduler: scheduler).doMethod(RemitosService().descancelar({"Remitos":{"IdRemito": idRemito}})).then((response){
                                      if(response.status == RequestStatus.SUCCESS){
                                        itemsController.add(
                                          ItemAction(
                                            event: ItemEvents.Update,
                                            index: index,
                                            updateMethodConfiguration: RemitosService().dameConfiguration(idRemito)
                                          )
                                        );
                                      }
                                    });
                                  }
                                }
                              },
                            ),
                          ) : Opacity(
                            opacity: 0,
                            child: IconButtonTableAction(
                              iconData: Icons.message,
                              color: Theme.of(context).backgroundColor,
                              onPressed: null
                            ),
                          ),
                        ];
                      },
                      searchArea: TableTitle(
                        title: "Remitos"
                      )
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ));
  }



}