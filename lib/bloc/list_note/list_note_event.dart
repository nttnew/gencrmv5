part of 'list_note_bloc.dart';

abstract class ListNoteEvent extends Equatable {
  const ListNoteEvent();
  @override
  List<Object?> get props => [];
}

class InitNoteEvent extends ListNoteEvent {
  final String id, page, module;
  final bool isAdd;

  InitNoteEvent(
    this.id,
    this.page,
    this.module, this.isAdd,
  );
}

class ReloadEvent extends ListNoteEvent {
  ReloadEvent();
}


class RefreshEvent extends ListNoteEvent {
  RefreshEvent();
}
