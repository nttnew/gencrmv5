part of 'unread_list_notifi_bloc.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];

  NotificationState();
}

class InitGetNotificationState extends NotificationState {}

class UpdateNotificationState extends NotificationState {
  final List<DataNotification> list;
  final String total;
  final int limit, page;

  UpdateNotificationState(
      {required this.list,
      required this.page,
      required this.total,
      required this.limit});

  @override
  List<Object> get props => [this.list, this.total, this.limit, this.page];
}

class LoadingNotificationState extends NotificationState {}

class DeleteNotificationState extends NotificationState {}

class ReadNotificationState extends NotificationState {}

class ErrorNotificationState extends NotificationState {
  final String msg;

  ErrorNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorDeleteNotificationState extends NotificationState {
  final String msg;

  ErrorDeleteNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorGetNotificationState extends NotificationState {
  final String msg;

  ErrorGetNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}

class NotificationNeedRead extends NotificationState {}
