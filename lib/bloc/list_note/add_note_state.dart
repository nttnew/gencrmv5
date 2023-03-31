part of 'add_note_bloc.dart';

abstract class AddNoteState extends Equatable {
  const AddNoteState();
  @override
  List<Object?> get props => [];
}

class InitAddNoteState extends AddNoteState {}

class SuccessAddNoteState extends AddNoteState {}

class LoadingAddNoteState extends AddNoteState {}

class ErrorAddNoteState extends AddNoteState {
  final String msg;

  ErrorAddNoteState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessDeleteNoteState extends AddNoteState {}

class LoadingDeleteNoteState extends AddNoteState {}

class ErrorDeleteNoteState extends AddNoteState {
  final String msg;

  ErrorDeleteNoteState(this.msg);
  @override
  List<Object> get props => [msg];
}
