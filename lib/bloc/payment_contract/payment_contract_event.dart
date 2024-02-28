part of 'payment_contract_bloc.dart';

abstract class PaymentContractEvent extends Equatable {
  @override
  List<Object?> get props => [];

  PaymentContractEvent();
}

class InitGetPaymentContractEvent extends PaymentContractEvent {
  final int id;
  final bool? isLoad;

  InitGetPaymentContractEvent(this.id,{this.isLoad,});
}
