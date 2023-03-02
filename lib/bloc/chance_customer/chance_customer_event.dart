part of 'chance_customer_bloc.dart';

abstract class ChanceCustomerEvent extends Equatable {
  const ChanceCustomerEvent();
  @override
  List<Object?> get props => [];
}


class InitGetChanceCustomerEvent extends ChanceCustomerEvent {
  final int id;

  InitGetChanceCustomerEvent(this.id);
}
