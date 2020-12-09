import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:zmgestion/src/helpers/Utils.dart';
import 'package:zmgestion/src/models/LineasProducto.dart';
import 'package:zmgestion/src/models/OrdenesProduccion.dart';
import 'package:zmgestion/src/models/Presupuestos.dart';
import 'package:zmgestion/src/models/Productos.dart';
import 'package:zmgestion/src/models/ProductosFinales.dart';
import 'package:zmgestion/src/models/Remitos.dart';
import 'package:zmgestion/src/models/Telas.dart';

abstract class PDFManager{
  
  static pw.Widget _lineaPresupuesto(LineasProducto lp, int index){
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
                lp.productoFinal.producto.producto + 
                (lp.productoFinal.tela != null? " - "+lp.productoFinal.tela.tela : "") +
                (lp.productoFinal.lustre != null? " - "+lp.productoFinal.lustre.lustre : ""),
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
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(right: 5),
                    child: pw.Text(
                    "\$" + lp.precioUnitario?.toStringAsFixed(2)??"-",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 10
                    ),
                  )
                )
              ]
            )
          )
        ),
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(right: 5),
                    child: pw.Text(
                    "\$" + (lp.precioUnitario * lp.cantidad)?.toStringAsFixed(2)??"-",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 10
                    ),
                  )
                )
              ]
            )
          )
        ),
      ]
    );
  }

  static pw.Widget _lineaOrdenProduccion(LineasProducto lp, int index){
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
                lp.productoFinal.producto.producto + 
                (lp.productoFinal.tela != null? " - "+lp.productoFinal.tela.tela : "") +
                (lp.productoFinal.lustre != null? " - "+lp.productoFinal.lustre.lustre : ""),
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

  static double _getTotal(List<LineasProducto> lineas){
    double total = 0;
    lineas.forEach((linea) {
      total += (linea.precioUnitario * linea.cantidad);
    });
    return total;
  }

  static Future<Uint8List> generarPresupuestoPDF(PdfPageFormat format, Presupuestos presupuesto) async {
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

    final logo = PdfImage.file(pdf.document, bytes: (await rootBundle.load('ZM.png')).buffer.asUint8List());

    /*
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );
    */

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      //theme: myTheme,
      build: (pw.Context context) {
        return [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Image(
                      logo,
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
                                    presupuesto.cliente?.documento?.toString()??'',
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
                                    presupuesto.idCliente.toString(),
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
                                    DateFormat('dd-MM-yyyy HH:mm').format(presupuesto.fechaAlta),
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
                                "\$"+_getTotal(presupuesto.lineasProducto).toString(),
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
          ];
      }));

    return pdf.save();
  } 

  static pw.Widget _lineaRemito(LineasProducto lp, int index){
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
                lp.productoFinal.producto.producto + 
                (lp.productoFinal.tela != null? " - "+lp.productoFinal.tela.tela : "") +
                (lp.productoFinal.lustre != null? " - "+lp.productoFinal.lustre.lustre : ""),
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
        // pw.Expanded(
        //   flex: 2,
        //   child: pw.Container(
        //     padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        //     decoration: pw.BoxDecoration(
        //       color: PdfColor.fromHex(_color),
        //     ),
        //     child: pw.Center(
        //       child: pw.Text(
        //         lp.idUbicacion != null ? lp.ubicacion.ubicacion : " ",
        //         style: pw.TextStyle(
        //           fontSize: 10
        //         ),
        //       )
        //     )
        //   )
        // ),
      ]
    );
  }
  static Future<Uint8List> generarRemitoPDF(PdfPageFormat format, Remitos remito) async {
    String title = "";
    String clientName = "";
    String direccionEntrega = "-";
    String ubicacion = "-";

    title = "Remito" + remito.idRemito.toString();
    

    List<pw.Widget> _lineasRemito = List<pw.Widget>();
    int index = 0;
    remito.lineasProducto.forEach((lp) {
      _lineasRemito.add(
        _lineaRemito(lp, index)
      );
      index++;
    });

    if(remito.tipo == "E" ){
      if(remito.ubicacion.ubicacion != null){
        direccionEntrega = remito.ubicacion.ubicacion;
      }
    }

    if(remito.venta?.idVenta != null){
      clientName = Utils.clientName(remito.venta.cliente);
      direccionEntrega = remito.venta.domicilio.domicilio;
    }

    final pdf = pw.Document(
      title: title
    );

    final logo = PdfImage.file(pdf.document, bytes: (await rootBundle.load('ZM.png')).buffer.asUint8List());

    /*
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );
    */

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      //theme: myTheme,
      build: (pw.Context context) {
        return [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Image(
                      logo,
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
                          "REMITO",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold
                          )
                        ),
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
                        // pw.Text(
                        //   presupuesto.ubicacion.ubicacion,
                        //   style: pw.TextStyle(
                        //     fontSize: 9,
                        //     fontWeight: pw.FontWeight.bold
                        //   )
                        // ),
                        // pw.Text(
                        //   presupuesto.ubicacion.domicilio.domicilio,
                        //   style: pw.TextStyle(
                        //     fontSize: 9,
                        //     fontWeight: pw.FontWeight.bold
                        //   )
                        // ),
                        // pw.SizedBox(
                        //   height: 7
                        // ),
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
                                  "Fecha",
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
                                crossAxisAlignment: pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    DateFormat('dd-MM-yyyy HH:mm').format(remito.fechaEntrega),
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    )
                                  ),
                                  
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
            pw.Row(
              children: [
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
                                  "Nº Remito",
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
                                    remito.idRemito.toString(),
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    ),
                                  )
                                ],
                              )
                            )
                          ),
                        ]
                      ),
                      
                    ],
                  ),
                ),
                // pw.Expanded(
                //   child: pw.Column(
                //     children: [
                //       pw.Row(
                //         children: [
                //           pw.Expanded(
                //             child: pw.Container(
                //               padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                //               decoration: pw.BoxDecoration(
                //                 color: PdfColor.fromHex("f2f2f2"),
                //                 border: pw.BoxBorder(
                //                   bottom: true,
                //                   left: true,
                //                   right: true,
                //                   top: true,
                //                   width: 0.5,
                //                   color: PdfColor.fromHex("555555"),
                //                 )
                //               ),
                //               child: pw.Center(
                //                 child: pw.Text(
                //                   "Cod. Cliente",
                //                   style: pw.TextStyle(
                //                     fontSize: 11,
                //                     fontWeight: pw.FontWeight.bold
                //                   ),
                //                 )
                //               )
                //             )
                //           )
                //         ]
                //       ),
                //       pw.Row(
                //         children: [
                //           pw.Expanded(
                //             child: pw.Container(
                //               padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                //               decoration: pw.BoxDecoration(
                //                 border: pw.BoxBorder(
                //                   bottom: true,
                //                   left: true,
                //                   right: true,
                //                   top: true,
                //                   width: 0.5,
                //                   color: PdfColor.fromHex("555555"),
                //                 )
                //               ),
                //               child: pw.Column(
                //                 crossAxisAlignment: pw.CrossAxisAlignment.center,
                //                 children: [
                //                   pw.Text(
                //                     presupuesto.idCliente.toString(),
                //                     style: pw.TextStyle(
                //                       fontSize: 11
                //                     ),
                //                   )
                //                 ],
                //               )
                //             )
                //           ),
                //         ]
                //       )
                //     ],
                //   ),
                // ),
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
                                  "Tipo",
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
                                    Remitos().mapTipos()[remito.tipo],
                                    textAlign: pw.TextAlign.center,
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
                clientName == "" ? 
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
                                  "Dirección de entrega",
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
                                    direccionEntrega,
                                    textAlign: pw.TextAlign.center,
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
                ) : pw.Container(),
              ]
            ),
            clientName != "" ? 
            pw.Row(
              children: [
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
                                  "Cliente",
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
                                    clientName,
                                    style: pw.TextStyle(
                                      fontSize: 11
                                    ),
                                  )
                                ],
                              )
                            )
                          ),
                        ]
                      ),
                      
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
                                  "Dirección de entrega",
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
                                    direccionEntrega,
                                    textAlign: pw.TextAlign.center,
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
              ]
            ): pw.Container(),
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
                // pw.Expanded(
                //   flex: 2,
                //   child: pw.Container(
                //     padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                //     decoration: pw.BoxDecoration(
                //       color: PdfColor.fromHex("f2f2f2"),
                //       border: pw.BoxBorder(
                //         bottom: true,
                //         left: true,
                //         right: true,
                //         top: true,
                //         width: 0.5,
                //         color: PdfColor.fromHex("555555"),
                //       )
                //     ),
                //     child: pw.Center(
                //       child: pw.Text(
                //         "Ubicación de Salida",
                //         style: pw.TextStyle(
                //           fontSize: 10,
                //           fontWeight: pw.FontWeight.bold
                //         ),
                //       )
                //     )
                //   )
                // ),
              ]
            ),
            pw.SizedBox(
              height: 2
            ),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.max,
              children: _lineasRemito
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
              ]
            ),
          ];
      }));

    return pdf.save();
  }

  static Future<Uint8List> generarOrdenProduccionPDF(PdfPageFormat format, OrdenesProduccion ordenProduccion) async {
    String title = "";
    String clientName = "";

    title = "OrdenProduccion-"+ordenProduccion.idOrdenProduccion.toString();

    List<pw.Widget> _lineasOrdenProduccion = List<pw.Widget>();
    int index = 0;
    ordenProduccion.lineasProducto.forEach((lp) {
      _lineasOrdenProduccion.add(
        _lineaOrdenProduccion(lp, index)
      );
      index++;
    });

    final pdf = pw.Document(
      title: title
    );

    /*
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );
    */

    final logo = PdfImage.file(pdf.document, bytes: (await rootBundle.load('ZM.png')).buffer.asUint8List());

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      //theme: myTheme,
      build: (pw.Context context) {
        return [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Image(
                      logo,
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
              ]
            ),
            pw.SizedBox(
              height: 16
            ),
            //Tabla de datos orden de producción:
            pw.Row(
              children: [
                pw.Center(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(12),
                    child: pw.Text(
                      "ORDEN PRODUCCIÓN",
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
                                  "Nº Orden producción",
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
                                    ordenProduccion.idOrdenProduccion.toString(),
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
                                    DateFormat('dd-MM-yyyy HH:mm').format(ordenProduccion.fechaAlta),
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
              ]
            ),
            pw.SizedBox(
              height: 2
            ),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.max,
              children: _lineasOrdenProduccion
            ),
          ];
      }));

    return pdf.save();
  } 

  static pw.Widget _lineaStock(ProductosFinales pf, int index){
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
                pf.cantidad?.toString()??"",
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
        pw.Expanded(
          flex: 4,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                pf.producto.producto + 
                (pf.tela != null? " - "+pf.tela.tela : "") +
                (pf.lustre != null? " - "+pf.lustre.lustre : ""),
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
        /*
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                pf.precioTotal.toString(),
                style: pw.TextStyle(
                  fontSize: 10
                ),
              )
            )
          )
        ),
        */
      ]
    );
  }

  static pw.Widget _lineaPrecioProducto(Productos p, int index){
    String _color = "ffffff";
    if(index%2==1){
      _color = "f9f9f9";
    }
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 4,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                p.producto,
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
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(right: 5),
                    child: pw.Text(
                    "\$" + p.precio?.precio?.toStringAsFixed(2)??"-",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 10
                    ),
                  )
                )
              ]
            )
          )
        ),
      ]
    );
  }

  static pw.Widget _lineaPrecioTela(Telas t, int index){
    String _color = "ffffff";
    if(index%2==1){
      _color = "f9f9f9";
    }
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 4,
          child: pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex(_color),
            ),
            child: pw.Center(
              child: pw.Text(
                t.tela,
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
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(right: 5),
                    child: pw.Text(
                    "\$" + t.precio?.precio?.toStringAsFixed(2)??"-",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 10
                    ),
                  )
                )
              ]
            )
          )
        ),
      ]
    );
  }

  static Future<Uint8List> generarStock(PdfPageFormat format, List<ProductosFinales> productosFinales) async {
    String title = "";

    title = "Stock " + DateFormat('dd-MM-yyyy HH_mm').format(DateTime.now());

    List<pw.Widget> _lineasProductosFinales = List<pw.Widget>();
    int index = 0;
    productosFinales.forEach((pf) {
      print(pf.toMap());
      _lineasProductosFinales.add(
        _lineaStock(pf, index)
      );
      index++;
    });

    final pdf = pw.Document(
      title: title,
    );

    final logo = PdfImage.file(pdf.document, bytes: (await rootBundle.load('ZM.png')).buffer.asUint8List());

    /*
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );
    */

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      //theme: myTheme,
      build: (pw.Context context) {
        return [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Image(
                      logo,
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
                      ]
                    )
                  )
                ),
              ]
            ),
            pw.SizedBox(
              height: 16
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(12),
                      child: pw.Text(
                        "STOCK",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                        )
                      ),
                    )
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
                                    DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
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
                  flex: 4,
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
                /*
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
                */
              ]
            ),
            pw.SizedBox(
              height: 2
            ),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.max,
              children: _lineasProductosFinales
            ),
          ];
      }));

    return pdf.save();
  }

  static Future<Uint8List> generarListaPreciosProductos(PdfPageFormat format, List<Productos> productos) async {
    String title = "";

    title = "Lista de precios productos " + DateFormat('dd-MM-yyyy HH_mm').format(DateTime.now());

    List<pw.Widget> _lineasProductos = List<pw.Widget>();
    int index = 0;
    productos.forEach((producto) {
      _lineasProductos.add(
        _lineaPrecioProducto(producto, index)
      );
      index++;
    });

    final pdf = pw.Document(
      title: title
    );

    final logo = PdfImage.file(pdf.document, bytes: (await rootBundle.load('ZM.png')).buffer.asUint8List());

    /*
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );
    */

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      //theme: myTheme,
      build: (pw.Context context) {
        return [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Image(
                      logo,
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
                      ]
                    )
                  )
                ),
              ]
            ),
            pw.SizedBox(
              height: 16
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(12),
                      child: pw.Text(
                        "LISTA DE PRECIOS PRODUCTOS",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                        )
                      ),
                    )
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
                                    DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
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
            //Lineas de precios
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 4,
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
                        "Precio",
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
              children: _lineasProductos
            ),
          ];
      }));

    return pdf.save();
  }

  static Future<Uint8List> generarListaPreciosTelas(PdfPageFormat format, List<Telas> telas) async {
    String title = "";

    title = "Lista de precios telas " + DateFormat('dd-MM-yyyy HH_mm').format(DateTime.now());

    List<pw.Widget> _lineasTelas = List<pw.Widget>();
    int index = 0;
    telas.forEach((tela) {
      _lineasTelas.add(
        _lineaPrecioTela(tela, index)
      );
      index++;
    });

    final pdf = pw.Document(
      title: title
    );

    final logo = PdfImage.file(pdf.document, bytes: (await rootBundle.load('ZM.png')).buffer.asUint8List());

    /*
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("fonts/OpenSans-BoldItalic.ttf")),
    );
    */

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      //theme: myTheme,
      build: (pw.Context context) {
        return [
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                    child: pw.Image(
                      logo,
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
                      ]
                    )
                  )
                ),
              ]
            ),
            pw.SizedBox(
              height: 16
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Container(
                      padding: pw.EdgeInsets.all(12),
                      child: pw.Text(
                        "LISTA DE PRECIOS TELAS",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold
                        )
                      ),
                    )
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
                                    DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
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
            //Lineas de precios
            pw.Row(
              children: [
                pw.Expanded(
                  flex: 4,
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
                        "Precio",
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
              children: _lineasTelas
            ),
          ];
      }));

    return pdf.save();
  }
}