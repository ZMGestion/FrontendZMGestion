import 'package:flutter/material.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionNew.dart';
import 'package:zmgestion/src/views/ordenesProduccion/OrdenesProduccionVenta.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/SizeConfig.dart';

class OrdenesProduccionAlertDialog extends StatefulWidget{
  final int idVenta;

  const OrdenesProduccionAlertDialog({
    Key key,
    this.idVenta,
  }) : super(key: key);

  @override
  _OrdenesProduccionAlertDialogState createState() => _OrdenesProduccionAlertDialogState();
}

class _OrdenesProduccionAlertDialogState extends State<OrdenesProduccionAlertDialog> {
  bool _desdeCero = true;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.idVenta != null){
      _desdeCero = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
      return AppLoader(
        builder: (scheduler){
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            elevation: 1.5,
            scrollable: true,
            backgroundColor: Color(0xffefebdc),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            content: Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              width: SizeConfig.blockSizeHorizontal * 40,
              constraints: BoxConstraints(
                maxWidth: 600,
                minWidth: 400
              ),
              decoration: BoxDecoration(
                color: Color(0xffefebdc),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))
              ),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: _desdeCero ? Theme.of(context).primaryColor : Colors.black.withOpacity(0.05)
                                )
                              )
                            ),
                            child: MaterialButton(
                              onPressed: (){
                                setState(() {
                                  _desdeCero = true;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _desdeCero ? Icons.fiber_new_rounded : Icons.fiber_new_outlined,
                                    color: _desdeCero ? Theme.of(context).primaryColorLight : null,
                                  ),
                                  SizedBox(
                                    width: 6
                                  ),
                                  Text(
                                    "Desde cero",
                                    style: TextStyle(
                                      color: _desdeCero ? Theme.of(context).primaryColorLight : null,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: !_desdeCero ? Theme.of(context).primaryColor : Colors.black.withOpacity(0.05)
                                )
                              )
                            ),
                            child: MaterialButton(
                              onPressed: (){
                                setState(() {
                                  _desdeCero = false;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    !_desdeCero ? Icons.account_circle : Icons.person,
                                    color: !_desdeCero ? Theme.of(context).primaryColorLight : null,
                                  ),
                                  SizedBox(
                                    width: 6
                                  ),
                                  Text(
                                    "Para venta",
                                    style: TextStyle(
                                      color: !_desdeCero ? Theme.of(context).primaryColorLight : null,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Visibility(
                        visible: _desdeCero,
                        child: OrdenesProduccionNew(
                          title: "Orden",
                        )
                      ),
                      Visibility(
                        visible: !_desdeCero,
                        child: OrdenesProduccionVenta(
                          idVenta: widget.idVenta,
                          title: "Orden",
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
        );
      }
    );
  }
}