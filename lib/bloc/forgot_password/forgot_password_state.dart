part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  final Email email;
  final UserName username;
  final FormzStatus status;
  final String message;
  final String timestamp;

  ForgotPasswordState(
      {required this.email,
      required this.username,
      required this.status,
      required this.message,
      required this.timestamp});

  ForgotPasswordState copyWith(
      {Email? email,
      String? timestamp,
      String? message,
      FormzStatus? status,
        UserName? username}) {
    return ForgotPasswordState(
        email: email ?? this.email,
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        message: message ?? this.message,
        username: username ?? this.username);
  }

  @override
  List<Object> get props => [email, username, status, message, timestamp];
}
