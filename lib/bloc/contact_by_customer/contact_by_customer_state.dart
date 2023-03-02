part of 'contact_by_customer_bloc.dart';

abstract class ContactByCustomerState extends Equatable {
  const ContactByCustomerState();
  @override
  List<Object?> get props => [];
}
class InitGetContactByCustomer extends ContactByCustomerState {}

class UpdateGetContacBytCustomerState extends ContactByCustomerState{
  final List<List<dynamic>> listContactByCustomer;
  const UpdateGetContacBytCustomerState(this.listContactByCustomer);
  @override
  List<Object> get props => [listContactByCustomer];
}

class LoadingContactByCustomerState extends ContactByCustomerState {
}


class ErrorGetContactByCustomerState extends ContactByCustomerState{
  final String msg;

  ErrorGetContactByCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}