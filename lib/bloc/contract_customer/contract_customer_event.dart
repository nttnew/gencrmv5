part of 'contract_customer_bloc.dart';

abstract class ContractCustomerEvent extends Equatable {
  const ContractCustomerEvent();
  @override
  List<Object?> get props => [];
}


class InitGetContractCustomerEvent extends ContractCustomerEvent {
  final int id;

  InitGetContractCustomerEvent(this.id);
}
