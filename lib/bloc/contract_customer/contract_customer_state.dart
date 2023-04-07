part of 'contract_customer_bloc.dart';

abstract class ContractCustomerState extends Equatable {
  const ContractCustomerState();
  @override
  List<Object?> get props => [];
}

class InitGetContractCustomer extends ContractCustomerState {}

class UpdateGetContractCustomerState extends ContractCustomerState {
  final List<ContractCustomerData> listContract;
  const UpdateGetContractCustomerState(this.listContract);
  @override
  List<Object> get props => [listContract];
}

class LoadingContractCustomerState extends ContractCustomerState {}

class ErrorGetContractCustomerState extends ContractCustomerState {
  final String msg;

  ErrorGetContractCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
