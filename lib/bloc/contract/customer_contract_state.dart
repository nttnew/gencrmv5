part of 'customer_contract_bloc.dart';

abstract class CustomerContractState extends Equatable {
  const CustomerContractState();
  @override
  List<Object?> get props => [];
}

class InitGetContractCustomer extends CustomerContractState {}

class SuccessGetContractCustomerState extends CustomerContractState {
  final List<List<dynamic>> listContractCustomer;
  const SuccessGetContractCustomerState(this.listContractCustomer);
  @override
  List<Object> get props => [listContractCustomer];
}

class LoadingContractCustomerState extends CustomerContractState {}

class ErrorGetContractCustomerState extends CustomerContractState {
  final String msg;

  ErrorGetContractCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessGetContactCustomerState extends CustomerContractState {
  final List<List<dynamic>> listContactCustomer;
  const SuccessGetContactCustomerState(this.listContactCustomer);
  @override
  List<Object> get props => [listContactCustomer];
}

class LoadingContactCustomerState extends CustomerContractState {}

class ErrorGetContactCustomerState extends CustomerContractState {
  final String msg;

  ErrorGetContactCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
