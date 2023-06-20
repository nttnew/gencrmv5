part of 'detail_clue_bloc.dart';

abstract class GetDetailClueEvent extends Equatable {
  GetDetailClueEvent();
  @override
  List<Object?> get props => [];
}

class InitGetDetailClueEvent extends GetDetailClueEvent {
  final String? id;
  InitGetDetailClueEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitDeleteClueEvent extends GetDetailClueEvent {
  final String? id;
  InitDeleteClueEvent(this.id);
  @override
  List<Object?> get props => [id];
}
