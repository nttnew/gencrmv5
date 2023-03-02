import 'package:formz/formz.dart';

enum OTPNumberValidationError { invalid }

class OTPNumber extends FormzInput<String, OTPNumberValidationError> {
  const OTPNumber.pure([String value = '']) : super.pure(value);
  const OTPNumber.dirty([String value = '']) : super.dirty(value);

  static final _otpRegex = RegExp(r'[0-9]{4,4}$');

  @override
  OTPNumberValidationError? validator(String value) {
    return _otpRegex.hasMatch(value) ? null : OTPNumberValidationError.invalid;
  }
}
