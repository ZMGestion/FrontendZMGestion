import 'dart:html';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  _checkSession(){
    setState(() {
      loading = true;
    });
    var localStorage = window.localStorage;
    if(localStorage.containsKey('token') && localStorage.containsKey('tokenType')){
      var token = localStorage['token'];
      var tokenType = localStorage['tokenType'];
      if(token != "" && tokenType != ""){
        //Cargar perfil y ver que salga todo bien
        setState(() {
          loading = false;
          render = widget.child;
        });
        return;
      }
    }
    setState(() {
      loading = false;
      render = widget.login;
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