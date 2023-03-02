part of 'support_customer_bloc.dart';

abstract class SupportCustomerState extends Equatable {
  const SupportCustomerState();
  @override
  List<Object?> get props => [];
}
class InitGetSupportCustomer extends SupportCustomerState {}

class UpdateGetSupportCustomerState extends SupportCustomerState{
  final List<SupportCustomerData> listSupport;
  const UpdateGetSupportCustomerState(this.listSupport);
  @override
  List<Object> get props => [listSupport];
}

class LoadingSupportCustomerState extends SupportCustomerState {
}


class ErrorGetSupportCustomerState extends SupportCustomerState{
  final String msg;

  ErrorGetSupportCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}