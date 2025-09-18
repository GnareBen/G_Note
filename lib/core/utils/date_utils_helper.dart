import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDateTime(DateTime dateTime) {
    // On force la locale en français
    final DateFormat formatter = DateFormat("EEEE d MMMM y 'à' HH'h'mm");
    return formatter.format(dateTime);
  }
}
