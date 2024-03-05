part of 'detail_customer_bloc.dart';

abstract class DetailCustomerState extends Equatable {
  const DetailCustomerState();
  @override
  List<Object?> get props => [];
}

class InitGetDetailCustomer extends DetailCustomerState {}

class UpdateGetDetailCustomerState extends DetailCustomerState {
  final List<InfoDataModel> customerInfo;
  final CustomerNote customerNote;
  const UpdateGetDetailCustomerState(this.customerInfo, this.customerNote);
  @override
  List<Object> get props => [customerInfo, customerNote];
}

class LoadingDetailCustomerState extends DetailCustomerState {}

class ErrorGetDetailCustomerState extends DetailCustomerState {
  final String msg;

  ErrorGetDetailCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}

class LoadingDeleteCustomerState extends DetailCustomerState {}

class SuccessDeleteCustomerState extends DetailCustomerState {}

class ErrorDeleteCustomerState extends DetailCustomerState {
  final String msg;

  ErrorDeleteCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
