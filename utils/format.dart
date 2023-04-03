import 'package:intl/intl.dart';

class Format {
  static String formatNumber(int number) {
    return NumberFormat.compact().format(number);
  }
}
