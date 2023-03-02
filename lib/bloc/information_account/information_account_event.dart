part of 'information_account_bloc.dart';
abstract class InforAccEvent extends Equatable {
  const InforAccEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends  InforAccEvent{


  final String email;

  @override
  List<Object> get props => [email];

  EmailChanged(this.email);
}

class EmailUnfocused extends InforAccEvent {}

class PhoneChanged extends  InforAccEvent{

  final String phone;

  @override
  List<Object> get props => [phone];

  PhoneChanged(this.phone);
}

class PhoneUnfocused extends InforAccEvent {}



class FormInforAccNoAvatarSubmitted extends InforAccEvent {
  final String fullName,address;


  FormInforAccNoAvatarSubmitted(this.fullName, this.address);

  @override
  List<Object> get props => [fullName,address];

}


class FormInforAccSubmitted extends InforAccEvent {
  final File avatar;
  final String fullName,address;

  FormInforAccSubmitted(this.avatar,this.fullName,this.address);

  @override
  List<Object> get props => [avatar,fullName,address];

}

