part of 'phone_bloc.dart';

abstract class PhoneState extends Equatable {
  const PhoneState();
  @override
  List<Object?> get props => [];
}

class InitPhoneState extends PhoneState {}

class SuccessPhoneState extends PhoneState {
  final String phone;
  const SuccessPhoneState(this.phone);
  @override
  List<Object> get props => [phone];
}

class LoadingPhoneState extends PhoneState {}

class ErrorPhoneState extends PhoneState {
  final String msg;

  ErrorPhoneState(this.msg);
  @override
  List<Object> get props => [msg];
}
