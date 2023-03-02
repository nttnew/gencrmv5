import 'package:formz/formz.dart';

enum CodeUserValidationError { invalid }

class CodeUser extends FormzInput<String, CodeUserValidationError> {
  const CodeUser.pure([String value = '']) : super.pure(value);
  const CodeUser.dirty([String value = '']) : super.dirty(value);

  static final _otpRegex = RegExp(r'[0-9]{6,6}$');

  @override
  CodeUserValidationError? validator(String value) {
    return _otpRegex.hasMatch(value) ? null : CodeUserValidationError.invalid;
  }
}
