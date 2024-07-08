import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

extension FormatAddressFire on String {
  bool isTextNotNull() {
    return this.trim() != '' && this != 'null' && this != '[]';
  }

  int stringToInt() {
    return int.tryParse(this.replaceAll('.', '')) ?? 0;
  }

  String _toMoney({
    required int value,
  }) {
    String result = '0';
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    try {
      result = currencyFormatter.format(value);
    } catch (e) {
      return '';
    }
    return result;
  }

  String toMoney({
    bool isNull = false,
    String symbol = 'đ',
  }) {
    String result = '0';
    if (this.trim() == '') {
      return '';
    }
    if (isNull && this.trim() == '0') {
      return '';
    }
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    try {
      result = currencyFormatter.format(double.parse(this));
    } catch (e) {
      return '';
    }
    return result + symbol;
  }

  String formatAddressActivityFire() {
    try {
      final String result = '${substring(0, 5)}...${substring(
        length - 5,
        length,
      )}';
      return result;
    } catch (e) {
      return '';
    }
  }

  String convertNameFile() {
    final document = this;

    final parts = document.split('/');

    final lastName = parts.last;

    final partsNameFile = lastName.split('.');

    if (partsNameFile[0].length > 30) {
      partsNameFile[0] = '${partsNameFile[0].substring(0, 10)}... ';
    }
    final fileName = '${partsNameFile[0]}.${partsNameFile[1]}';

    return fileName;
  }

  DateTime convertStringToDate({String formatPattern = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(formatPattern).parse(this);
    } catch (_) {
      return DateTime.now();
    }
  }

  bool isDaytime({bool isDay = false}) {
    DateFormat dateFormat =
        DateFormat(isDay ? "yyyy-MM-dd" : "yyyy-MM-dd H:mm");
    final currentHour = dateFormat.parse(this).hour;
    return currentHour >= 6 && currentHour < 18;
  }

  String htmlToString() {
    HtmlUnescape htmlUnescape = HtmlUnescape();
    String decodedString = htmlUnescape.convert(this);
    return decodedString;
  }
}
