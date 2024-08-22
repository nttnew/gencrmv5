part of 'information_account_bloc.dart';

abstract class InfoAccEvent extends Equatable {
  const InfoAccEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends InfoAccEvent {
  final String email;

  @override
  List<Object> get props => [email];

  EmailChanged(this.email);
}

class EmailUnfocused extends InfoAccEvent {}

class PhoneChanged extends InfoAccEvent {
  final String phone;

  @override
  List<Object> get props => [phone];

  PhoneChanged(this.phone);
}

class PhoneUnfocused extends InfoAccEvent {}

class FormInfoAccNoAvatarSubmitted extends InfoAccEvent {
  final String fullName, address, phone;

  FormInfoAccNoAvatarSubmitted(this.fullName, this.address, this.phone);

  @override
  List<Object> get props => [fullName, address, phone];
}

class FormInfoAccSubmitted extends InfoAccEvent {
  final File avatar;
  final String fullName, address, phone;

  FormInfoAccSubmitted(this.avatar, this.fullName, this.address, this.phone);

  @override
  List<Object> get props => [avatar, fullName, address, phone];
}
