part of 'readed_list_notifi_bloc.dart';

abstract class ListReadedNotifiEvent extends Equatable {
  @override
  List<Object?> get props => [];

  ListReadedNotifiEvent();
}

class InitGetListReadedNotifiEvent extends ListReadedNotifiEvent {
  final int page;

  InitGetListReadedNotifiEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class DeleteReadedListNotifiEvent extends ListReadedNotifiEvent {
  final int id;
  final String type;

  DeleteReadedListNotifiEvent(this.id, this.type);
  @override
  List<Object?> get props => [id, type];
}
