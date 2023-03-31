part of 'add_customer_bloc.dart';

abstract class AddCustomerState extends Equatable {
  const AddCustomerState();
  @override
  List<Object?> get props => [];
}

class InitGetAddCustomer extends AddCustomerState {}

class UpdateGetAddCustomerState extends AddCustomerState {
  final List<AddCustomerIndividualData> listAddData;
  const UpdateGetAddCustomerState(this.listAddData);
  @override
  List<Object> get props => [listAddData];
}

class LoadingAddCustomerState extends AddCustomerState {}

class ErrorGetAddCustomerState extends AddCustomerState {
  final String msg;

  ErrorGetAddCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessGetEditCustomerState extends AddCustomerState {
  final List<AddCustomerIndividualData> listEditData;
  const SuccessGetEditCustomerState(this.listEditData);
  @override
  List<Object> get props => [listEditData];
}

class LoadingGetEditCustomerState extends AddCustomerState {}

class ErrorGetEditCustomerState extends AddCustomerState {
  final String msg;

  ErrorGetEditCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
