import 'package:intl/intl.dart';

class DateTimeHandler{
  static convertDateTimeToString(DateTime dateTime){
    return DateFormat('yyyy-MM-dd HH:mm:ss a').format(dateTime);
  }
  static convertSecondsToMinutesInString(int seconds){
    if (seconds < 60) return '$seconds seconds';
    int minutes = (seconds / 60).truncate();
    return minutes.toString() + ' minutes';
  }


}