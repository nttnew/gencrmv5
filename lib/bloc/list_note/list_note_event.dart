part of 'list_note_bloc.dart';

abstract class ListNoteEvent extends Equatable {
  const ListNoteEvent();
  @override
  List<Object?> get props => [];
}

class InitNoteOppEvent extends ListNoteEvent {

  final String id,page;

  InitNoteOppEvent(this.id,this.page);
}

class InitNoteCusEvent extends ListNoteEvent {

  final String id,page;

  InitNoteCusEvent(this.id,this.page);
}

class InitNoteContactEvent extends ListNoteEvent {

  final String id,page;

  InitNoteContactEvent(this.id,this.page);
}

class InitNoteContractEvent extends ListNoteEvent {

  final String id,page;

  InitNoteContractEvent(this.id,this.page);
}

class InitNoteJobEvent extends ListNoteEvent {

  final String id,page;

  InitNoteJobEvent(this.id,this.page);
}

class InitNoteSupEvent extends ListNoteEvent {

  final String id,page;

  InitNoteSupEvent(this.id,this.page);
}