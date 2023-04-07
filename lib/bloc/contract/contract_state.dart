part of 'contract_bloc.dart';

abstract class ContractState extends Equatable {
  const ContractState();
  @override
  List<Object?> get props => [];
}

class InitGetContract extends ContractState {}

class UpdateGetContractState extends ContractState {
  final List<ContractItemData> listContract;
  final String total;
  final List<FilterData> listFilter;
  const UpdateGetContractState(this.listContract, this.total, this.listFilter);
  @override
  List<Object> get props => [listContract, total, listFilter];
}

class LoadingContractState extends ContractState {}

class ErrorGetContractState extends ContractState {
  final String msg;

  ErrorGetContractState(this.msg);
  @override
  List<Object> get props => [msg];
}
