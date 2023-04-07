part of 'add_service_bloc.dart';

abstract class ServiceVoucherState extends Equatable {
  const ServiceVoucherState();
  @override
  List<Object?> get props => [];
}

class InitGetServiceVoucher extends ServiceVoucherState {}

class GetServiceVoucherState extends ServiceVoucherState {
  final List<AddCustomerIndividualData> listAddData;
  const GetServiceVoucherState(this.listAddData);
  @override
  List<Object> get props => [listAddData];
}

class SaveServiceVoucherState extends ServiceVoucherState {
  const SaveServiceVoucherState();
}

class LoadingServiceVoucherState extends ServiceVoucherState {}

class ErrorGetServiceVoucherState extends ServiceVoucherState {
  final String msg;

  ErrorGetServiceVoucherState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessGetEditCustomerState extends ServiceVoucherState {
  final List<AddCustomerIndividualData> listEditData;
  const SuccessGetEditCustomerState(this.listEditData);
  @override
  List<Object> get props => [listEditData];
}

class LoadingGetEditCustomerState extends ServiceVoucherState {}

class ErrorGetEditCustomerState extends ServiceVoucherState {
  final String msg;

  ErrorGetEditCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
