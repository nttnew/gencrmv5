part of 'note_clue_bloc.dart';

abstract class GetNoteClueEvent extends Equatable {
  @override
  List<Object?> get props => [];

  GetNoteClueEvent();
}

class InitGetNoteClueEvent extends GetNoteClueEvent {
  String? id;

  InitGetNoteClueEvent(this.id);

  @override
  List<Object?> get props => [id];
}
