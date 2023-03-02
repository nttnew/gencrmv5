part of 'forgot_password_otp_bloc.dart';
abstract class ForgotPasswordOTPEvent extends Equatable {
  const ForgotPasswordOTPEvent();

  @override
  List<Object> get props => [];
}

class OtpCodeForgotPasswordOTPChanged extends ForgotPasswordOTPEvent {
  const OtpCodeForgotPasswordOTPChanged({required this.code});

  final String code;

  @override
  List<Object> get props => [code];
}

class OtpCodeForgotPasswordOTPUnfocused extends ForgotPasswordOTPEvent {}


class EmailForgotPasswordOTPChanged extends ForgotPasswordOTPEvent {
  const EmailForgotPasswordOTPChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class EmailForgotPasswordOTPUnfocused extends ForgotPasswordOTPEvent {}

class UserNameForgotPasswordOTPChanged extends ForgotPasswordOTPEvent {
  const UserNameForgotPasswordOTPChanged({required this.username});

  final String username;

  @override
  List<Object> get props => [username];
}

class UsernameForgotPasswordOTPUnfocused extends ForgotPasswordOTPEvent {}

class FormForgotPasswordOTPSubmitted extends ForgotPasswordOTPEvent {
  final String email;
  final String username;
  final String code;
  const FormForgotPasswordOTPSubmitted({
    required this.username,
    required this.code,
    required this.email,
  });

  @override
  List<Object> get props => [email,username];

}
