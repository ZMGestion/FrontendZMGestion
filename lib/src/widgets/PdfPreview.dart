import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zmgestion/src/models/Clientes.dart';
import 'package:zmgestion/src/models/Domicilios.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/Lustres.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Telas.dart';
import 'package:zmgestion/src/models/Ubicaciones.dart';
import 'package:image/image.dart' as img;


class PdfIndex extends StatefulWidget {
  @override
  _PdfIndexState createState() => _PdfIndexState();
}

class _PdfIndexState extends State<PdfIndex> {
  pw.Widget _lineaPresupuesto(LineasProducto lp, int index){
    String _color = "ffffff";
    if(index%2==1){
      _color = "f9f9f9";
    }
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                lp.cantidad.toString(),
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                "assadsd",
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                lp.precioUnitario.toString(),
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                (lp.cantidad * lp.precioUnitario).toString(),
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
      ]
    );
  }

  Future<Uint8List> generarPresupuestoPDF(PdfPageFormat format, Presupuestos presupuesto) async {
    String title = "";
    String clientName = "";

    if(presupuesto.cliente.nombres != null && presupuesto.cliente.nombres != ""){
      title = "Presupuesto-"+presupuesto.cliente.nombres+"-"+presupuesto.cliente.apellidos+"-"+presupuesto.idPresupuesto.toString();
      clientName = presupuesto.cliente.nombres+" "+presupuesto.cliente.apellidos;
    }else{
      title = "Presupuesto-"+presupuesto.cliente.razonSocial+"-"+presupuesto.idPresupuesto.toString();
    }

    List<pw.Widget> _lineasPresupuesto = List<pw.Widget>();
    int index = 0;
    presupuesto.lineasProducto.forEach((lp) {
      _lineasPresupuesto.add(
        _lineaPresupuesto(lp, index)
      );
      index++;
    });

    final pdf = pw.Document(
      title: title
    );

    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      theme: myTheme,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Text(
                      "ZM",
                      style: pw.TextStyle(
                        fontSize: 40,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("cc1616")
                      )
                    )
                  )
                ),
                pw.SizedBox(
                  width: 7
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      borderRadius: 4,
                      //color: PdfColor.fromHex("fff2f2"),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Zimmerman Muebles S.R.L",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold
                          )
                        ),
                        pw.SizedBox(
                          height: 7
                        ),
                        pw.Text(
                          presupuesto.ubicacion.ubicacion,
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold
                          )
                        ),
                        pw.Text(
                          presupuesto.ubicacion.domicilio.domicilio,
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold
                          )
                        ),
                        pw.SizedBox(
                          height: 7
                        ),
                        /*
                        pw.Text(
                          DateFormat('dd/MM/yyyy - HH:mm').format(new DateTime.now()),
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold
                          )
                        )*/
                      ]
                    )
                  )
                ),
                pw.SizedBox(
                  width: 7
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("f2f2f2"),
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Center(
                                child: pw.Text(
                                  "Datos del cliente",
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold
                                  ),
                                )
                              )
                            )
                          )
                        ]
                      ),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: pw.BoxDecoration(
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    clientName,
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    ),
                                  ),
                                  pw.Text(
                                    presupuesto.cliente.documento,
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    ),
                                  )
                                ],
                              )
                            )
                          )
                        ]
                      )
                    ],
                  )
                ),
              ]
            ),
            pw.SizedBox(
              height: 16
            ),
            //Tabla de datos presupuestos:
            pw.Row(
              children: [
                pw.Center(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(12),
                    child: pw.Text(
                      "PRESUPUESTO",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold
                      )
                    ),
                  )
                ),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("f2f2f2"),
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Center(
                                child: pw.Text(
                                  "Nº Presupuesto",
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold
                                  ),
                                )
                              )
                            )
                          )
                        ]
                      ),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: pw.BoxDecoration(
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    presupuesto.idPresupuesto.toString(),
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    ),
                                  )
                                ],
                              )
                            )
                          ),
                        ]
                      )
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("f2f2f2"),
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Center(
                                child: pw.Text(
                                  "Cod. Cliente",
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold
                                  ),
                                )
                              )
                            )
                          )
                        ]
                      ),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: pw.BoxDecoration(
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    presupuesto.idPresupuesto.toString(),
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    ),
                                  )
                                ],
                              )
                            )
                          ),
                        ]
                      )
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: pw.BoxDecoration(
                                color: PdfColor.fromHex("f2f2f2"),
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Center(
                                child: pw.Text(
                                  "Fecha",
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold
                                  ),
                                )
                              )
                            )
                          )
                        ]
                      ),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: pw.BoxDecoration(
                                border: pw.BoxBorder(
                                  bottom: true,
                                  left: true,
                                  right: true,
                                  top: true,
                                  width: 0.5,
                                  color: PdfColor.fromHex("555555"),
                                )
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    DateFormat('dd-MM-yyyy HH:mm').format(new DateTime.now()),
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    )
                                  )
                                ],
                              )
                            )
                          ),
                        ]
                      )
                    ],
                  ),
                ),
              ]
            ),
            pw.SizedBox(
              height: 16
            ),
            //Lineas de presupuesto
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("f2f2f2"),
                      border: pw.BoxBorder(
                        bottom: true,
                        left: true,
                        right: true,
                        top: true,
                        width: 0.5,
                        color: PdfColor.fromHex("555555"),
                      )
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        "Cantidad",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold
                        ),
                      )
                    )
                  )
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Container(
                    padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("f2f2f2"),
                      border: pw.BoxBorder(
                        bottom: true,
                        left: true,
                        right: true,
                        top: true,
                        width: 0.5,
                        color: PdfColor.fromHex("555555"),
                      )
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        "Detalle",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold
                        ),
                      )
                    )
                  )
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("f2f2f2"),
                      border: pw.BoxBorder(
                        bottom: true,
                        left: true,
                        right: true,
                        top: true,
                        width: 0.5,
                        color: PdfColor.fromHex("555555"),
                      )
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        "Precio unitario",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold
                        ),
                      )
                    )
                  )
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex("f2f2f2"),
                      border: pw.BoxBorder(
                        bottom: true,
                        left: true,
                        right: true,
                        top: true,
                        width: 0.5,
                        color: PdfColor.fromHex("555555"),
                      )
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        "Subtotal",
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold
                        ),
                      )
                    )
                  )
                ),
              ]
            ),
            pw.SizedBox(
              height: 2
            ),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.max,
              children: _lineasPresupuesto
            ),
            pw.SizedBox(
              height: 8
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Expanded(
                  flex: 5,
                  child: pw.Container()
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.BoxBorder(
                              bottom: true,
                              width: 0.5,
                              color: PdfColor.fromHex("999999"),
                            )
                          ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                "Total",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12
                                )
                              ),
                            ]
                          ),
                        ),
                        pw.Container(
                          padding: pw.EdgeInsets.only(top: 2),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(
                                "\$27000",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 12
                                )
                              )
                            ]
                          ),
                        ),
                      ]
                    )
                  )
                ),
              ]
            ),
          ]
        );
      }));

    return pdf.save();
  }


  @override
  void initState() { 
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      await Printing.layoutPdf(onLayout: (format) => generarPresupuestoPDF(
        format, 
        Presupuestos(
          idPresupuesto: 13,
          fechaAlta: DateTime.now(),
          cliente: Clientes(
            nombres: "Juan",
            apellidos: "Manzúr",
            razonSocial: "Razon social",
            documento: "13958102"
          ),
          ubicacion: Ubicaciones(
            ubicacion: "Casa Central Tucumán",
            domicilio: Domicilios(
              domicilio: "Av. Sarmiento 1456"
            )
          ),
          lineasProducto: [
            LineasProducto(
              cantidad: 2,
              precioUnitario: 1200,
              productoFinal: ProductosFinales(
                producto: Productos(
                  producto: "Silla comedor",
                ),
                tela: Telas(
                  tela: "Bohemian"
                ),
                lustre: Lustres(
                  lustre: "Lustre1"
                ),
              )
            ),
            LineasProducto(
              cantidad: 5,
              precioUnitario: 3540,
              productoFinal: ProductosFinales(
                producto: Productos(
                  producto: "Sillón esquinero",
                ),
                tela: Telas(
                  tela: "Becker"
                ),
                lustre: Lustres(
                  lustre: "Lustre3"
                ),
              )
            ),
          ]
        )
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}