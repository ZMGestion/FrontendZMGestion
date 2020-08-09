import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Paginaciones.dart';
import 'package:zmgestion/src/services/GruposProductoService.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/widgets/ModelView.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMTextButton.dart';

class AutoCompleteField extends StatefulWidget {
  final String labelText;
  final Function(Map<String, dynamic> mapModel) onSelect;
  final Services service;
  final String initialValue;
  final ListMethodConfiguration Function(String searchText) listMethodConfiguration;
  final bool paginate;
  final int pageLength;

  const AutoCompleteField({
    Key key, 
    this.labelText,
    this.onSelect,
    this.service,
    this.initialValue = "",
    this.listMethodConfiguration,
    this.paginate = false,
    this.pageLength = 4
  }) : super(key: key);

  @override
  _AutoCompleteFieldState createState() => _AutoCompleteFieldState();
}

class _AutoCompleteFieldState extends State<AutoCompleteField> {

  final FocusNode _focusNode = FocusNode();

  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  String previousSearchText = "";
  String searchText = "";
  bool _selectedFromList = false;
  TextEditingController _textController = TextEditingController();

  ListMethodConfiguration paginatedlistMethodConfiguration;
  int pagina = 1;
  int cantidadTotal = 0;
  int longitudPagina = 0;
  Paginaciones pageInfo;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);

      } else {
        this._overlayEntry.remove();
      }
    });
    
    if(widget.initialValue != ""){
      _textController.text = widget.initialValue;
      _selectedFromList = true;
    }

    _textController.addListener(() {
      setState(() {
        searchText = _textController.text;
      });
    });

    longitudPagina = widget.pageLength;

    pageInfo = Paginaciones(
        longitudPagina: widget.pageLength, cantidadTotal: 0, pagina: 1);
    if (widget.paginate) {
      _updatePage(pageInfo);
    } else {
      paginatedlistMethodConfiguration = widget.listMethodConfiguration(searchText);
    }
  }

  int _getPageLength(Paginaciones pageInfo){
    int cantidad = pageInfo.cantidadTotal ~/ pageInfo.longitudPagina;
    int resto = pageInfo.cantidadTotal % pageInfo.longitudPagina;
    if(resto > 0){
      cantidad++;
    }
    return cantidad;
  }

  _updatePage(Paginaciones pageInfo) {
    if (widget.paginate) {
      setState(() {
        paginatedlistMethodConfiguration = new ListMethodConfiguration(
            path: widget.listMethodConfiguration(searchText).path,
            payload: widget.listMethodConfiguration(searchText).payload,
            authorizationHeader:
                widget.listMethodConfiguration(searchText).authorizationHeader,
            model: widget.listMethodConfiguration(searchText).model,
            method: widget.listMethodConfiguration(searchText).method,
            scheduler: widget.listMethodConfiguration(searchText).scheduler,
            requestConfiguration:
                widget.listMethodConfiguration(searchText).requestConfiguration,
            actionsConfiguration:
                widget.listMethodConfiguration(searchText).actionsConfiguration,
            paginacion: pageInfo);
      });
    }
  }

  _updateOverlay(){
    this._overlayEntry.remove();
    this._overlayEntry = this._createOverlayEntry();
    Overlay.of(context).insert(this._overlayEntry);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 2.0),
          child: _AutoCompleteSuggestOverlay(
            key: Key(searchText),
            pageInfo: pageInfo,
            focusNode: _focusNode,
            listMethodConfiguration: widget.listMethodConfiguration(searchText),
            onSelect: (mapModel){
              setState(() {
                _selectedFromList = true;
              });
              if(widget.onSelect != null){
                widget.onSelect(mapModel);
              }
            },
            pageLength: widget.pageLength,
            paginate: widget.paginate,
            service: widget.service,
            textController: _textController,
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: TextFormField(
        focusNode: this._focusNode,
        controller: _textController,
        style: TextStyle(
          color: _selectedFromList ? Colors.green : Colors.red
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: (){
              if(_textController.text != ""){
                setState(() {
                  _textController.text = "";
                  _selectedFromList = false;
                }); 
                _updateOverlay();
              }else{
                _focusNode.unfocus();
              }
            },
          )
        ),
        onChanged: (value){
          setState(() {
            searchText = _textController.text;
            _selectedFromList = false;
          });
          _updateOverlay();
          _updatePage(pageInfo);
        },
      ),
    );
  }
}

class _AutoCompleteSuggestOverlay extends StatefulWidget {
  final TextEditingController textController;
  final Paginaciones pageInfo;
  final Function(Map<String, dynamic> mapModel) onSelect;
  final FocusNode focusNode;
  final Services service;
  final ListMethodConfiguration listMethodConfiguration;
  final bool paginate;
  final int pageLength;

  const _AutoCompleteSuggestOverlay({
    Key key, 
    this.textController,
    this.pageInfo,
    this.onSelect,
    this.focusNode, 
    this.service, 
    this.listMethodConfiguration, 
    this.paginate, 
    this.pageLength,
  }) : super(key: key);


  @override
  __AutoCompleteSuggestOverlayState createState() => __AutoCompleteSuggestOverlayState();
}

class __AutoCompleteSuggestOverlayState extends State<_AutoCompleteSuggestOverlay> {

  Paginaciones pageInfo;
  TextEditingController _textController;
  ListMethodConfiguration paginatedlistMethodConfiguration;
  FocusNode _focusNode;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    pageInfo = widget.pageInfo;
    _textController = widget.textController;
    _focusNode = widget.focusNode;
    _updatePage(pageInfo);
    super.initState();
  }

  _updatePage(Paginaciones pageInfo) {
    if (widget.paginate) {
      setState(() {
        paginatedlistMethodConfiguration = new ListMethodConfiguration(
            path: widget.listMethodConfiguration.path,
            payload: widget.listMethodConfiguration.payload,
            authorizationHeader:
                widget.listMethodConfiguration.authorizationHeader,
            model: widget.listMethodConfiguration.model,
            method: widget.listMethodConfiguration.method,
            scheduler: widget.listMethodConfiguration.scheduler,
            requestConfiguration:
                widget.listMethodConfiguration.requestConfiguration,
            actionsConfiguration:
                widget.listMethodConfiguration.actionsConfiguration,
            paginacion: pageInfo);
      });
    }
  }

  int _getPageLength(Paginaciones pageInfo){
    int cantidad = pageInfo.cantidadTotal ~/ pageInfo.longitudPagina;
    int resto = pageInfo.cantidadTotal % pageInfo.longitudPagina;
    if(resto > 0){
      cantidad++;
    }
    return cantidad;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              child: Text(
                loading ? "Cargando sugerencias" : "Sugerencias"+(pageInfo.cantidadTotal > 0 ? " ("+pageInfo.cantidadTotal.toString()+")" : ""),
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 12
                ),
              ),
            ),
          ),
          ModelView(
            key: Key(widget.pageInfo.pagina.toString()),
            service: widget.service,
            listMethodConfiguration: widget.listMethodConfiguration != null ? paginatedlistMethodConfiguration : null,
            onPageInfo: (newPageInfo) {
              if (newPageInfo != null) {
                setState(() {
                  this.pageInfo = newPageInfo;
                });
              }
            },
            isList: true,
            onComplete: (result){
              setState(() {
                loading = false;
              });
            },
            itemBuilder: (mapModel, index, itemController){
              return InkWell(
                onTap: (){
                  setState(() { 
                    _textController.text = mapModel["GruposProducto"]["Grupo"];
                    //_selectedFromList = true;
                  });
                  if(widget.onSelect != null){
                    widget.onSelect(mapModel);
                  }
                  _focusNode.unfocus();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
                  child: Text(
                    mapModel["GruposProducto"]["Grupo"],
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                ),
              );
            },
            onEmpty: (){
              return Padding(
                padding: const EdgeInsets.fromLTRB(8,8,8,16),
                child: Text(
                  "No se encontraron sugerencias",
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: 14
                  ),
                ),
              );
            },
          ),
          Visibility(
            visible: !loading && pageInfo.cantidadTotal > 0, //&& _getPageLength(pageInfo) > 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZMTextButton(
                  text: "Anterior",
                  fontSize: 12,
                  onPressed: pageInfo.pagina == 1 ? null : (){
                    pageInfo = Paginaciones(
                      pagina: pageInfo.pagina - 1,
                      longitudPagina: pageInfo.longitudPagina,
                      cantidadTotal: pageInfo.cantidadTotal
                    );
                    _updatePage(pageInfo);
                  },
                ),
                ZMTextButton(
                  text: "Siguiente",
                  fontSize: 12,
                  onPressed: pageInfo.pagina == _getPageLength(pageInfo) ? null : (){
                    pageInfo = Paginaciones(
                      pagina: pageInfo.pagina + 1,
                      longitudPagina: pageInfo.longitudPagina,
                      cantidadTotal: pageInfo.cantidadTotal
                    );
                    _updatePage(pageInfo);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}