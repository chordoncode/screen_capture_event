import 'package:intl/intl.dart';

class TimeUtils {
  static String now(String format) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat(format);
    return formatter.format(now);
  }

  static DateTime toDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  static String toFormattedString(DateTime dateTime, String format) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  static int toMillisecondsSinceEpoch(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  static int nowForMillisecondsSinceEpoch() {
    return (new DateTime.now()).millisecondsSinceEpoch;
  }
}