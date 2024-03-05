part of 'form_add_data_bloc.dart';

abstract class FormAddState extends Equatable {
  const FormAddState();
  @override
  List<Object?> get props => [];
}

class InitFormAddState extends FormAddState {}

class LoadingForm extends FormAddState {}

class SuccessForm extends FormAddState {
  final List<AddCustomerIndividualData> listAddData;
  final List<ChuKyResponse>? chuKyResponse;
  final double? soTien;
  const SuccessForm(
    this.listAddData, {
    this.chuKyResponse,
    this.soTien,
  });
  @override
  List<Object?> get props => [listAddData, chuKyResponse, soTien];
}

class ErrorForm extends FormAddState {
  final String msg;

  ErrorForm(this.msg);
  @override
  List<Object> get props => [msg];
}

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
