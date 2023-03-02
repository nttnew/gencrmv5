part of 'reset_password_bloc.dart';
abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();
  @override
  List<Object> get props => [];
}
class InitReset extends ResetPasswordState {}

class UpdateReset extends ResetPasswordState{

  const UpdateReset();
  @override
  List<Object> get props => [];
}

class LoadingReset extends ResetPasswordState {
}


class ErrorReset extends ResetPasswordState{
  final String msg;

  ErrorReset(this.msg);
  @override
  List<Object> get props => [msg];
}

class ResetPassSuccess extends ResetPasswordState{

  const ResetPassSuccess();
  @override
  List<Object> get props => [];
}
