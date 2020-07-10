import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Models.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/widgets/LoadingWidget.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';


class DropDownModelView extends StatefulWidget {

  final Services service;
  final ListMethodConfiguration listMethodConfiguration;
  final String parentName;
  final String labelName;
  final String valueName;
  final String displayedName;
  final bool allOption;
  final dynamic allOptionValue;
  final String allOptionText;
  final String Function(Map<String, dynamic> mapModel) displayedNameFunction;
  final Function(dynamic value) onSaved;
  final String errorMessage;
  final dynamic initialValue;
  final Function (List<Models> resultSet) onComplete;
  final Function(dynamic value) onChanged;
  final Function(dynamic value) onSelectAll;
  final bool disable;
  final InputDecoration decoration;

  const DropDownModelView({
    Key key,
    this.service,
    this.listMethodConfiguration,
    this.parentName,
    this.labelName,
    this.valueName,
    this.displayedName,
    this.allOption = false,
    this.allOptionText = "",
    this.allOptionValue,
    this.displayedNameFunction,
    this.onSaved,
    this.errorMessage,
    this.initialValue,
    this.onComplete,
    this.onChanged,
    this.onSelectAll,
    this.disable = false,
    this.decoration,


  }): super(key:key);

  @override
  _DropDownModelViewState createState() => _DropDownModelViewState();
}

class _DropDownModelViewState extends State<DropDownModelView> {

  bool loading = true;
  Object result;
  bool closed = false;
  bool hasError = false;
  dynamic _tipoSeleccionado;
  List<DropdownMenuItem> _items = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    closed = true;
  }

  String _displayedName(Map<String, dynamic> mapModel){
    if(widget.displayedName != null){
      return mapModel[widget.parentName][widget.displayedName];
    }

    if(widget.displayedNameFunction != null){
      return widget.displayedNameFunction(mapModel);
    }

    return "";
  }

  _loadItems() async{
    if(!widget.disable){
      setState(() {
        loading = true;
      });
      await widget.service.listarPor(widget.listMethodConfiguration, showLoading: false).then((response){
        if(!closed){
          if(response.status == RequestStatus.SUCCESS){
            if(widget.onComplete != null){
              widget.onComplete(response.message);
            }
            if(widget.allOption){
              _items.add(
                  DropdownMenuItem(
                    value: widget.allOptionValue,
                    child: Text(
                      widget.allOptionText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                      ),
                    ),
                  )
              );
            }
            response.message.forEach((model){
              Map<String, dynamic> mapModel = model.toMap();
              print(mapModel);
              _items.add(
                  DropdownMenuItem(
                    value: mapModel[widget.parentName][widget.valueName],
                    child: Text(
                      _displayedName(mapModel),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                      ),
                    ),
                  )
              );
            });

          }else{
            result = null;
            setState(() {
              hasError = true;
            });
          }
          setState(() {
            this.result = result;
            loading = false;
          });
        }

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.initialValue != null){
      _tipoSeleccionado = widget.initialValue;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      await _loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if(loading && !widget.disable){
      return LoadingWidget();
    }else{
      if(hasError){
        return Container(
          height: SizeConfig.blockSizeVertical * 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () async{
                    _loadItems();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.replay
                        ),
                      ),
                      Text(
                        "Reintentar",
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        );
      }else{
        return FormField(
          validator: (value){
            if(_tipoSeleccionado == null){
              return widget.errorMessage;
            }else{
              return null;
            }
          },
          builder: (FormFieldState state){
            return DropdownButtonHideUnderline(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DropdownButtonFormField(
                    items: _items,
                    onSaved: widget.onSaved,
                    onChanged: (newValue){
                      if(!widget.disable){
                        if(newValue != null){
                          state.didChange(newValue);
                          setState((){
                            _tipoSeleccionado = newValue;
                          });
                          state.validate();
                          if(widget.onChanged != null){
                            widget.onChanged(_tipoSeleccionado);
                          }
                        }
                      }
                    },
                    decoration: widget.decoration != null ? widget.decoration : InputDecoration(
                        border: InputBorder.none
                    ),
                    value: _tipoSeleccionado,
                    hint: Text(
                      widget.labelName != null ? widget.labelName : "",
                      maxLines: 2,
                    ),
                  ),
                  Visibility(
                    visible: state.hasError,
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.blockSizeVertical*1,),
                        Text(
                          state.hasError ? state.errorText : '',
                          style: TextStyle(
                            color: Theme.of(context).errorColor, fontSize: 12.0,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      }

    }
  }
}
