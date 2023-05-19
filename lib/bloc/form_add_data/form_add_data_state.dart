part of 'form_add_data_bloc.dart';

abstract class FormAddState extends Equatable {
  const FormAddState();
  @override
  List<Object?> get props => [];
}

class InitFormAddState extends FormAddState {}

class LoadingFormAddCustomerOrState extends FormAddState {}

class SuccessFormAddCustomerOrState extends FormAddState {
  final List<AddCustomerIndividualData> listAddData;
  final List<ChuKyResponse>? chuKyResponse;
  final double? soTien;
  const SuccessFormAddCustomerOrState(
    this.listAddData, {
    this.chuKyResponse,
    this.soTien,
  });
  @override
  List<Object?> get props => [listAddData, chuKyResponse, soTien];
}

class ErrorFormAddCustomerOrState extends FormAddState {
  final String msg;

  ErrorFormAddCustomerOrState(this.msg);
  @override
  List<Object> get props => [msg];
}

//form_add_contact_customer

class LoadingFormAddContactCustomerState extends FormAddState {}

class SuccessFormAddContactCustomerState extends FormAddState {
  final List<AddCustomerIndividualData> listAddData;
  const SuccessFormAddContactCustomerState(this.listAddData);
  @override
  List<Object> get props => [listAddData];
}

class ErrorFormAddContactCustomerState extends FormAddState {
  final String msg;

  ErrorFormAddContactCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}
