part of 'clue_bloc.dart';

abstract class ClueState extends Equatable {
  const ClueState();
  @override
  List<Object?> get props => [];
}

class InitGetListClue extends ClueState {}

class UpdateGetListClueState extends ClueState {
  final List<ClueData> listClue;
  final String total;
  const UpdateGetListClueState(this.listClue, this.total);
  @override
  List<Object> get props => [listClue, total];
}

class LoadingListClueState extends ClueState {}

class ErrorGetListClueState extends ClueState {
  final String msg;

  ErrorGetListClueState(this.msg);
  @override
  List<Object> get props => [msg];
}
