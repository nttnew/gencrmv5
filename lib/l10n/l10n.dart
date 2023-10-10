import 'dart:ui';

class L10n {
  static const VN = 'vietnamese';
  static const EN = 'english';
  static const JA = 'japanese';
  static const KO = 'korea';
  static const ZH = 'chinese';
  static const MY = 'burmese';

  static final all = [
    const Locale('vi'),
    const Locale('ko'),
    const Locale('en'),
    const Locale('ja'),
    const Locale('my'),
    const Locale('zh'),
  ];

  static Locale getLocale(String name) {
    switch (name) {
      case VN:
        return Locale('vi');
      case KO:
        return Locale('ko');
      case EN:
        return Locale('en');
      case JA:
        return Locale('ja');
      case MY:
        return Locale('my');
      case ZH:
        return Locale('zh');
      default:
        return Locale('vi');
    }
  }
}
