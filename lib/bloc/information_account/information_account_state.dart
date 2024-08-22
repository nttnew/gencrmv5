part of 'information_account_bloc.dart';

class InfoAccState extends Equatable {
  const InfoAccState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    this.message = '',
  });

  final Email email;
  final FormzStatus status;
  final String message;

  InfoAccState copyWith({
    Email? email,
    FormzStatus? status,
    String? message,
  }) {
    return InfoAccState(
      email: email ?? this.email,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [email, status];
}
