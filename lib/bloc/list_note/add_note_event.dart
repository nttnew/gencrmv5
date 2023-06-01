part of 'add_note_bloc.dart';

abstract class AddNoteEvent extends Equatable {
  const AddNoteEvent();
  @override
  List<Object?> get props => [];
}

class InitAddNoteEvent extends AddNoteEvent {
  final String id, content, module;

  InitAddNoteEvent(
    this.id,
    this.content,
    this.module,
  );
}

class EditNoteEvent extends AddNoteEvent {
  final String id, content, id_note, module;

  EditNoteEvent(
    this.id,
    this.content,
    this.id_note,
    this.module,
  );
}

class DeleteNoteEvent extends AddNoteEvent {
  final String id, noteId, module;

  DeleteNoteEvent(
    this.id,
    this.noteId,
    this.module,
  );
}
