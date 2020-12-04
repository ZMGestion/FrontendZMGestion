import 'dart:math';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Lustres.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Stock.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/services/ProductosFinalesService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/services/TelasService.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/LoadingWidget.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/NumberInputWithIncrementDecrement.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class ZMLineaProductoSinPrecio extends StatefulWidget {
  final int idReferencia;
  final LineasProducto lineaProducto;
  final Function(LineasProducto lp, Map<int, int> cantidadUbicacion) onAccept; 
  final Function() onCancel; 

  const ZMLineaProductoSinPrecio({
    Key key,
    this.idReferencia,
    this.lineaProducto,
    this.onAccept,
    this.onCancel
  }): super(key: key);
  @override
  _ZMLineaProductoSinPrecioState createState() => _ZMLineaProductoSinPrecioState();
}

class _ZMLineaProductoSinPrecioState extends State<ZMLineaProductoSinPrecio> {

  int _cantidad = 1;
  int _idLineaProducto;
  Productos _productoSeleccionado;
  Telas _telaSeleccionada;
  Lustres _lustreSeleccionado;
  int _idLustre;
  bool _loading = true;
  bool _fromStock = false;

  List<Stock> stock = List<Stock>();
  Map<int, int> cantidadSolicitadaUbicacion = Map<int, int>();

  @override
  void initState() {
    // TODO: implement initState
    
    if(widget.lineaProducto != null){
      _cantidad = widget.lineaProducto.cantidad;
      if(widget.lineaProducto.idLineaProducto != 0){
        _idLineaProducto = widget.lineaProducto.idLineaProducto;
      }
      _lustreSeleccionado = widget.lineaProducto.productoFinal?.lustre;
      _idLustre = widget.lineaProducto.productoFinal?.idLustre??null;
      SchedulerBinding.instance.addPostFrameCallback((_) async{
        Response<Models<dynamic>> responseProducto;
        Response<Models<dynamic>> responseTela;
        if(widget.lineaProducto.productoFinal.producto?.idProducto != null){
          responseProducto = await ProductosService().damePor(ProductosService().dameConfiguration(widget.lineaProducto.productoFinal.idProducto));
        }
        if(widget.lineaProducto.productoFinal.tela?.idTela != null){
          responseTela = await TelasService().damePor(TelasService().dameConfiguration(widget.lineaProducto.productoFinal.idTela));
        }
        setState(() {
          if(responseProducto?.status == RequestStatus.SUCCESS){
            _productoSeleccionado = Productos().fromMap(responseProducto.message.toMap());
          }
          if(responseTela?.status == RequestStatus.SUCCESS){
            _telaSeleccionada = Telas().fromMap(responseTela.message.toMap());
          }
          _loading = false;
        });
      });
    }else{
      _loading = false;
    }
    super.initState();
  }

  int _getStockTotal(List<Stock> _stock){
    int _stockTotal = 0;
    if(_stock.length > 0){
      _stock.forEach((s) {
        _stockTotal += s.cantidad;
      });
    }
    return _stockTotal;
  }

  int _totalSolicitado(Map<int, int> _cantidadSolicitada){
    int _cantidadTotal = 0;
    if(_cantidadSolicitada.isNotEmpty){
      _cantidadSolicitada.forEach((ubicacion, cantidad) {
        _cantidadTotal += cantidad;
      });
    }
    return _cantidadTotal;
  }

  int _determinarMax(int cantidadActual, int cantidadUbicacion, Map<int, int> _cantidadSolicitadaUbicacion, int idUbicacion){
    int c = 0;
    if(cantidadActual < cantidadUbicacion){
      c = cantidadActual;
    }else{
      c = cantidadUbicacion;
    }
    if(c - _totalSolicitado(_cantidadSolicitadaUbicacion) <= 0){
      if(_cantidadSolicitadaUbicacion.containsKey(idUbicacion)){
        c = _cantidadSolicitadaUbicacion[idUbicacion];
      }else{
        return 0;
      }
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        Visibility(
          visible: _loading,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Center(
              child: LoadingWidget()
            ),
          ),
        ),
        Visibility(
          visible: !_loading,
          child: Card(
            color: Color(0xff042949).withOpacity(0.55),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: NumberInputWithIncrementDecrement(
                                  labelText: "Cantidad",
                                  initialValue: _cantidad,
                                  textStyle: TextStyle(
                                    color: Color(0xffBADDFB)
                                  ),
                                  hintStyle: TextStyle(
                                    color: Color(0xffBADDFB).withOpacity(0.8)
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color(0xffBADDFB).withOpacity(0.8)
                                  ),
                                  onChanged: (value){
                                    setState(() {
                                      _cantidad = value;
                                    });
                                  },
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopLabel(
                        labelText: "Producto",
                        color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8)
                      ),
                      AutoCompleteField(
                        labelText: "",
                        hintText: "Ingrese un producto",
                        parentName: "Productos",
                        keyName: "Producto",
                        service: ProductosService(),
                        paginate: true,
                        pageLength: 4,
                        initialValue: _productoSeleccionado?.producto,
                        invalidTextColor: Color(0xffffaaaa),
                        validTextColor: Color(0xffaaffaa),
                        prefixIcon: Icon(
                          FontAwesomeIcons.boxOpen,
                          size: 17,
                          color: Color(0xff87C2F5).withOpacity(0.8),
                        ),
                        hintStyle: TextStyle(
                          color: Color(0xffBADDFB).withOpacity(0.8)
                        ),
                        onClear: (){
                          setState(() {
                            //searchIdProducto = 0;
                              _productoSeleccionado = null;
                              _fromStock = false;
                              stock = [];
                              cantidadSolicitadaUbicacion = {};
                          });
                        },
                        listMethodConfiguration: (searchText){
                          return ProductosService().buscarProductos({
                            "Productos": {
                              "Producto": searchText
                            }
                          });
                        },
                        onSelect: (mapModel) async{
                          if(mapModel != null){
                            Productos producto = Productos().fromMap(mapModel);
                            setState(() {
                              _fromStock = false;
                              stock = [];
                              cantidadSolicitadaUbicacion = {};
                              _productoSeleccionado = producto;
                              if(!_productoSeleccionado.esFabricable()){
                                _telaSeleccionada = null;
                                _lustreSeleccionado = null;
                              }else if(_productoSeleccionado.longitudTela <= 0){
                                _telaSeleccionada = null;
                              }
                            });
                            ProductosService().getMethod(ProductosService().dameConfiguration(producto?.idProducto)).then(
                              (response){
                                if(response.status == RequestStatus.SUCCESS){
                                  print(response.message.toMap());
                                  Productos _producto = Productos().fromMap(response.message.toMap());
                                  setState(() {
                                    stock = _producto.stock;
                                  });
                                }
                              }
                            );
                          }
                        },
                      ),
                      Visibility(
                        visible: _productoSeleccionado != null,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Container(
                                color: _fromStock ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 2,
                                              color: _fromStock ? Colors.blue.withOpacity(0.3) : Colors.blue.withOpacity(0.15)
                                            )
                                          )
                                        ),
                                        child: MaterialButton(
                                          onPressed: _getStockTotal(stock) == 0 ? null : (){
                                            setState(() {
                                              _fromStock = !_fromStock;
                                              cantidadSolicitadaUbicacion.clear();
                                            });
                                          },
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircularCheckBox(
                                                      value: _fromStock,
                                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                                      onChanged: _getStockTotal(stock) == 0 ? null : (value) {
                                                        setState(() {
                                                          _fromStock = value;
                                                        });
                                                      },
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        _getStockTotal(stock) == 0 ? "Sin stock" : "Stock producto: "+_getStockTotal(stock).toString(),
                                                        style: TextStyle(
                                                          color: Colors.white.withOpacity(0.7),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15
                                                        )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  _fromStock ? Icons.arrow_drop_up : Icons.arrow_drop_down
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _fromStock,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 24),
                                      child: Container(
                                        height: 120,
                                        color: Colors.black12,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: stock.length,
                                            itemBuilder: (context, index){
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: stock[index].ubicacion.ubicacion+" ",
                                                        style: TextStyle(
                                                          color: Colors.white.withOpacity(0.8)
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: "("+stock[index].cantidad.toString()+")",
                                                            style: TextStyle(
                                                              color: Colors.white.withOpacity(0.45)
                                                            )
                                                          )
                                                        ],

                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SpinBox(
                                                      direction: Axis.horizontal,
                                                      incrementIcon: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                      decrementIcon: Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                      decimals: 0,
                                                      min: 0,
                                                      max: _determinarMax(_cantidad, stock[index].cantidad, cantidadSolicitadaUbicacion, stock[index].ubicacion.idUbicacion).toDouble(),
                                                      textStyle: TextStyle(
                                                        color: Colors.white.withOpacity(0.8),
                                                        fontSize: 14
                                                      ),
                                                      onChanged: (value){
                                                        setState(() {
                                                          int key = stock[index].ubicacion.idUbicacion;
                                                          if(cantidadSolicitadaUbicacion.containsKey(key)){
                                                            cantidadSolicitadaUbicacion[key] = value.toInt();
                                                          }else{
                                                            cantidadSolicitadaUbicacion.addAll({key: value.toInt()});
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Visibility(
                        visible: _productoSeleccionado != null ? _productoSeleccionado.esFabricable() : false,
                        child: Column(
                          children: [
                            Visibility(
                              visible: _productoSeleccionado != null ? _productoSeleccionado.longitudTela > 0 : false,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopLabel(
                                          labelText: "Tela",
                                          color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8)
                                        ),
                                        AutoCompleteField(
                                          labelText: "",
                                          hintText: "Ingrese una tela",
                                          parentName: "Telas",
                                          keyName: "Tela",
                                          service: TelasService(),
                                          initialValue: _telaSeleccionada?.tela,
                                          paginate: true,
                                          pageLength: 4,
                                          hintStyle: TextStyle(
                                            color: Color(0xffBADDFB).withOpacity(0.8)
                                          ),
                                          prefixIcon: Icon(
                                            FontAwesomeIcons.buffer,
                                            size: 19,
                                            color: Color(0xff87C2F5).withOpacity(0.8),
                                          ),
                                          invalidTextColor: Color(0xffffaaaa),
                                          validTextColor: Color(0xffaaffaa),
                                          onClear: (){
                                            setState(() {
                                              _telaSeleccionada = null;
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
                                                _telaSeleccionada = tela;
                                                //searchIdTela = tela.idTela;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    constraints: BoxConstraints(minWidth: 200),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopLabel(
                                          labelText: "Lustre",
                                          color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8)
                                        ),
                                        DropDownModelView(
                                          service: ProductosFinalesService(),
                                          listMethodConfiguration: ProductosFinalesService().listarLustres(),
                                          parentName: "Lustres",
                                          labelName: "Seleccione un lustre",
                                          displayedName: "Lustre",
                                          valueName: "IdLustre",
                                          initialValue: _idLustre,
                                          errorMessage:
                                            "Debe seleccionar un lustre",
                                          textStyle: TextStyle(
                                            color: Color(0xff87C2F5).withOpacity(0.8),
                                          ),
                                          modelInfo: (mapModel){
                                            setState(() {
                                              _lustreSeleccionado = Lustres().fromMap(mapModel);
                                            });
                                          },
                                          dropdownColor: Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              FontAwesomeIcons.brush,
                                              size: 18,
                                              color: Color(0xff87C2F5).withOpacity(0.8),  
                                            ),
                                            hintStyle: TextStyle(
                                              color: Color(0xffBADDFB).withOpacity(0.8)
                                            ),
                                            labelStyle: TextStyle(
                                              color: Colors.white
                                            ),
                                          ),
                                          onChanged: (idSelected) {
                                            setState(() {
                                              _idLustre = idSelected;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZMStdButton(
              color: Theme.of(context).primaryTextTheme.headline6.color,
              icon: Icon(
                widget.lineaProducto != null ? Icons.edit : Icons.add,
                color: Theme.of(context).primaryColorLight,
                size: 16,
              ),
              text: Text(
                widget.lineaProducto != null ? "Modificar" : "Agregar",
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: _loading ? null : (){
                widget.onAccept(
                  LineasProducto(
                    idLineaProducto: _idLineaProducto,
                    idReferencia: widget.idReferencia,
                    cantidad: _cantidad,
                    productoFinal: ProductosFinales(
                      idLustre: _lustreSeleccionado?.idLustre,
                      idProducto: _productoSeleccionado?.idProducto,
                      idTela: _telaSeleccionada?.idTela,
                      producto: _productoSeleccionado,
                      tela: _telaSeleccionada,
                      lustre: _lustreSeleccionado
                    ),
                  ),
                  cantidadSolicitadaUbicacion
                );
              },
            ),
            SizedBox(
              width: 12,
            ),
            ZMTextButton(
              color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.9),
              text: "Cancelar",
              onPressed: widget.onCancel
            ),
          ],
        )
      ],
    );
  }
}