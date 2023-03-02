part of 'contact_by_customer_bloc.dart';

abstract class ContactByCustomerEvent extends Equatable {
  const ContactByCustomerEvent();
  @override
  List<Object?> get props => [];
}


class InitGetContactByCustomerrEvent extends ContactByCustomerEvent {
  final String id;

  InitGetContactByCustomerrEvent(this.id);
}

class InitGetCustomerContractEvent extends ContactByCustomerEvent {
  final String page,search;
  final Function success;

  InitGetCustomerContractEvent(this.page,this.search,this.success);
}
