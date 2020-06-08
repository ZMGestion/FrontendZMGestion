import 'dart:html';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/helpers/ScreenMessage.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';

class ZMLoader extends StatefulWidget {
  static _ZMLoaderState of(BuildContext context) => context.findAncestorStateOfType<_ZMLoaderState>();
  
  final Widget child;
  final Widget login;

  const ZMLoader({Key key, this.child, this.login}) : super(key: key);

  @override
  _ZMLoaderState createState() => _ZMLoaderState();
}

class _ZMLoaderState extends State<ZMLoader> {
  Widget render;
  bool loading = true;

  void rebuild(){
    //Aqui implementar logica del token
    //se construye en base a si tiene o no token
    //se muestra widget.login o widget.child
    _checkSession();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkSession();
  }

  _checkSession() async{
    setState(() {
      loading = true;
    });
    Widget renderResponse = widget.login;
    var localStorage = window.localStorage;
    if(localStorage.containsKey('token') && localStorage.containsKey('tokenType')){
      var token = localStorage['token'];
      var tokenType = localStorage['tokenType'];
      if(token != "" && tokenType != ""){
        //Cargar perfil y ver que salga todo bien
        await UsuariosService().damePor(UsuariosService().damePorTokenConfiguration()).then(
          (response){
            if(response.status == RequestStatus.SUCCESS){
              //Setear provider con el response.message (Usuarios)
              renderResponse = widget.child;
              return;
            }else{
              ScreenMessage.push("No se ha podido cargar su perfil. Intentelo nuevamente.", MessageType.Error);
            }
          }
        );
      }
    }
    setState(() {
      loading = false;
      render = renderResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(render.toString()+loading.toString()),
      child: loading ? Loader() : render
    );
  }
}

Widget Loader(){
  return Center(
    child: CircularProgressIndicator(),
    heightFactor: 0.05,
  );
}