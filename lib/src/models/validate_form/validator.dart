class Validator {

  static final RegExp _phoneRegExp = RegExp(r'^(?:[+0]9)?[0-9]{10}$');

  static final RegExp _emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^.{6,}$',
  );

  static final RegExp _dobRegExp = RegExp(
    r'(^(((0[1-9]|1[0-9]|2[0-8])(\/|-|\.)(0[1-9]|1[012]))|((29|30|31)(\/|-|\.)(0[13578]|1[02]))|((29|30)(\/|-|\.)(0[4,6,9]|11)))(\/|-|\.)(19|[2-9][0-9])\d\d$)|(^29(\/|-|\.)02(\/|-|\.)(19|[2-9][0-9])(00|04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96)$)',
  );

  static final RegExp _numberRegExp = RegExp(
      r'^[0-9]$'
  );

  static final RegExp _otpCodeRegExp = RegExp(
    r'^.{4,}$',
  );

  static final RegExp _fullnameRegExp = RegExp(
    r'^.{1,}$',
  );

  static final RegExp _isNotEmptyRegExp = RegExp(
    r'^.{1,}$',
  );

  static bool isNotEmpty(String string) {
    return _isNotEmptyRegExp.hasMatch(string);
  }

  static isValidUsername(String username) {
    return _emailRegExp.hasMatch(username) || _phoneRegExp.hasMatch(username);
  }

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidTel(String tel) {
    return _phoneRegExp.hasMatch(tel);
  }

  static isValidNumber(String num) {
    return _numberRegExp.hasMatch(num);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidNotEmpty(String name) {
    return name.isNotEmpty;
  }

  static isValidOtp(String otpCode) {
    return _otpCodeRegExp.hasMatch(otpCode);
  }

  static isValidResendOtp(int time) {
    return time == 0;
  }

  static isValidFullname(String fullname) {
    return _fullnameRegExp.hasMatch(fullname);
  }

  static isValidDob(String dob) {
      return _dobRegExp.hasMatch(dob);
  }
}
