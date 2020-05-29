import 'dart:html';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:zmgestion/src/helpers/Validator.dart';
import 'package:zmgestion/src/services/UsuariosService.dart';
import 'package:zmgestion/src/views/ZMLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondo_login.jpg"),
              fit: BoxFit.cover
            )
          )
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomCenter,
              radius: 1,
              colors: <Color>[
                Colors.transparent,
                Colors.black87
              ]
            )
          )
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
            body: Center(
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 30,
              constraints: BoxConstraints(minWidth: 350, maxWidth: 450),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(26, 26, 26, 12),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "ZM",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(26, 26, 26, 16),
                      child: Text(
                        "Bienvenidos a ZMGestion",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
                      child: Form(
                        key: _formKey,
                        child: Column(
                        children: [
                          TextFormField(
                            validator: Validator.userValidator,
                            decoration: InputDecoration(
                              labelText: "Usuario o email",
                              labelStyle: TextStyle(
                                fontSize: 16
                              ),
                              prefixIcon: Icon(
                                Icons.account_circle,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            controller: userController,
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextFormField(
                              obscureText: true,
                              validator: Validator.passValidator,
                              decoration: InputDecoration(
                                labelText: "Contraseña",
                                labelStyle: TextStyle(
                                  fontSize: 16
                                ),
                                prefixIcon: Icon(
                                  Icons.security,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              controller: passController,
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
                              ),
                              color: Colors.blue,
                              onPressed: (){
                                if(_formKey.currentState.validate()){
                                  UsuariosService().doMethod(UsuariosService(context: context).iniciarSesion(
                                    {
                                      "Usuarios": {
                                        "Usuario": userController.text,
                                        "Password": passController.text
                                      }
                                    }
                                  ));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Iniciar sesion",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              )
            ),
          ),
        ),
      ],
    );
  }
}