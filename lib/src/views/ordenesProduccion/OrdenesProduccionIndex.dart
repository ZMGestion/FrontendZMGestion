import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:zmgestion/src/helpers/DateTextFormatter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/ModelViewDialog.dart';
import 'package:zmgestion/src/widgets/MultipleRequestView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMBreadCrumb/ZMBreadCrumbItem.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class OrdenesProduccionIndex extends StatefulWidget {
  final Map<String, String> args;

  const OrdenesProduccionIndex({Key key, this.args}) : super(key: key);

  @override
  _OrdenesProduccionIndexState createState() => _OrdenesProduccionIndexState();
}

class _OrdenesProduccionIndexState extends State<OrdenesProduccionIndex> {
  Map<int, OrdenesProduccion> ordenesProduccion = {};

  /*ZMTable key*/
  int refreshValue = 0;

  /*Search*/
  String searchText = "";
  String searchIdEstado = "T";
  int searchIdCliente = 0;
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
      "Órdenes de producción": null,
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
    desdeController.text = dateFormatShow.format(DateTime.now().subtract(Duration(days: 14)));
    hastaController.text = dateFormatShow.format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                                          labelText: "Fabricante",
                                        ),
                                        AutoCompleteField(
                                          labelText: "",
                                          hintText: "Ingrese un fabricante",
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopLabel(
                                          labelText: "Revisor",
                                        ),
                                        AutoCompleteField(
                                          labelText: "",
                                          hintText: "Ingrese un revisor",
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
                                            labelText: "Estado",
                                          ),
                                          Container(
                                            child: DropDownMap(
                                              map: OrdenesProduccion().mapEstados(),
                                              addAllOption: true,
                                              addAllText: "Todos",
                                              addAllValue: "T",
                                              initialValue: "T",
                                              onChanged: (value) {
                                                setState(() {
                                                  searchIdEstado = value;
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
                        key: Key(searchText + refreshValue.toString() + searchIdEstado.toString() + searchIdCliente.toString() + searchIdUsuario.toString() + searchIdUbicacion.toString() + 
                        searchIdProducto.toString() + searchIdTela.toString() + searchIdLustre.toString() + fechaInicio + fechaHasta),
                        model: OrdenesProduccion(),
                        service: OrdenesProduccionService(),
                        listMethodConfiguration: OrdenesProduccionService().buscarOrdenesProduccion({
                          "OrdenesProduccion": {
                            "Estado": searchIdEstado,
                            "IdCliente": searchIdCliente,
                            "IdUsuario": searchIdUsuario,
                            "IdUbicacion": searchIdUbicacion,
                          },
                          "ProductosFinales": {
                            "IdProducto": searchIdProducto,
                            "IdTela": searchIdTela,
                            "IdLustre": searchIdLustre
                          },
                          "ParametrosBusqueda": {
                            "FechaInicio": fechaInicio,
                            "FechaFin": fechaHasta
                          }
                        }),
                        pageLength: 12,
                        paginate: true,
                        idName: "Cod.",
                        idValue: (mapModel){
                          return mapModel["OrdenesProduccion"]["IdOrdenProduccion"].toString();
                        },
                        cellBuilder: {
                          "LineasOrdenProduccion": {
                            "*": (mapModel){
                              if(mapModel != null){
                                List<Widget> _lineasOrdenProduccion = List<Widget>();
                                int index = 0;
                                mapModel["LineasOrdenProduccion"].forEach(
                                  (lineaOrdenProduccion){
                                    if(index < 3){
                                      LineasProducto _lineaProducto = LineasProducto().fromMap(lineaOrdenProduccion);
                                      _lineasOrdenProduccion.add(
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
                                  children: _lineasOrdenProduccion,
                                );
                              }
                              return Container();
                            }
                          },
                          "OrdenesProduccion": {
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
                            "Estado": (value) {
                              return Text(
                                OrdenesProduccion().mapEstados()[value.toString()],
                                textAlign: TextAlign.center,
                              );
                            },
                          }
                        },
                        tableLabels: {
                          "OrdenesProduccion": {
                            "FechaAlta": "Fecha"
                          },
                          "LineasOrdenProduccion": {
                            "*": "Detalle"
                          }
                        },
                        defaultWeight: 2,
                        tableWeights: {
                          "OrdenesProduccion": {
                            "Estado": 1
                          },
                          "LineasOrdenProduccion": {
                            "*": 5
                          }
                        },
                        fixedActions: [
                          ZMStdButton(
                            color: Colors.green,
                            text: Text(
                              "Nueva orden de producción",
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
                                barrierDismissible: true,
                                barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                builder: (BuildContext context) {
                                  return OrdenesProduccionAlertDialog(
                                    title: "Nueva orden de producción",
                                  );
                                },
                              );
                            },
                          ),
                          
                        ],
                        onSelectActions: (ordenesProduccion) {
                          bool estadosIguales = true;
                          bool clientesIguales = true;
                          bool algunVendido = false;
                          String estado;
                          if (ordenesProduccion.length >= 1) {
                            Map<String, dynamic> anterior;
                            for (OrdenesProduccion ordenProduccion in ordenesProduccion) {
                              Map<String, dynamic> mapOrdenProduccion = ordenProduccion.toMap();
                              if(mapOrdenProduccion["OrdenesProduccion"]["Estado"] == 'V'){
                                algunVendido = true;
                              }
                              if (anterior != null) {
                                if (anterior["OrdenesProduccion"]["Estado"] != mapOrdenProduccion["OrdenesProduccion"]["Estado"]) {
                                  estadosIguales = false;
                                }
                                if (anterior["OrdenesProduccion"]["IdCliente"] != mapOrdenProduccion["OrdenesProduccion"]["IdCliente"]) {
                                  clientesIguales = false;
                                }
                              }
                              if (!estadosIguales && !clientesIguales) break;
                              anterior = mapOrdenProduccion;
                            }
                            if (estadosIguales) {
                              estado = ordenesProduccion[0].toMap()["OrdenesProduccion"]["Estado"];
                            }
                          }
                          return <Widget>[
                            Visibility(
                              visible: (algunVendido),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Sin acciones",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !algunVendido,
                              child: ZMStdButton(
                                color: Colors.red,
                                text: Text(
                                  "Borrar (" + ordenesProduccion.length.toString() + ")",
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
                                onPressed: () {
                                  if(ordenesProduccion != null){
                                    showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return MultipleRequestView(
                                          models: ordenesProduccion,
                                          title: "Borrar "+ordenesProduccion.length.toString()+" ordenesProduccion",
                                          service: OrdenesProduccionService(),
                                          doMethodConfiguration: OrdenesProduccionService().borraConfiguration(),
                                          payload: (mapModel) {
                                            return {
                                              "OrdenesProduccion": {
                                                "IdOrdenProduccion": mapModel["OrdenesProduccion"]["IdOrdenProduccion"]
                                              }
                                            };
                                          },
                                          itemBuilder: (mapModel) {
                                            return Text(mapModel["OrdenesProduccion"]["IdOrdenProduccion"].toString());
                                          },
                                          onFinished: () {
                                            setState(() {
                                              refreshValue = Random().nextInt(99999);
                                            });
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            )
                          ];
                        },
                        rowActions: (mapModel, index, itemsController) {
                          OrdenesProduccion ordenProduccion;
                          String estado = "C";
                          int idOrdenProduccion = 0;
                          if (mapModel != null) {
                            ordenProduccion = OrdenesProduccion().fromMap(mapModel);
                            if (mapModel["OrdenesProduccion"] != null) {
                              if (mapModel["OrdenesProduccion"]["Estado"] != null) {
                                estado = mapModel["OrdenesProduccion"]["Estado"];
                              }
                              if (mapModel["OrdenesProduccion"]["IdOrdenProduccion"] != null) {
                                idOrdenProduccion = mapModel["OrdenesProduccion"]["IdOrdenProduccion"];
                              }
                            }
                          }
                          return <Widget>[
                            Opacity(
                              opacity: idOrdenProduccion == 0 ? 0.2 : (estado  != "E" ? 1 : 0.2),
                              child: ZMTooltip(
                                message: "Ver orden de producción",
                                visible: idOrdenProduccion != 0,
                                child: IconButtonTableAction(
                                  iconData: Icons.remove_red_eye,
                                  onPressed: idOrdenProduccion == 0 ? null : estado  == "E" ? null : () async{
                                    if (idOrdenProduccion != 0) {
                                      await showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                        builder: (BuildContext context) {
                                          return ModelViewDialog(
                                            title: "Orden producción",
                                            content: Container(
                                              width: SizeConfig.blockSizeHorizontal*50,
                                              constraints: BoxConstraints(
                                                minWidth: 500,
                                                maxWidth: 800,
                                              ),
                                              child: ModelView(
                                                service: OrdenesProduccionService(),
                                                getMethodConfiguration: OrdenesProduccionService().dameConfiguration(idOrdenProduccion),
                                                isList: false,
                                                itemBuilder: (mapModel, index, itemController) {
                                                  return OrdenesProduccion().fromMap(mapModel).viewModel(context);
                                                },
                                              ),
                                            ),
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
                                  }
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: idOrdenProduccion == 0 ? 0.2 : (estado  != "V" ? 1 : 0.2),
                              child: ZMTooltip(
                                message: "Editar",
                                visible: idOrdenProduccion != 0,
                                child: IconButtonTableAction(
                                  iconData: Icons.edit,
                                  onPressed: idOrdenProduccion == 0 ? null : estado  == "V" ? null : (){
                                    if (idOrdenProduccion != 0) {
                                      showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                        builder: (BuildContext context) {
                                          return ModelViewDialog(
                                            content: ModelView(
                                              service: OrdenesProduccionService(),
                                              getMethodConfiguration: OrdenesProduccionService().dameConfiguration(idOrdenProduccion),
                                              isList: false,
                                              itemBuilder: (mapModel, internalIndex, itemController) {
                                                OrdenesProduccion _ordenProduccion = OrdenesProduccion().fromMap(mapModel);
                                                return OrdenesProduccionAlertDialog(
                                                  title: "Modificar orden de producción",
                                                  ordenProduccion: _ordenProduccion,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            ZMTooltip(
                              message: "Borrar",
                              visible: idOrdenProduccion != 0,
                              theme: ZMTooltipTheme.RED,
                              child: IconButtonTableAction(
                                iconData: Icons.delete_outline,
                                onPressed: idOrdenProduccion == 0 ? null : (){
                                  if (idOrdenProduccion != 0) {
                                    showDialog(
                                      context: context,
                                      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                      builder: (BuildContext context) {
                                        return DeleteAlertDialog(
                                          title: "Borrar ordenProduccion",
                                          message: "¿Está seguro que desea eliminar el ordenProduccion?",
                                          onAccept: () async {
                                            await OrdenesProduccionService().borra({
                                              "OrdenesProduccion": {"IdOrdenProduccion": idOrdenProduccion}
                                            }).then((response) {
                                              if (response.status ==
                                                  RequestStatus.SUCCESS) {
                                                itemsController.add(ItemAction(
                                                    event: ItemEvents.Hide,
                                                    index: index));
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
                            )
                          ];
                        },
                        searchArea: TableTitle(
                          title: "Órdenes de producción"
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
