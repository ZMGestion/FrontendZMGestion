import 'package:flutter/material.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class DefaultResultEmpty extends StatelessWidget {
  /* 
    Widget utilizado como respuesta por defecto cuando una lista esta vacia.
  */
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.blockSizeVertical * 25,
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Image.asset(
              "assets/resultEmpty.png",
              fit: BoxFit.contain,
            ),
          ),
          Text(
            "No se encontraron resultados",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18
            ),
          )
        ],
      ),
    );
  }
}