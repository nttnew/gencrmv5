
part of 'list_note_bloc.dart';


abstract class ListNoteState extends Equatable {
  const ListNoteState();
  @override
  List<Object?> get props => [];
}
class InitGetListNoteState extends ListNoteState {}

class SuccessGetNoteOppState extends ListNoteState{
  // final ListCustomerData listCustomer;
  final List<NoteItem> data;


  const SuccessGetNoteOppState(this.data);
  @override
  List<Object> get props => [data];
}

class LoadingGetNoteOppState extends ListNoteState {
}


class ErrorGetNoteOppState extends ListNoteState{
  final String msg;

  ErrorGetNoteOppState(this.msg);
  @override
  List<Object> get props => [msg];
}