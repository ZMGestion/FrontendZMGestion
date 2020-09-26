import 'package:flutter/material.dart';
import 'package:zmgestion/src/models/Comprobantes.dart';
import 'package:zmgestion/src/router/Locator.dart';
import 'package:zmgestion/src/services/NavigationService.dart';
import 'package:zmgestion/src/services/VentasService.dart';
import 'package:zmgestion/src/views/comprobantes/CrearComprobanteAlertDialog.dart';
import 'package:zmgestion/src/widgets/AppLoader.dart';
import 'package:zmgestion/src/widgets/TableTitle.dart';
import 'package:zmgestion/src/widgets/ZMButtons/ZMStdButton.dart';
import 'package:zmgestion/src/widgets/ZMTable/ZMTable.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

class ComprobantesIndex extends StatefulWidget {
  final int idVenta;

  const ComprobantesIndex({Key key, this.idVenta = 0}) : super(key: key);

  @override
  _ComprobantesIndexState createState() => _ComprobantesIndexState();
}

class _ComprobantesIndexState extends State<ComprobantesIndex> {

  int idVenta;
  @override
  void initState() {
    idVenta = widget.idVenta;
    print(idVenta);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: BreadCrumb(
                    items: <BreadCrumbItem>[
                      BreadCrumbItem(
                        content: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "Inicio",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(0.45),
                              fontSize: 15,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                        onTap: (){
                          final NavigationService _navigationService = locator<NavigationService>();
                          _navigationService.navigateTo('/inicio');
                        }
                      ),
                      BreadCrumbItem(
                        content: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "Ventas",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(0.45),
                              fontSize: 15,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                        onTap: (){
                          final NavigationService _navigationService = locator<NavigationService>();
                          _navigationService.navigateTo('/ventas');
                        }
                      ),
                      BreadCrumbItem(
                        content: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "Comprobantes",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                        onTap: null,
                      )
                    ],
                    divider: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            AppLoader(
              builder: (scheduler){
                return ZMTable(
                  key: Key(idVenta.toString()),
                  model: Comprobantes(),
                  service: VentasService(scheduler: scheduler),
                  searchArea: TableTitle(
                    title: "Comprobantes"
                  ),
                  listMethodConfiguration: VentasService(scheduler: scheduler).buscarComprobantesConfiguration({
                    "IdVenta": idVenta
                  }),
                  paginate: false,
                  tableLabels: {
                    "Comprobantes": {
                      "NumeroComprobante": "Número"
                    },
                  },
                  cellBuilder: {
                    "Comprobantes": {
                      "Tipo": (value) {
                        return Text(
                          Comprobantes().mapTipos()[value],
                          textAlign: TextAlign.center,
                        );
                      },
                      "NumeroComprobante": (value) {
                        return Text(
                          value,
                          textAlign: TextAlign.center,
                        );
                      },
                      "Monto": (value) {
                        return Text(
                          value,
                          textAlign: TextAlign.center,
                        );
                      },
                    },
                  },
                  fixedActions: [
                    Visibility(
                      visible: idVenta != 0,
                      child: ZMStdButton(
                        color: Colors.green,
                        text: Text(
                          "Nuevo comprobante",
                          style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return CrearComprobanteAlertDialog(
                                title: "Crear Comprobante",
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                  defaultWeight: 2,
                );
              },
            )
          ],
        ),
      ),
      
    );
  }
}