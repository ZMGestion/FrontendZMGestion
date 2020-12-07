import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/services/Services.dart';
import 'package:zmgestion/src/widgets/LoadingWidget.dart';

//T is type of Models
class ZMPointsLineChart extends StatefulWidget {
  final Services service;
  final ListMethodConfiguration listMethodConfiguration;
  //final List<charts.Series> seriesList;
  final DateTime Function(Map<String, dynamic> mapModel, int) domainFn;
  final num Function(Map<String, dynamic> mapModel, int) measureFn;
  final bool animate;

  ZMPointsLineChart({
    this.service,
    this.listMethodConfiguration,
    this.animate,
    this.domainFn,
    this.measureFn
  });

  @override
  _ZMPointsLineChartState createState() => _ZMPointsLineChartState();
}

class _ZMPointsLineChartState<T> extends State<ZMPointsLineChart> {
  bool loading = true;
  bool withError = false;
  List<Map<String, dynamic>> modelsList;

  @override
  initState(){
    
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      List<Map<String, dynamic>> _newModelsList = new List<Map<String, dynamic>>();
      await widget.service.listMethod(widget.listMethodConfiguration).then((response){
        if(response.status == RequestStatus.SUCCESS){
          response.message.forEach((model){
            _newModelsList.add(model.toMap());
          });
        }else{
          setState(() {
            withError = true;
          });
        }
      });  
      setState(() {
        loading = false;
        modelsList = _newModelsList;
      });
    });
    super.initState();
  }

  List<charts.Series<Map<String, dynamic>, DateTime>> getData() {
    return [
      new charts.Series<Map<String, dynamic>, DateTime>(
        id: 'LineChart',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: widget.domainFn,
        measureFn: widget.measureFn,
        data: modelsList
      )
    ];
  }

  final simpleCurrencyFormatter =
        new charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            new NumberFormat.compactSimpleCurrency());

  @override
  Widget build(BuildContext context) {
    if(loading){
      return LoadingWidget();
    }
    if(withError){
      return Text("Ha ocurrido un error realizando la gráfica. Intentelo nuevamente.");
    }
    return new charts.TimeSeriesChart(getData(),
        animate: widget.animate,
        // Sets up a currency formatter for the measure axis.
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickFormatterSpec: simpleCurrencyFormatter),

        /// Customizes the date tick formatter. It will print the day of month
        /// as the default format, but include the month and year if it
        /// transitions to a new month.
        ///
        /// minute, hour, day, month, and year are all provided by default and
        /// you can override them following this pattern.
        domainAxis: new charts.DateTimeAxisSpec(
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'dd/MM/yyyy HH:mm'))));
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}