import 'package:formz/formz.dart';

enum PositiveNumberValidationError { invalid }

class PositiveNumber extends FormzInput<int, PositiveNumberValidationError> {
  const PositiveNumber.pure([int value = 5]) : super.pure(value);
  const PositiveNumber.dirty([int value = 5]) : super.dirty(value);

  @override
  PositiveNumberValidationError? validator(int value) {
    return value > 0 ? null : PositiveNumberValidationError.invalid;
  }
}
