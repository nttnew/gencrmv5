part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class NewPasswordResetUnfocused extends ResetPasswordEvent {}

class FormResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  final String username;
  final String newPass;
  const FormResetPasswordSubmitted({
    required this.username,
    required this.newPass,
    required this.email,
  });

  @override
  List<Object> get props => [email, username];
}
