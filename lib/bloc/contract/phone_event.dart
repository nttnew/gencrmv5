part of 'phone_bloc.dart';

abstract class PhoneEvent extends Equatable {
  const PhoneEvent();
  @override
  List<Object?> get props => [];
}


class InitPhoneEvent extends PhoneEvent {
  final String id;

  InitPhoneEvent(this.id);
}
class InitAgencyPhoneEvent extends PhoneEvent {
  final String id;

  InitAgencyPhoneEvent(this.id);
}
