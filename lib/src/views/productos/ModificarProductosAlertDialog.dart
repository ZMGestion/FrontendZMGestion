import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zmgestion/src/helpers/Request.dart';
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
import 'package:zmgestion/src/widgets/TextFormFieldDialog.dart';
import 'package:zmgestion/src/widgets/TopLabel.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class ModificarProductosAlertDialog extends StatefulWidget{
  final String title;
  final Productos producto;
  final Function() onSuccess;
  final Function(dynamic) onError;

  const ModificarProductosAlertDialog({
    Key key,
    this.title,
    this.producto,
    this.onSuccess,
    this.onError
  }) : super(key: key);

  @override
  _ModificarProductosAlertDialogState createState() => _ModificarProductosAlertDialogState();
}

class _ModificarProductosAlertDialogState extends State<ModificarProductosAlertDialog> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController productoController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController longitudTelaController = TextEditingController();

  String idTipoProducto;
  int idCategoriaProducto;
  int idGrupoProducto;

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
    super.initState();
    if(widget.producto != null){
      productoController.text = widget.producto.producto;
      idTipoProducto = widget.producto.idTipoProducto;
      idCategoriaProducto = widget.producto.idCategoriaProducto;
      idGrupoProducto = widget.producto.grupoProducto.idGrupoProducto;
      precioController.text = widget.producto.precio?.precio.toString();
      longitudTelaController.text = widget.producto.longitudTela?.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
              title: widget.title
            ),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextFormFieldDialog(
                                controller: productoController,
                                validator: Validator.notEmptyValidator,
                                labelText: "Producto",
                              ),
                          ),
                          SizedBox(width: 12,),
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(minWidth: 200),
                              child: DropDownModelView(
                                service: ProductosService(),
                                listMethodConfiguration:
                                    ProductosService().listarTiposProducto(),
                                parentName: "TiposProducto",
                                labelName: "Seleccione un tipo de producto",
                                displayedName: "TipoProducto",
                                valueName: "IdTipoProducto",
                                initialValue: idTipoProducto,
                                errorMessage:
                                    "Debe seleccionar un tipo de producto",
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 8)),
                                onChanged: (idSelected) {
                                  setState(() {
                                    idTipoProducto = idSelected;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(minWidth: 200),
                              child: DropDownModelView(
                                service: ProductosService(),
                                listMethodConfiguration:
                                    ProductosService().listarCategorias(),
                                parentName: "CategoriasProducto",
                                labelName: "Seleccione una categoría",
                                displayedName: "Categoria",
                                valueName: "IdCategoriaProducto",
                                errorMessage:
                                    "Debe seleccionar una categoría",
                                initialValue: idCategoriaProducto,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 8)),
                                onChanged: (idSelected) {
                                  setState(() {
                                    idCategoriaProducto = idSelected;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 12,),
                          Expanded(
                            child: AutoCompleteField(
                              labelText: "Grupo del producto",
                              service: GruposProductoService(),
                              paginate: true,
                              pageLength: 6,
                              parentName: "GruposProducto",
                              keyName: "Grupo",
                              initialValue: widget.producto?.grupoProducto?.grupo,
                              listMethodConfiguration: (searchText){
                                return GruposProductoService().buscar({
                                  "GruposProducto": {
                                    "Grupo": searchText
                                  }
                                });
                              },
                              onSelect: (mapModel){
                                if(mapModel != null){
                                  GruposProducto grupo = GruposProducto().fromMap(mapModel);
                                  setState(() {
                                    idGrupoProducto = grupo.idGrupoProducto;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextFormFieldDialog(
                                controller: precioController,
                                validator: Validator.notEmptyValidator,
                                labelText: "Precio",
                            ),
                          ),
                          SizedBox(width: 12,),
                          Expanded(
                              child: TextFormFieldDialog(
                                controller: longitudTelaController,
                                validator: (value){
                                  if(value != ""){
                                    return Validator.decimalValidator(value, 3, 2);
                                  }
                                  longitudTelaController.text = "0";
                                  return null;
                                },
                                labelText: "Longitud tela",
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Button zone
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ZMStdButton(
                            color: Theme.of(context).primaryColor,
                            text: Text(
                              "Modificar",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            onPressed: scheduler.isLoading() ? null : (){
                              if(_formKey.currentState.validate()){
                                Productos producto = Productos(
                                  idProducto: widget.producto.idProducto,
                                  producto: productoController.text,
                                  precio: Precios(
                                    precio: double.parse(precioController.text)
                                  ),
                                  idCategoriaProducto: idCategoriaProducto,
                                  idGrupoProducto: idGrupoProducto,
                                  idTipoProducto: idTipoProducto,
                                  longitudTela: double.parse(longitudTelaController.text != null ? longitudTelaController.text : 0)
                                );
                                ProductosService(scheduler: scheduler).modifica(producto.toMap()).then(
                                  (response){
                                    if(response.status == RequestStatus.SUCCESS){
                                      if(widget.onSuccess != null){
                                        widget.onSuccess();
                                      }
                                    }else{
                                      if(widget.onError != null){
                                        widget.onError(response.message);
                                      }
                                    }
                                  }
                                );
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
                      ),
                    )
                  ],
                ),
              ),
            ),
        );
      }
    );
  }
}