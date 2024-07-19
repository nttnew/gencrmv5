part of 'unread_list_notifi_bloc.dart';

abstract class UnReadNotificationState extends Equatable {
  @override
  List<Object?> get props => [];

  UnReadNotificationState();
}

class InitGetNotificationState extends UnReadNotificationState {}

class UpdateNotificationState extends UnReadNotificationState {
  final List<DataNotification> list;

  UpdateNotificationState({required this.list});

  UpdateNotificationState copyWith({
    List<DataNotification>? list,
  }) {
    return UpdateNotificationState(
      list: list ?? this.list,
    );
  }

  @override
  List<Object> get props => [this.list];
}

class LoadingNotificationState extends UnReadNotificationState {}

class DeleteNotificationState extends UnReadNotificationState {}

class ReadNotificationState extends UnReadNotificationState {}

class ErrorNotificationState extends UnReadNotificationState {
  final String msg;

  ErrorNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorDeleteNotificationState extends UnReadNotificationState {
  final String msg;

  ErrorDeleteNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorGetNotificationState extends UnReadNotificationState {
  final String msg;

  ErrorGetNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}

class NotificationNeedRead extends UnReadNotificationState {}
