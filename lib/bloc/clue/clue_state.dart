part of 'clue_bloc.dart';
abstract class ClueState extends Equatable {
  const ClueState();
  @override
  List<Object?> get props => [];
}
class InitGetListClue extends ClueState {}

class UpdateGetListClueState extends ClueState{
  // final ListCustomerData listCustomer;
  final List<ClueData> listClue;
  final List<FilterData> listFilter;
  final String total;
  const UpdateGetListClueState(this.listClue,this.listFilter,this.total);
  @override
  List<Object> get props => [listClue,listFilter,total];
}

class LoadingListClueState extends ClueState {
}


class ErrorGetListClueState extends ClueState{
  final String msg;

  ErrorGetListClueState(this.msg);
  @override
  List<Object> get props => [msg];
}