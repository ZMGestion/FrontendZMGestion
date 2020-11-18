import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/models/GruposProducto.dart';
import 'package:zmgestion/src/models/Precios.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/services/GruposProductoService.dart';
import 'package:zmgestion/src/services/ProductosService.dart';
import 'package:zmgestion/src/widgets/AlertDialogTitle.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/AutoCompleteField.dart';
import 'package:zmgestion/src/widgets/DropDownModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/IconButtonTableAction.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';

class ModificarPreciosGrupoProductoAlertDialog extends StatefulWidget{
  final String title;
  final GruposProducto grupoProducto;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const ModificarPreciosGrupoProductoAlertDialog({
    Key key,
    this.title,
    this.grupoProducto,
    this.onSuccess,
    this.onError
  }) : super(key: key);

  @override
  _ModificarPreciosGrupoProductoAlertDialogState createState() => _ModificarPreciosGrupoProductoAlertDialogState();
}

class _ModificarPreciosGrupoProductoAlertDialogState extends State<ModificarPreciosGrupoProductoAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  int idGrupoProducto;
  double porcentaje;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    porcentaje = 1.000;
    super.initState();
  }

  Widget incrementDecrementButton({BuildContext context, String text, Function onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            text != null ? text : "",
            style: TextStyle(
              color: Theme.of(context).primaryColor
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(6,6,6,0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            elevation: 1.5,
            scrollable: true,
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: AlertDialogTitle(
              title: widget.title
            ),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              height: SizeConfig.blockSizeVertical * 75,
              constraints: BoxConstraints(
                maxWidth: 800,
              ),
              width: SizeConfig.blockSizeHorizontal * 50,
              child: Column(
                children: [
                  Flexible(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 600
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Slider(
                                      min: 0.0,
                                      max: 3.0,
                                      divisions: 300,
                                      value: porcentaje > 3 ? 3 : porcentaje,
                                      label: (porcentaje >= 1 ?  "+"+((porcentaje-1)*100).floor().toString():"-"+((1-porcentaje)*100).floor().toString())+"%",
                                      onChanged: (value){
                                        setState(() {
                                          porcentaje = value;
                                        });
                                      },
                                    ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Card(
                                    child: Row(
                                      children: [
                                        incrementDecrementButton(
                                          context: context,
                                          text: "-5%",
                                          onPressed: porcentaje < 0.05 ? null : (){
                                            if(porcentaje >= 0.05){
                                              setState(() {
                                                porcentaje -= 0.05;
                                              });
                                            }
                                          }
                                        ),
                                        incrementDecrementButton(
                                          context: context,
                                          text: "-1%",
                                          onPressed: porcentaje < 0.01 ? null : (){
                                            if(porcentaje >= 0.01){
                                              setState(() {
                                                porcentaje -= 0.01;
                                              });
                                            }
                                          }
                                        ),
                                        incrementDecrementButton(
                                          context: context,
                                          text: "-0.1%",
                                          onPressed: porcentaje < 0.001 ? null : (){
                                            if(porcentaje >= 0.001){
                                              setState(() {
                                                porcentaje -= 0.001;
                                              });
                                            }
                                          }
                                        ),
                                        incrementDecrementButton(
                                          context: context,
                                          text: "-0.01%",
                                          onPressed: porcentaje < 0.0001 ? null : (){
                                            if(porcentaje >= 0.0001){
                                              setState(() {
                                                porcentaje -= 0.0001;
                                              });
                                            }
                                          }
                                        ),
                                        Card(
                                          color: Theme.of(context).primaryColorLight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text.rich(
                                              TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: porcentaje != 1 ? (porcentaje > 1 ?  "Aumento: ":"Descuento: ") : "Deslice para modificar el precio...",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: porcentaje != 1 ? ((porcentaje > 1 ?  ((porcentaje-1)*100).toStringAsFixed(2):((1-porcentaje)*100).toStringAsFixed(2))+"%"):"",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w800
                                                    ),
                                                  ),
                                                ],
                                                style: TextStyle(
                                                  color: Colors.white
                                                )
                                              ),
                                            ),
                                          ),
                                        ),
                                        incrementDecrementButton(
                                          context: context,
                                          text: "+0.01%",
                                          onPressed: (){
                                            setState(() {
                                              porcentaje += 0.0001;
                                            });
                                          }
                                        ),
                                        incrementDecrementButton(
                                          context: context,
                                          text: "+0.1%",
                                          onPressed: (){
                                            setState(() {
                                              porcentaje += 0.001;
                                            });
                                          }
                                        ),
                                        incrementDecrementButton(
                                          context: context,
                                          text: "+1%",
                                          onPressed: (){
                                            setState(() {
                                              porcentaje += 0.01;
                                            });
                                          }
                                        ),
                                        incrementDecrementButton(
                                          context: context,
                                          text: "+5%",
                                          onPressed: (){
                                            setState(() {
                                              porcentaje += 0.05;
                                            });
                                          }
                                        ),
                                      ],
                                    ),
                                  ),
                                  ZMTextButton(
                                    color: Theme.of(context).primaryColor,
                                    text: "Reestablecer valores",
                                    onPressed: (){
                                      setState(() {
                                        porcentaje = 1.000;
                                      });
                                    },
                                    outlineBorder: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ZMTable(
                                      model: Productos(),
                                      service: ProductosService(),
                                      tableBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                                      listMethodConfiguration: ProductosService().buscarProductos({
                                        "Productos": {
                                          "Estado": "A",
                                          "IdGrupoProducto": widget.grupoProducto.idGrupoProducto
                                        }
                                      }),
                                      pageLength: 12,
                                      paginate: true,
                                      cellBuilder: {
                                        "Productos": {
                                          "Producto": (value) {
                                            return Text(
                                              value != null ? value.toString() : "-",
                                              textAlign: TextAlign.center,
                                            );
                                          }
                                        },
                                        "Precios": {
                                          "Precio": (value) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible: porcentaje != 1,
                                                  child: Row(
                                                    children: [
                                                      Text.rich(TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: value != null ? "\$"+(value).toStringAsFixed(2) : "-",
                                                            style: TextStyle(
                                                              color: Colors.black.withOpacity(0.6),
                                                            ),
                                                          ),
                                                        ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        child: Icon(
                                                          Icons.keyboard_arrow_right,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: Text(
                                                    value != null ? "\$"+(value * porcentaje).toStringAsFixed(2) : "-",
                                                    textAlign: TextAlign.center
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                      },
                                      onEmpty: Center(
                                        child: Text(
                                          "El grupo seleccionado aún no tiene productos...",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Button zone
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ZMStdButton(
                                color: Theme.of(context).primaryColor,
                                text: Text(
                                  "Modificar precios",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                onPressed: scheduler.isLoading() ? null : (){
                                  if(_formKey.currentState.validate()){
                                    if(widget.grupoProducto?.idGrupoProducto != null){
                                      GruposProductoService().doMethod(
                                        GruposProductoService().modificarPreciosConfiguration(
                                          {
                                            "IdGrupoProducto": widget.grupoProducto.idGrupoProducto,
                                            "Porcentaje": double.parse(porcentaje.toStringAsFixed(3))
                                          }
                                        )
                                      ).then(
                                        (response){
                                          if(response.status == RequestStatus.SUCCESS){
                                            Navigator.of(context).pop();
                                          }  
                                        }
                                      );
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
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                outlineBorder: false,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        );
      }
    );
  }
}