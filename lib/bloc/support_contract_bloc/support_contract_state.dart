part of 'support_contract_bloc.dart';

abstract class SupportContractState extends Equatable {
  SupportContractState();

  @override
  List<Object?> get props => [];
}

class InitSupportContractState extends SupportContractState {}

//support
class LoadingSupportContractState extends SupportContractState {}

class SuccessSupportContractState extends SupportContractState {
  final List<SupportContractData> listSupportContract;
  SuccessSupportContractState(this.listSupportContract);
  @override
  List<Object> get props => [listSupportContract];
}

class ErrorSupportContractState extends SupportContractState {
  final String msg;

  ErrorSupportContractState(this.msg);
  @override
  List<Object> get props => [msg];
}
