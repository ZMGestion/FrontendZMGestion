import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/models/Ventas.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/services/OrdenesProduccionService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenProduccionCreadaDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/ConfirmationAlertDialog.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMSelectLineasProducto.dart';
import 'package:zmgestion/src/widgets/ZMTooltip.dart';

class OrdenesProduccionVenta extends StatefulWidget{
  final String title;
  final int idVenta;
  final Function() updateAllCallback;
  final Function() updateRowCallback;
  final OrdenesProduccion ordenProduccion;
  final Function(dynamic) onError;

  const OrdenesProduccionVenta({
    Key key,
    this.title,
    this.idVenta,
    this.updateAllCallback,
    this.updateRowCallback,
    this.ordenProduccion,
    this.onError
  }) : super(key: key);

  @override
  _OrdenesProduccionVentaState createState() => _OrdenesProduccionVentaState();
}

class _OrdenesProduccionVentaState extends State<OrdenesProduccionVenta> {
  final _formKey = GlobalKey<FormState>();
  
  int _idVenta;
  bool ubicacionCargada = false;
  Usuarios usuario;
  OrdenesProduccion ordenProduccion;
  bool showLineasForm = false;
  LineasProducto _lineaProductoEditando;
  bool _editing = false;
  bool _changed = false;
  bool _loading = false;

  TextEditingController _codigoVentaController = TextEditingController();

  List<LineasProducto> _lineasProducto = [];
  List<LineasProducto> _lineasProductoSeleccionadas = [];
  Map<int, int> _mapCantidades = Map<int, int>();

  @override
  void initState() {
    ordenProduccion = widget.ordenProduccion;
    if(widget.idVenta != null){
      _idVenta = widget.idVenta;
      _loading = true;
      _codigoVentaController.text = widget.idVenta.toString();
      _cargarLineasVenta();
    }
    _codigoVentaController.addListener(() {
      int _newIdVenta;
      if(_codigoVentaController.text != ""){
        _newIdVenta = int.parse(_codigoVentaController.text);
      }
      setState(() {
        _idVenta = _newIdVenta;
      });
    });
    super.initState();
  }

  _cargarLineasVenta() async{
    await VentasService().damePor(VentasService().dameConfiguration(_idVenta)).then(
      (response){
        if(response.status == RequestStatus.SUCCESS){
          Ventas _venta = Ventas().fromMap(response.message.toMap()); 
          setState(() {
            _lineasProducto = _venta.lineasProducto;
          });
        }
      }
    );
    _loading = false;
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
        builder: (scheduler) => Container(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
          /*decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
          ),*/
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      margin: EdgeInsets.only(top: 0),
                      color: Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TopLabel(
                                    labelText: "Código de venta",
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  TextFormFieldDialog(
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)
                                    ),
                                    textStyle: TextStyle(
                                      color: Colors.white
                                    ),
                                    controller: _codigoVentaController,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    hintText: "Ingrese un código de venta",
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 12,),
                            ZMTooltip(
                              message: "Aceptar",
                              theme: ZMTooltipTheme.WHITE,
                              child: ClipOval(
                                child: Material(
                                  color: _idVenta == null ? Colors.green.withOpacity(0.3) : Colors.green,
                                  child: InkWell(
                                    splashColor: Colors.blue,
                                    child: SizedBox(
                                      width: 36, 
                                      height: 36, 
                                      child: Icon(
                                        Icons.check,
                                        color: _idVenta == null ? Colors.white.withOpacity(0.8) : Colors.white,
                                      )
                                    ),
                                    onTap: _idVenta == null ? null : (){
                                      setState(() {
                                        _loading = true;
                                      });  
                                      _cargarLineasVenta();
                                    },
                                  ),
                                ),
                              )
                            ),
                            SizedBox(width: 4,),
                            ZMTooltip(
                              message: "Limpiar",
                              theme: ZMTooltipTheme.WHITE,
                              child: ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.blue,
                                    child: SizedBox(
                                      width: 36, 
                                      height: 36, 
                                      child: Icon(
                                        Icons.clear,
                                        color: _idVenta == null ? Colors.white.withOpacity(0.8) : Colors.white,
                                      )
                                    ),
                                    onTap: _idVenta == null ? null : (){
                                      _codigoVentaController.clear();
                                    },
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _loading,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Card(
                            margin: EdgeInsets.only(top: 0),
                            color: Theme.of(context).primaryColorLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: CircularProgressIndicator(),
                            )
                          ),
                        ],
                      )
                    ),
                    Visibility(
                      visible: _lineasProducto.length > 0 && !_loading,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Card(
                            margin: EdgeInsets.only(top: 0),
                            color: Theme.of(context).primaryColorLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: ZMSelectLineasProducto(
                              key: Key(_lineasProducto.map<int>((lp) => lp.idLineaProducto).toList().toString()+_lineasProducto.length.toString()),
                              selectable: (lp){
                                return lp.productoFinal.producto.idTipoProducto == "P" && lp.estado == 'P';
                              },
                              withPrice: false,
                              lineasProducto: _lineasProducto,
                              onSelect: (lineas){
                                setState(() {
                                  _lineasProductoSeleccionadas = lineas;
                                });
                              },
                              onChangeQuantity: (newMapCantidades){
                                setState(() {
                                  _mapCantidades = newMapCantidades;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
                              onPressed: scheduler.isLoading() || _lineasProductoSeleccionadas.length == 0 ? null : () async{
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
                                          title: "OrdenProduccion",
                                          message: "¿Qué desea hacer con el ordenProduccion?",
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
        ),
      );
  }
}