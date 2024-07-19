part of 'unread_list_notifi_bloc.dart';

abstract class UnReadNotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];

  UnReadNotificationEvent();
}

class InitGetListUnReadNotificationEvent extends UnReadNotificationEvent {
  final int page;
  final bool isLoading;

  InitGetListUnReadNotificationEvent(
    this.page, {
    this.isLoading = true,
  });
  @override
  List<Object?> get props => [page];
}

class DeleteUnReadListNotificationEvent extends UnReadNotificationEvent {
  final String id;

  DeleteUnReadListNotificationEvent(
    this.id,
  );
  @override
  List<Object?> get props => [
        id,
      ];
}

class CheckNotification extends UnReadNotificationEvent {
  final bool? isLoading;
  CheckNotification({this.isLoading});
}

class ReadNotificationEvent extends UnReadNotificationEvent {
  final String id;

  ReadNotificationEvent(
    this.id,
  );
  @override
  List<Object?> get props => [
        id,
      ];
}

class ShowSelectOrUnselectAll extends UnReadNotificationEvent {
  final bool? isSelect;
  ShowSelectOrUnselectAll({this.isSelect});
  @override
  List<Object?> get props => [isSelect];
}
