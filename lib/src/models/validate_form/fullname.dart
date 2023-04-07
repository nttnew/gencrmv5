import 'package:formz/formz.dart';

enum FullNameValidationError { invalid }

class FullName extends FormzInput<String, FullNameValidationError> {
  const FullName.pure([String value = '']) : super.pure(value);
  const FullName.dirty([String value = '']) : super.dirty(value);

  @override
  FullNameValidationError? validator(String value) {
    return value.isNotEmpty == true ? null : FullNameValidationError.invalid;
  }
}
