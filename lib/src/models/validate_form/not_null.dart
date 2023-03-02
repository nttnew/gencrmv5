import 'package:formz/formz.dart';

enum NotNullValidationError { invalid }

class NotNull extends FormzInput<String, NotNullValidationError> {
  const NotNull.pure([String value = '']) : super.pure(value);
  const NotNull.dirty([String value = '']) : super.dirty(value);

  @override
  NotNullValidationError? validator(String value) {
    return value.isNotEmpty == true ? null : NotNullValidationError.invalid;
  }
}
