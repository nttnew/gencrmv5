part of 'customer_contract_bloc.dart';

abstract class CustomerContractEvent extends Equatable {
  const CustomerContractEvent();
  @override
  List<Object?> get props => [];
}


class InitGetContractCustomerEvent extends CustomerContractEvent {
  final String page,querySearch;

  InitGetContractCustomerEvent(this.page,this.querySearch);
}

class InitGetContactCusEvent extends CustomerContractEvent {
  final String id;

  InitGetContactCusEvent(this.id);
}
