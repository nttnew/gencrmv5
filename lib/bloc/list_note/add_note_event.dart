part of 'add_note_bloc.dart';

abstract class AddNoteEvent extends Equatable {
  const AddNoteEvent();
  @override
  List<Object?> get props => [];
}

class InitAddNoteEvent extends AddNoteEvent {

  final String id,content;
  final int type;

  InitAddNoteEvent(this.id,this.content,this.type);
}

class InitEditNoteEvent extends AddNoteEvent {

  final String id,content,id_note;
  final int type;

  InitEditNoteEvent(this.id,this.content,this.id_note,this.type);
}

class InitDeleteNoteEvent extends AddNoteEvent {

  final String id,noteId;
  final int type;

  InitDeleteNoteEvent(this.id,this.type,this.noteId);
}