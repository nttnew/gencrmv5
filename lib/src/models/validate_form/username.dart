import 'package:formz/formz.dart';

enum EmailValidationError { invalid }

class UserName extends FormzInput<String, EmailValidationError> {
  const UserName.pure([String value = '']) : super.pure(value);
  const UserName.dirty([String value = '']) : super.dirty(value);

  // static final _emailRegex = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  static final _emailRegex = RegExp(r'[A-Za-z0-9]');

  @override
  EmailValidationError? validator(String value) {
    return _emailRegex.hasMatch(value)
        ? null
        : EmailValidationError.invalid;
  }
}
