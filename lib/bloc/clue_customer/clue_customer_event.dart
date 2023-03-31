part of 'clue_customer_bloc.dart';

abstract class ClueCustomerEvent extends Equatable {
  const ClueCustomerEvent();
  @override
  List<Object?> get props => [];
}

class InitGetClueCustomerEvent extends ClueCustomerEvent {
  final int id;

  InitGetClueCustomerEvent(this.id);
}
