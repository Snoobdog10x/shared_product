import 'package:intl/intl.dart';

class FormatUtility {
  static String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  static int getMillisecondsSinceEpoch() {
    return FormatUtility.getMillisecondsSinceEpoch();
  }
}
