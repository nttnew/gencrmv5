part of 'support_customer_bloc.dart';

abstract class SupportCustomerEvent extends Equatable {
  const SupportCustomerEvent();
  @override
  List<Object?> get props => [];
}


class InitGetSupportCustomerEvent extends SupportCustomerEvent {
  final int id;

  InitGetSupportCustomerEvent(this.id);
}
