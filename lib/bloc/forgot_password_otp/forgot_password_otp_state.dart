part of 'forgot_password_otp_bloc.dart';

abstract class ForgotPasswordOtpState extends Equatable {
  const ForgotPasswordOtpState();
  @override
  List<Object> get props => [];
}

class InitForgotOtp extends ForgotPasswordOtpState {}

class UpdateForgotOtp extends ForgotPasswordOtpState {
  const UpdateForgotOtp();
  @override
  List<Object> get props => [];
}

class LoadingForgotOtp extends ForgotPasswordOtpState {}

class ErrorForgotOtp extends ForgotPasswordOtpState {
  final String msg;

  ErrorForgotOtp(this.msg);
  @override
  List<Object> get props => [msg];
}

class ForgotPassOtpSuccess extends ForgotPasswordOtpState {
  const ForgotPassOtpSuccess();
  @override
  List<Object> get props => [];
}
