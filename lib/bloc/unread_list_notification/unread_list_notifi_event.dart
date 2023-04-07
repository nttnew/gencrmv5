part of 'unread_list_notifi_bloc.dart';

abstract class ListUnReadNotifiEvent extends Equatable {
  @override
  List<Object?> get props => [];

  ListUnReadNotifiEvent();
}

class InitGetListUnReadNotifiEvent extends ListUnReadNotifiEvent {
  final int page;

  InitGetListUnReadNotifiEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class DeleteUnReadListNotifiEvent extends ListUnReadNotifiEvent {
  final int id;
  final String type;

  DeleteUnReadListNotifiEvent(this.id, this.type);
  @override
  List<Object?> get props => [id, type];
}

class CheckNotification extends ListUnReadNotifiEvent {}

class ReadNotifiEvent extends ListUnReadNotifiEvent {
  final String id;
  final String type;

  ReadNotifiEvent(this.id, this.type);
  @override
  List<Object?> get props => [id, type];
}
