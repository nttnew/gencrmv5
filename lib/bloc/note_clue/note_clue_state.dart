part of 'note_clue_bloc.dart';

abstract class NoteClueState extends Equatable {
  NoteClueState();

  @override
  List<Object?> get props => [];
}

class InitGetNoteClueState extends NoteClueState {}

class UpdateGetNoteClueState extends NoteClueState {
  List<NoteClueData> listNoteClue;

  UpdateGetNoteClueState(this.listNoteClue);

  @override
  List<Object> get props => [this.listNoteClue];
}

class LoadingNoteClueState extends NoteClueState {}

class ErrorGetNoteClueState extends NoteClueState {
  final String msg;

  ErrorGetNoteClueState(this.msg);
  @override
  List<Object> get props => [msg];
}
