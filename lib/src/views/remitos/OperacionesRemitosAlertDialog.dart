import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmgestion/main.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Response.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Remitos.dart';
import 'package:zmgestion/src/models/Usuarios.dart';
import 'package:zmgestion/src/providers/UsuariosProvider.dart';
import 'package:zmgestion/src/services/RemitosService.dart';
import 'package:zmgestion/src/services/UbicacionesService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/ConfirmationAlertDialog.dart';
import 'package:zmgestion/src/widgets/DeleteAlertDialog.dart';
import 'package:zmgestion/src/widgets/DropDownMap.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMLineaRemito.dart';
import 'package:zmgestion/src/widgets/ZMLineaProducto/ZMListLineasProducto.dart';

class OperacionesRemitosAlertDialog extends StatefulWidget{
  final String title;
  final Remitos remito;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const OperacionesRemitosAlertDialog({
    Key key,
    this.title,
    this.onSuccess,
    this.remito,
    this.onError,
  }) : super(key: key);

  @override
  _OperacionesRemitosAlertDialogState createState() => _OperacionesRemitosAlertDialogState();
}

class _OperacionesRemitosAlertDialogState extends State<OperacionesRemitosAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  
  int _idUbicacionEntrada;
  Usuarios usuario;
  Remitos remito;
  String _tipo;
  bool showLineasForm = false;
  LineasProducto _lineaProductoEditando;
  bool editingLine = false;
  String initialClient = '';
  int refreshDomicilio = 0;

  List<LineasProducto> _lineasProducto;


  @override
  void initState() {
    final UsuariosProvider _usuariosProvider = Provider.of<UsuariosProvider>(mainContext);
    usuario = _usuariosProvider.usuario;
    _lineasProducto = new List<LineasProducto>();
    if(widget.remito != null){
      remito = widget.remito;
      _tipo = remito.tipo;
      if(_tipo == "E"){
        _idUbicacionEntrada = remito.idUbicacion;
      }
      if(remito.lineasProducto != null){
        remito.lineasProducto.forEach((lineaProducto) {
          _lineasProducto.add(lineaProducto);
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0,0,0,0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            elevation: 1.5,
            scrollable: true,
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: AlertDialogTitle(
              title: widget.title, 
              titleColor: Theme.of(context).primaryColorLight.withOpacity(0.8),
            ),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Card(
                            color: Theme.of(context).primaryColorLight,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TopLabel(
                                              labelText: "Tipo",
                                              color: Color(0xffBADDFB).withOpacity(0.8),
                                            ),
                                            Container(
                                              child: DropDownMap(
                                                map: Remitos().mapTipos(),
                                                addAllOption: false,
                                                textColor: Color(0xff97D2FF).withOpacity(1),
                                                dropdownColor: Theme.of(context).primaryColor,
                                                initialValue: _tipo,
                                                hint: Text(
                                                  "Seleccione una opción",
                                                  style: TextStyle(
                                                    color: Color(0xffBADDFB).withOpacity(0.8)
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _tipo = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      (_tipo == "E") ? 
                                        Expanded(
                                          child: Container(
                                            constraints: BoxConstraints(minWidth:  (_tipo == "E") ? 200 : 0),
                                            child: DropDownModelView(
                                              service: UbicacionesService(),
                                              listMethodConfiguration: UbicacionesService().listar(),
                                              initialValue: _idUbicacionEntrada,
                                              parentName: "Ubicaciones",
                                              labelName: "Seleccione una ubicación",
                                              displayedName: "Ubicacion",
                                              valueName: "IdUbicacion",
                                              allOption: false,
                                              errorMessage: "Debe seleccionar una ubicación",
                                              textStyle: TextStyle(
                                                color: Color(0xff97D2FF).withOpacity(1),
                                              ),
                                              iconEnabledColor: Color(0xff97D2FF).withOpacity(1),
                                              dropdownColor: Theme.of(context).primaryColor,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.location_city,
                                                  color: Color(0xff87C2F5).withOpacity(0.8),  
                                                ),
                                                hintStyle: TextStyle(
                                                  color: Color(0xffBADDFB).withOpacity(0.8)
                                                ),
                                                labelStyle: TextStyle(
                                                  color: Color(0xffBADDFB).withOpacity(0.8)
                                                ),
                                              ),
                                              onChanged: (idSelected) {
                                                setState(() {
                                                  _idUbicacionEntrada = idSelected;
                                                });
                                              },
                                            )
                                          ),
                                        ) : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: Theme.of(context).primaryColorLight,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: !showLineasForm,
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: _lineasProducto != null &&_lineasProducto.length > 0,
                                              child: ZMListLineasProducto(
                                                key: Key(_lineasProducto.length.toString()),
                                                lineasProducto: _lineasProducto,
                                                withPrice: false,
                                                onEdit: (LineasProducto lp){
                                                  setState(() {
                                                    _lineaProductoEditando = lp;
                                                    _tipo = remito.tipo;
                                                    showLineasForm = true;
                                                    editingLine = true;
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
                                                          RemitosService().doMethod(RemitosService().borrarLineaRemitoConfiguration(lp.idLineaProducto)).then((response) {
                                                            if (response.status == RequestStatus.SUCCESS){
                                                              setState(() {
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
                                                ZMTextButton(
                                                  color: Theme.of(context).primaryTextTheme.headline6.color,
                                                  text: "Agregar linea",
                                                  onPressed: ((_tipo == "S") || ((_tipo == "E") && _idUbicacionEntrada != 0)) ? (){
                                                    setState(() {
                                                      showLineasForm = true;
                                                      editingLine = false;
                                                      _lineaProductoEditando = null;
                                                    });
                                                  } : null,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: showLineasForm,
                                        child: ZMLineaRemito(
                                          key: Key(_tipo),
                                          tipo: _tipo,
                                          lineaProducto: _lineaProductoEditando,
                                          onCancel: (){
                                            setState(() {
                                              showLineasForm = false;
                                              if(_lineaProductoEditando != null){
                                                _lineaProductoEditando = null;
                                              }
                                            });
                                          },
                                          onAccept: (lp) async{
                                            if(!showLineasForm){
                                              setState(() {
                                                showLineasForm = true;
                                              });
                                            }else{
                                              if(!editingLine){
                                                if(_formKey.currentState.validate()){
                                                  bool success = true;
                                                  if(remito == null){
                                                    Remitos _remito;
                                                    if(_tipo == 'E'){
                                                      _remito = new Remitos(
                                                        tipo: _tipo,
                                                        idUbicacion: _idUbicacionEntrada
                                                      );
                                                    }else{
                                                      _remito = new Remitos(tipo: _tipo);
                                                    }
                                                    await RemitosService().crear(_remito).then((response){
                                                        if(response.status == RequestStatus.SUCCESS){
                                                          setState(() {
                                                            remito = Remitos().fromMap(response.message);
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
                                                      idReferencia: remito.idRemito,
                                                      idUbicacion: (remito.tipo == "S") ? lp.idUbicacion : 0,
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
                                                    RemitosService(scheduler: scheduler).doMethod(RemitosService().crearLineaRemitoConfiguration(_lp)).then(
                                                      (response){
                                                        if(response.status == RequestStatus.SUCCESS){
                                                          setState(() {
                                                            LineasProducto _lineaRemito = LineasProducto().fromMap(response.message);
                                                            _lineasProducto.add(_lineaRemito);
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
                                              if(editingLine){
                                                LineasProducto _lp = LineasProducto(
                                                    idLineaProducto: lp.idLineaProducto,
                                                    idReferencia: remito.idRemito,
                                                    idUbicacion: (remito.tipo == "S") ? lp.idUbicacion : 0,
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
                                                RemitosService(scheduler: scheduler).doMethod(RemitosService().modificarLineaRemitoConfiguration(_lp)).then((response){
                                                  if(response.status == RequestStatus.SUCCESS){
                                                    setState(() {
                                                      _lineasProducto.remove(lp);
                                                      _lineasProducto.add(LineasProducto().fromMap(response.message));
                                                      showLineasForm = false;
                                                      editingLine = false;
                                                      _lineaProductoEditando = null;
                                                    });
                                                  }
                                                });
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
                                    if(remito != null){
                                      if(remito.estado == "E"){
                                        await RemitosService(scheduler: scheduler).doMethod(RemitosService().pasarACreado(remito.idRemito)).then((response){
                                          if(response.status == RequestStatus.SUCCESS){
                                            if(widget.onSuccess != null){
                                                widget.onSuccess();
                                            }else{
                                              Navigator.of(context).pop();
                                            }
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 15
                                ),
                                ZMTextButton(
                                  color: Theme.of(context).primaryColor,
                                  text: "Cancelar",
                                  onPressed: () async{
                                    if(remito != null){
                                      if(remito.estado == "E"){
                                        await showDialog(
                                          context: context,
                                          barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return ConfirmationAlertDialog(
                                              title: "Remito",
                                              message: "¿Qué desea hacer con el remito?",
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
                                                Navigator.of(context).pop();
                                                if(widget.onSuccess != null){
                                                  widget.onSuccess();
                                                }
                                              },
                                              onCancel: () async {
                                                await RemitosService().borra(remito.toMap());
                                                Navigator.of(context).pop();
                                                if(widget.onSuccess != null){
                                                  widget.onSuccess();
                                                }else{
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                            );
                                          },
                                        );
                                      }
                                    }else{
                                      Navigator.of(context).pop();
                                    }
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
    );
  }
}