part of 'clue_customer_bloc.dart';

abstract class ClueCustomerState extends Equatable {
  const ClueCustomerState();
  @override
  List<Object?> get props => [];
}
class InitGetClueCustomer extends ClueCustomerState {}

class UpdateGetClueCustomerState extends ClueCustomerState{
  final List<ClueCustomerData> listClue;
  const UpdateGetClueCustomerState(this.listClue);
  @override
  List<Object> get props => [listClue];
}

class LoadingClueCustomerState extends ClueCustomerState {
}


class ErrorGetClueCustomerState extends ClueCustomerState{
  final String msg;

  ErrorGetClueCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}