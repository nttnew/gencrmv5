import 'package:intl/intl.dart';

extension IntExt on int {
  String toMoney() {
    String result = '';
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    try {
      result = currencyFormatter.format(this.toDouble()) + 'đ';
    } catch (e) {}
    return result;
  }
}
