import 'package:formz/formz.dart';

enum PhoneValidationError { invalid }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure([String value = '']) : super.pure(value);
  const Phone.dirty([String value = '']) : super.dirty(value);

  static final _phoneRegex = RegExp(
    r'^(?:[+0]9)?[0-9]{10}$',
  );

  @override
  PhoneValidationError? validator(String value) {
    return _phoneRegex.hasMatch(value)
        ? null
        : PhoneValidationError.invalid;
  }
}
