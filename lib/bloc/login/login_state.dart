part of 'login_bloc.dart';
class LoginState extends Equatable {


  final UserName email;
  final Password password;
  final FormzStatus status;
  final String message;
  final String device_token;
  final LoginData user;

  LoginState({required this.email, required this.password, required this.status, required this.message, required this.user,required this.device_token});

  LoginState copyWith({
    UserName? email,
    Password? password,
    String? message,
    FormzStatus? status,
    LoginData? user
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
      device_token: device_token
    );
  }

  @override
  List<Object> get props => [email, password, status, message, user,device_token];
}

// class SaveUserState extends LoginState{
//   final LoginData user;
//   const SaveUserState(this.user);
//   @override
//   List<Object> get props => [user];
// }