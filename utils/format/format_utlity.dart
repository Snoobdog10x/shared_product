import 'package:intl/intl.dart';

class FormatUtility {
  static String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  static int getMillisecondsSinceEpoch() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static bool isSameWeek(DateTime date1, DateTime date2) {
    DateTime date1AddWeek =
        DateTime(date1.millisecondsSinceEpoch).add(Duration(days: 6));
    ;
    DateTime date2AddWeek =
        DateTime(date2.millisecondsSinceEpoch).add(Duration(days: 6));
        
    int weekNumber1 = date1.weekday == DateTime.sunday
        ? date1.difference(date1AddWeek).inDays ~/ 7
        : date1.weekday - 1;
    int weekNumber2 = date2.weekday == DateTime.sunday
        ? date2.difference(date2AddWeek).inDays ~/ 7
        : date2.weekday - 1;
    return weekNumber1 == weekNumber2 && date1.year == date2.year;
  }
}
