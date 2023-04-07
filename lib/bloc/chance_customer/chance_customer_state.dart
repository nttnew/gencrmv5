part of 'chance_customer_bloc.dart';

abstract class ChanceCustomerState extends Equatable {
  const ChanceCustomerState();
  @override
  List<Object?> get props => [];
}

class InitGetChanceCustomer extends ChanceCustomerState {}

class UpdateGetChanceCustomerState extends ChanceCustomerState {
  final List<ChanceCustomerData> listChance;
  const UpdateGetChanceCustomerState(this.listChance);
  @override
  List<Object> get props => [listChance];
}

class LoadingClueCustomerState extends ChanceCustomerState {}

class ErrorGetChanceCustomerState extends ChanceCustomerState {
  final String msg;

  ErrorGetChanceCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
