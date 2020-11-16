import 'package:intl/intl.dart';
import 'package:zmgestion/src/models/Clientes.dart';

abstract class Utils{
  static cuteDateTimeText(DateTime tm){
      tm = tm.toLocal();
      DateTime today = new DateTime.now();
      Duration oneDay = new Duration(days: 1);
      Duration twoDay = new Duration(days: 2);
      Duration oneWeek = new Duration(days: 7);
      String month;
      switch (tm.month) {
        case 1:
          month = "enero"; //january
          break;
        case 2:
          month = "febrero"; //february
          break;
        case 3:
          month = "marzo"; //march
          break;
        case 4:
          month = "abril"; //april
          break;
        case 5:
          month = "mayo"; //may
          break;
        case 6:
          month = "junio"; //june
          break;
        case 7:
          month = "julio"; //july
          break;
        case 8:
          month = "agosto"; //august
          break;
        case 9:
          month = "septiembre"; //september
          break;
        case 10:
          month = "octubre"; //october
          break;
        case 11:
          month = "noviembre"; //november
          break;
        case 12:
          month = "diciembre"; //december
          break;
      }

      Duration difference = today.difference(tm);
      String withoutHour = "";
      if (difference.compareTo(oneDay) < 1) {
        withoutHour = "Hoy"; //today
      } else if (difference.compareTo(twoDay) < 1) {
        withoutHour = "Ayer"; //yesterday
      /*} else if (difference.compareTo(oneWeek) < 1) {
        switch (tm.weekday) {
          case 1:
            withoutHour = "Lunes"; //Monday
            break;
          case 2:
            withoutHour = "Martes"; //Tuesday
            break;
          case 3:
            withoutHour = "Miércoles"; //Wednesday
            break;
          case 4:
            withoutHour = "Jueves"; //Thurdsday
            break;
          case 5:
            withoutHour = "Viernes"; //Friday
            break;
          case 6:
            withoutHour = "Sábado"; //Saturday
            break;
          case 7:
            withoutHour = "Domingo"; //Sunday
            break;
        }*/
      } else if (tm.year == today.year) {
        withoutHour = '${tm.day} de $month';
      } else {
        withoutHour = '${tm.day} de $month del ${tm.year}';
      }
      var hour = tm.hour < 10 ? "0"+tm.hour.toString() : tm.hour.toString();
      var minute = tm.minute < 10 ? "0"+tm.minute.toString() : tm.minute.toString();
      return withoutHour + " " + hour + ":" + minute; //at
  }

  static String clientName(Clientes cliente){
    if(cliente != null){
      String nombre = "";
      if(cliente.nombres != null && cliente.nombres != ""){
        nombre = cliente.nombres+" "+cliente.apellidos;
      }else{
        nombre = cliente.razonSocial;
      }
      return nombre;
    }
    return "";
  }

  static String regExDate = r'^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$';
}

