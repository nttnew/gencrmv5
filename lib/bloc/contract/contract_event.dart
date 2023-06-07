part of 'contract_bloc.dart';

abstract class ContractEvent extends Equatable {
  const ContractEvent();
  @override
  List<Object?> get props => [];
}

class InitGetContractEvent extends ContractEvent {
  final String? search, filter, ids;
  final int? page;
  final bool? isLoadMore;

  InitGetContractEvent({
    this.isLoadMore,
    this.page,
    this.search,
    this.filter,
    this.ids,
  });
}
