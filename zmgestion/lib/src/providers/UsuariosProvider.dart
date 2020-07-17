import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Usuarios.dart';

class UsuariosProvider with ChangeNotifier{

  Usuarios _usuario;

  Usuarios get usuario{
    return _usuario;
  }

  set usuario(Usuarios usuario){
    this._usuario = usuario;
    notifyListeners();
  }

}