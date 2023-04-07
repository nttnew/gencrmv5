part of 'information_account_bloc.dart';

class InforAccState extends Equatable {
  const InforAccState({
    this.phone = const Phone.pure(),
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
    this.message = '',
  });

  final Phone phone;
  final Email email;
  final FormzStatus status;
  final String message;

  InforAccState copyWith({
    Phone? phone,
    Email? email,
    FormzStatus? status,
    String? message,
  }) {
    return InforAccState(
      phone: phone ?? this.phone,
      email: email ?? this.email,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [phone, email, status];
}
