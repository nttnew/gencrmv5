part of 'unread_list_notifi_bloc.dart';

abstract class ListUnReadNotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];

  ListUnReadNotificationEvent();
}

class InitGetListUnReadNotificationEvent extends ListUnReadNotificationEvent {
  final int page;
  final bool isLoading;

  InitGetListUnReadNotificationEvent(
    this.page, {
    this.isLoading = true,
  });
  @override
  List<Object?> get props => [page];
}

class DeleteUnReadListNotificationEvent extends ListUnReadNotificationEvent {
  final int id;
  final String type;

  DeleteUnReadListNotificationEvent(this.id, this.type);
  @override
  List<Object?> get props => [id, type];
}

class CheckNotification extends ListUnReadNotificationEvent {
  final bool? isLoading;
  CheckNotification({this.isLoading});
}

class ReadNotificationEvent extends ListUnReadNotificationEvent {
  final String id;
  final String type;

  ReadNotificationEvent(this.id, this.type);
  @override
  List<Object?> get props => [id, type];
}
