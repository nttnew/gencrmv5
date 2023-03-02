part of 'reset_password_bloc.dart';
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

// class EmailResetChanged extends ResetPasswordEvent {
//   const EmailResetChanged({required this.email});
//
//   final String email;
//
//   @override
//   List<Object> get props => [email];
// }
//
// class EmailResetUnfocused extends ResetPasswordEvent {}
//
// class NewPasswordResetChanged extends ResetPasswordEvent {
//   const NewPasswordResetChanged({required this.newPass});
//
//   final String newPass;
//
//   @override
//   List<Object> get props => [newPass];
// }

class NewPasswordResetUnfocused extends ResetPasswordEvent {}
//
// class UserResetChanged extends ResetPasswordEvent {
//   const UserResetChanged({required this.username});
//
//   final String username;
//
//   @override
//   List<Object> get props => [username];
// }
//
// class UserResetUnfocused extends ResetPasswordEvent {}

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
  List<Object> get props => [email,username];
}
