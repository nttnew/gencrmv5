part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class EmailForgotPasswordChanged extends ForgotPasswordEvent {
  const EmailForgotPasswordChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class EmailForgotPasswordUnfocused extends ForgotPasswordEvent {}

class UserForgotPasswordChanged extends ForgotPasswordEvent {
  const UserForgotPasswordChanged({required this.username});

  final String username;

  @override
  List<Object> get props => [username];
}

class UserForgotPasswordUnfocused extends ForgotPasswordEvent {}

class FormForgotPasswordSubmitted extends ForgotPasswordEvent {}
