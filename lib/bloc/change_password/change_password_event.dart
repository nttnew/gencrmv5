part of 'change_password_bloc.dart';
abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class OldPasswordChanged extends ChangePasswordEvent {
  const OldPasswordChanged({required this.oldPassword});

  final String oldPassword;

  @override
  List<Object> get props => [oldPassword];
}

class OldPasswordUnfocused extends ChangePasswordEvent {}

class NewPasswordChanged extends ChangePasswordEvent {
  const NewPasswordChanged({required this.newPassword});

  final String newPassword;

  @override
  List<Object> get props => [newPassword];
}

class NewPasswordUnfocused extends ChangePasswordEvent {}

class RepeatPasswordChanged extends ChangePasswordEvent {
  const RepeatPasswordChanged({required this.repeatPassword});

  final String repeatPassword;

  @override
  List<Object> get props => [repeatPassword];
}

class RepeatPasswordUnfocused extends ChangePasswordEvent {

}

class FormChangePasswordSubmitted extends ChangePasswordEvent {}
