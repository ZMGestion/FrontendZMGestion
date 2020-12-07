import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenProduccionCreadaDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/ConfirmationAlertDialog.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMListLineasProducto.dart';
import 'package:zmgestion/src/widgets/ZMLineaProductoSinPrecio/ZMLineaProductoSinPrecio.dart';

class OrdenesProduccionNew extends StatefulWidget{
  final String title;
  final Function() updateAllCallback;
  final Function() updateRowCallback;
  final OrdenesProduccion ordenProduccion;
  final Function(dynamic) onError;

  const OrdenesProduccionNew({
    Key key,
    this.title = "",
    this.updateAllCallback,
    this.updateRowCallback,
    this.ordenProduccion,
    this.onError
  }) : super(key: key);

  @override
  _OrdenesProduccionNewState createState() => _OrdenesProduccionNewState();
}

class _OrdenesProduccionNewState extends State<OrdenesProduccionNew> {
  final _formKey = GlobalKey<FormState>();

  bool ubicacionCargada = false;
  Usuarios usuario;
  OrdenesProduccion ordenProduccion;
  bool showLineasForm = false;
  LineasProducto _lineaProductoEditando;
  bool _editing = false;
  bool _changed = false;

  List<LineasProducto> _lineasProducto = [];

  @override
  void initState() {
    ordenProduccion = widget.ordenProduccion;
    if(ordenProduccion != null){
      _editing = true;
      _lineasProducto = widget.ordenProduccion.lineasProducto;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if(!ubicacionCargada){
      final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(context);
      setState(() {
        usuario = _usuariosProvider.usuario;
        ubicacionCargada = true;
      });
    }
      return AppLoader(
        builder: (scheduler){
          return Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 50,
                            constraints: BoxConstraints(
                              minWidth: 400,
                              maxWidth: 500,
                            ),
                            child: Card(
                              color: Theme.of(context).primaryColorLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: !showLineasForm,
                                      child: Column(
                                        children: [
                                          Visibility(
                                            visible: _lineasProducto.length > 0,
                                            child: ZMListLineasProducto(
                                              key: Key(_lineasProducto.length.toString()),
                                              withPrice: false,
                                              lineasProducto: _lineasProducto,
                                              onEdit: (LineasProducto lp){
                                                setState(() {
                                                  _lineaProductoEditando = lp;
                                                  showLineasForm = true;
                                                });
                                              },
                                              onDelete: (LineasProducto lp){
                                                showDialog(
                                                  context: context,
                                                  barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                                  builder: (BuildContext context) {
                                                    return DeleteAlertDialog(
                                                      title: "Borrar linea de producto",
                                                      message: "¿Está seguro que desea eliminar la linea?",
                                                      onAccept: () async {
                                                        OrdenesProduccionService().doMethod(OrdenesProduccionService().borrarLineaOrdenProduccion({
                                                          "LineasProducto": {"IdLineaProducto": lp.idLineaProducto}
                                                        })).then((response) {
                                                          if (response.status == RequestStatus.SUCCESS){
                                                            setState(() {
                                                              _changed = true;
                                                              _lineasProducto.remove(lp);
                                                            });
                                                          }
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                            ),
                                          ),
                                          Visibility(
                                            visible: _lineasProducto.length <= 0,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.7),
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    "Ingrese al menos una linea",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).primaryTextTheme.headline6.color.withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ZMStdButton(
                                                color: Theme.of(context).primaryTextTheme.headline6.color,
                                                icon: Icon(
                                                  Icons.add,
                                                  color: Theme.of(context).primaryColorLight,
                                                  size: 16,
                                                ),
                                                text: Text(
                                                  "Agregar linea",
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColorLight,
                                                    fontWeight: FontWeight.w600
                                                  )
                                                ),
                                                onPressed: (){
                                                  setState(() {
                                                    showLineasForm = true;
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: showLineasForm,
                                      child: ZMLineaProductoSinPrecio(
                                        lineaProducto: _lineaProductoEditando,
                                        onCancel: (){
                                          setState(() {
                                            _lineaProductoEditando = null;
                                            showLineasForm = false;
                                          });
                                        },
                                        onAccept: (lp, stockUbicacion) async{
                                          if(!showLineasForm){
                                            setState(() {
                                              showLineasForm = true;
                                            });
                                          }else{
                                            if(_formKey.currentState.validate()){
                                              if(_lineaProductoEditando != null){
                                                if(ordenProduccion != null){
                                                  LineasProducto _lp = LineasProducto(
                                                    idLineaProducto: _lineaProductoEditando.idLineaProducto,
                                                    idReferencia: ordenProduccion.idOrdenProduccion,
                                                    cantidad: lp.cantidad,
                                                    productoFinal: ProductosFinales(
                                                      idProducto: lp.productoFinal?.idProducto,
                                                      idTela: lp.productoFinal?.idTela,
                                                      idLustre: lp.productoFinal?.idLustre,
                                                      producto: lp.productoFinal?.producto,
                                                      tela: lp.productoFinal?.tela,
                                                      lustre: lp.productoFinal?.lustre
                                                    ),
                                                  );
                                                  OrdenesProduccionService(scheduler: scheduler).doMethod(OrdenesProduccionService().modificarLineaOrdenProduccion(_lp)).then(
                                                    (response){
                                                      if(response.status == RequestStatus.SUCCESS){
                                                        setState(() {
                                                          _changed = true;
                                                          _lineasProducto.add(
                                                            LineasProducto().fromMap(response.message)
                                                          );
                                                          showLineasForm = false;
                                                        });
                                                      }else{
                                                        if(widget.onError != null){
                                                          widget.onError(response.message);
                                                        }
                                                      }
                                                    }
                                                  );
                                                }
                                              }else{
                                                bool success = true;
                                                if(ordenProduccion == null){
                                                  //Creamos la orden de producción
                                                  OrdenesProduccion _ordenProduccion = OrdenesProduccion(idVenta: null);
                                                  await OrdenesProduccionService().crear(_ordenProduccion).then(
                                                    (response){
                                                      if(response.status == RequestStatus.SUCCESS){
                                                        OrdenesProduccion _ordenProduccionCreado = OrdenesProduccion().fromMap(response.message);
                                                        setState(() {
                                                          ordenProduccion = _ordenProduccionCreado;
                                                        });
                                                      }else{
                                                        success = false;
                                                        if(widget.onError != null){
                                                          widget.onError(response.message);
                                                        }
                                                      }
                                                    }
                                                  );
                                                }
                                                if(success){
                                                  LineasProducto _lp = LineasProducto(
                                                    idReferencia: ordenProduccion.idOrdenProduccion,
                                                    cantidad: lp.cantidad,
                                                    productoFinal: ProductosFinales(
                                                      idProducto: lp.productoFinal?.idProducto,
                                                      idTela: lp.productoFinal?.idTela,
                                                      idLustre: lp.productoFinal?.idLustre,
                                                      producto: lp.productoFinal?.producto,
                                                      tela: lp.productoFinal?.tela,
                                                      lustre: lp.productoFinal?.lustre
                                                    ),
                                                  );
                                                  List<Map<String, dynamic>> _ubicaciones = List<Map<String, dynamic>>();
                                                  stockUbicacion.forEach((idUbicacion, cantidad) {
                                                    _ubicaciones.add({"IdUbicacion": idUbicacion, "CantidadUbicacion": cantidad});
                                                  });
                                                  OrdenesProduccionService(scheduler: scheduler).doMethod(OrdenesProduccionService().crearLineaOrdenProduccion(_lp, _ubicaciones)).then(
                                                    (response){
                                                      if(response.status == RequestStatus.SUCCESS){
                                                        setState(() {
                                                          _changed = true;
                                                          _lineasProducto.add(
                                                            LineasProducto().fromMap(response.message)
                                                          );
                                                          showLineasForm = false;
                                                        });
                                                      }else{
                                                        if(widget.onError != null){
                                                          widget.onError(response.message);
                                                        }
                                                      }
                                                    }
                                                  );
                                                }
                                              }
                                            }
                                          }                                          
                                        },
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Button zone
                      Visibility(
                        visible: !showLineasForm,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ZMStdButton(
                                color: Theme.of(context).primaryColor,
                                text: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                onPressed: scheduler.isLoading() ? null : () async{
                                  if(ordenProduccion != null){
                                    if(ordenProduccion.estado == null || ordenProduccion.estado == "E"){
                                      await OrdenesProduccionService().doMethod(OrdenesProduccionService().pasarAPendiente(
                                        ordenProduccion.toMap()
                                      )).then(
                                        (response) async{
                                          if(response.status == RequestStatus.SUCCESS){
                                            await showDialog(
                                              context: context,
                                              barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return OrdenProduccionCreadaDialog(
                                                  ordenProduccion: ordenProduccion
                                                );
                                              },
                                            );
                                            if(_editing){
                                              if(ordenProduccion.estado == "E"){
                                                if(widget.updateRowCallback != null){
                                                  widget.updateRowCallback();
                                                }
                                              }
                                            }else{
                                              if(widget.updateAllCallback != null){
                                                widget.updateAllCallback();
                                              }
                                            }
                                          }
                                        }
                                      );
                                    }
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(
                                width: 15
                              ),
                              ZMTextButton(
                                color: Theme.of(context).primaryColor,
                                text: "Cancelar",
                                onPressed: () async{
                                  if(ordenProduccion != null){
                                    if(ordenProduccion.estado == null || ordenProduccion.estado == "E"){
                                      await showDialog(
                                        context: context,
                                        barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return ConfirmationAlertDialog(
                                            title: "Orden de producción",
                                            message: "¿Qué desea hacer con la orden de producción?",
                                            acceptText: "Conservar",
                                            cancelText: "Borrar",
                                            acceptColor: Theme.of(context).primaryColorLight,
                                            cancelColor: Colors.red,
                                            acceptIcon: Icon(
                                              Icons.check,
                                              color: Colors.white.withOpacity(0.7),
                                              size: 16,
                                            ),
                                            cancelIcon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.white.withOpacity(0.7),
                                              size: 16,
                                            ),
                                            onAccept: () async {
                                              if(_editing && _changed){
                                                if(widget.updateRowCallback != null){
                                                  widget.updateRowCallback();
                                                }
                                              }
                                              if(!_editing){
                                                widget.updateAllCallback();
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            onCancel: () async {
                                              await OrdenesProduccionService().borra(ordenProduccion.toMap());
                                              if(widget.updateAllCallback != null){
                                                widget.updateAllCallback();
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      );
                                    }
                                  }
                                  Navigator.of(context).pop();
                                },
                                outlineBorder: false,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
      }
    );
  }
}