part of 'change_password_bloc.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState(
      {this.oldPassword = const Password.pure(),
      this.newPassword = const NewPassword.pure(),
      this.repeatPassword = const ConfirmedPassword.pure(),
      this.status = FormzStatus.pure,
      this.message = ''});

  final Password oldPassword;
  final NewPassword newPassword;
  final ConfirmedPassword repeatPassword;
  final FormzStatus status;
  final String message;

  ChangePasswordState copyWith(
      {Password? oldPassword,
      NewPassword? newPassword,
      ConfirmedPassword? repeatPassword,
      FormzStatus? status,
      String? message}) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props =>
      [oldPassword, newPassword, repeatPassword, status, message];
}
