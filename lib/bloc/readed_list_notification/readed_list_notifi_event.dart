part of 'readed_list_notifi_bloc.dart';

abstract class ReadNotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];

  ReadNotificationEvent();
}

class InitGetListReadedNotifiEvent extends ReadNotificationEvent {
  final int page;

  InitGetListReadedNotifiEvent(this.page);
  @override
  List<Object?> get props => [page];
}

class DeleteReadedListNotifiEvent extends ReadNotificationEvent {
  final String id;

  DeleteReadedListNotifiEvent(
    this.id,
  );
  @override
  List<Object?> get props => [
        id,
      ];
}

class ShowSelectOrUnselectAll extends ReadNotificationEvent {
  final bool? isSelect;
  ShowSelectOrUnselectAll({this.isSelect});
  @override
  List<Object?> get props => [isSelect];
}
