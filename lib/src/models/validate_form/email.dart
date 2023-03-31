import 'package:formz/formz.dart';

enum EmailUserValidationError { invalid }

class Email extends FormzInput<String, EmailUserValidationError> {
  const Email.pure([String value = '']) : super.pure(value);
  const Email.dirty([String value = '']) : super.dirty(value);

  static final _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  EmailUserValidationError? validator(String value) {
    return _emailRegex.hasMatch(value)
        ? null
        : EmailUserValidationError.invalid;
  }
}
