import 'package:flutter/material.dart';

class DefaultResultEmpty extends StatelessWidget {
  /* 
    Widget utilizado como respuesta por defecto cuando una lista esta vacia.
  */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/resultEmpty.png",
        ),
        Text(
          "No se encontraron resultados",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18
          ),
        )
      ],
    );
  }
}