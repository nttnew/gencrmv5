import 'package:formz/formz.dart';

enum NoDataValidationError { invalid }

class NoData extends FormzInput<String, NoDataValidationError> {
  const NoData.pure([String value = '']) : super.pure(value);
  const NoData.dirty([String value = '']) : super.dirty(value);

  @override
  NoDataValidationError? validator(String value) {
    return value.isNotEmpty && value.trim() != ''
        ? null
        : NoDataValidationError.invalid;
  }
}
