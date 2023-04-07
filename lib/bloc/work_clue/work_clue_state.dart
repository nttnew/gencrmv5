part of 'work_clue_bloc.dart';

abstract class WorkClueState extends Equatable {
  WorkClueState();
  @override
  List<Object?> get props => [];
}

class InitGetWorkClue extends WorkClueState {}

class UpdateWorkClue extends WorkClueState {
  final List<WorkClueData>? data;

  UpdateWorkClue(this.data);

  @override
  List<Object?> get props => [this.data];
}

class LoadingWorkClue extends WorkClueState {}

class ErrorWorkClue extends WorkClueState {
  final String? msg;

  ErrorWorkClue(this.msg);
  @override
  List<Object?> get props => [this.msg];
}
