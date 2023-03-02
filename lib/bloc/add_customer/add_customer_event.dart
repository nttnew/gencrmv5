part of 'add_customer_bloc.dart';

abstract class AddCustomerEvent extends Equatable {
  const AddCustomerEvent();
  @override
  List<Object?> get props => [];
}


class InitGetAddCustomerEvent extends AddCustomerEvent {
  final int id;

  InitGetAddCustomerEvent(this.id);
}

class InitGetEditCustomerEvent extends AddCustomerEvent {
  final String id;

  InitGetEditCustomerEvent(this.id);
}
