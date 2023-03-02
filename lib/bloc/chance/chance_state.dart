part of 'chance_bloc.dart';

abstract class ChanceState extends Equatable {
  const ChanceState();
  @override
  List<Object?> get props => [];
}
class InitGetListChance extends ChanceState {}

class UpdateGetListChanceState extends ChanceState{
  // final ListCustomerData listCustomer;
  final List<ListChanceData> listChanceData;
  final List<FilterChance> listFilter;
  final String total;
  const UpdateGetListChanceState(this.listChanceData,this.total,this.listFilter);
  @override
  List<Object> get props => [listChanceData,listFilter,total];
}

class LoadingListChanceState extends ChanceState {
}


class ErrorGetListChanceState extends ChanceState{
  final String msg;

  ErrorGetListChanceState(this.msg);
  @override
  List<Object> get props => [msg];
}