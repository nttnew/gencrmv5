part of 'detail_contract_bloc.dart';

abstract class ContractEvent extends Equatable {
  const ContractEvent();
  @override
  List<Object?> get props => [];
}

class InitGetDetailContractEvent extends ContractEvent {
  final int id;

  InitGetDetailContractEvent(this.id);
}

class InitDeleteContractEvent extends ContractEvent {
  final int id;

  InitDeleteContractEvent(this.id);
}
