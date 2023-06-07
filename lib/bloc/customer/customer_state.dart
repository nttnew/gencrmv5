part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
  @override
  List<Object?> get props => [];
}

class InitGetListCustomer extends CustomerState {}

class UpdateGetListCustomerState extends CustomerState {
  final List<CustomerData> listCustomer;
  final int total;
  const UpdateGetListCustomerState(this.listCustomer, this.total);
  @override
  List<Object> get props => [listCustomer, total];
}

class LoadingListCustomerState extends CustomerState {}

class ErrorGetListCustomerState extends CustomerState {
  final String msg;

  ErrorGetListCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessAddCustomerIndividualState extends CustomerState {}

class ErrorAddCustomerIndividualState extends CustomerState {
  final String message;

  ErrorAddCustomerIndividualState(this.message);
}
