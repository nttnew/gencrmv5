part of 'support_contract_bloc.dart';

abstract class SupportContractEvent extends Equatable {
  @override
  List<Object?> get props => [];

  SupportContractEvent();
}

class InitGetSupportContractEvent extends SupportContractEvent {
  final int id;

  InitGetSupportContractEvent(this.id);
}
