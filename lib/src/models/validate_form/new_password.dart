import 'package:formz/formz.dart';

enum NewPasswordValidationError {
  invalid,
}

class NewPassword extends FormzInput<String, NewPasswordValidationError> {
  final String password;

  const NewPassword.pure({this.password = ''}) : super.pure('');

  const NewPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);
  static final _passwordRegex = RegExp(r'[A-Za-z0-9]{6,15}');
  @override
  NewPasswordValidationError? validator(String value) {
    if (value.isEmpty || _passwordRegex.hasMatch(value) == false) {
      return NewPasswordValidationError.invalid;
    }
  }
}
