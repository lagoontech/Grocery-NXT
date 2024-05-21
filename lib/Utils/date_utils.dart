import 'package:intl/intl.dart';

class DateFormatUtil{

  //
  String displayFormat({DateTime ?dateTime}){

    String formattedDate = DateFormat('MMMM d').format(dateTime!);
    return formattedDate;
  }

}
