part of 'login_bloc.dart';

class LoginState extends Equatable {
  final UserName email;
  final Password password;
  final NoData domain;
  final FormzStatus status;
  final String message;
  final String device_token;
  final LoginData user;

  LoginState({
    required this.email,
    required this.domain,
    required this.password,
    required this.status,
    required this.message,
    required this.user,
    required this.device_token,
  });

  LoginState copyWith({
    UserName? email,
    NoData? domain,
    Password? password,
    String? message,
    FormzStatus? status,
    LoginData? user,
  }) {
    return LoginState(
      email: email ?? this.email,
      domain: domain ?? this.domain,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
      device_token: device_token,
    );
  }

  @override
  List<Object> get props => [
        email,
        domain,
        password,
        status,
        message,
        user,
        device_token,
      ];
}
