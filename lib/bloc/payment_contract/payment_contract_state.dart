part of 'payment_contract_bloc.dart';

abstract class PaymentContractState extends Equatable {
  PaymentContractState();

  @override
  List<Object?> get props => [];
}

class InitPaymentContractState extends PaymentContractState {}

//payment
class LoadingPaymentContractState extends PaymentContractState {}

class SuccessPaymentContractState extends PaymentContractState {
  final List<List<PaymentContractItem>?>? listPaymentContract;
  SuccessPaymentContractState(this.listPaymentContract);
  @override
  List<Object?> get props => [listPaymentContract];
}

class ErrorPaymentContractState extends PaymentContractState {
  final String msg;

  ErrorPaymentContractState(this.msg);
  @override
  List<Object> get props => [msg];
}
