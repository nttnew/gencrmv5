part of 'readed_list_notifi_bloc.dart';

abstract class ReadNotificationState extends Equatable {
  @override
  List<Object?> get props => [];

  ReadNotificationState();
}

class InitGetReadNotificationState extends ReadNotificationState {}

class UpdateReadNotificationState extends ReadNotificationState {
  final List<DataNotification> list;

  UpdateReadNotificationState({
    required this.list,
  });
  UpdateReadNotificationState copyWith({
    List<DataNotification>? list,
  }) {
    return UpdateReadNotificationState(
      list: list ?? this.list,
    );
  }

  @override
  List<Object> get props => [
        this.list,
      ];
}

class LoadingReadNotificationState extends ReadNotificationState {}

class DeleteReadNotificationState extends ReadNotificationState {}

class ErrorDeleteReadNotificationState extends ReadNotificationState {
  final String msg;

  ErrorDeleteReadNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorGetReadNotificationState extends ReadNotificationState {
  final String msg;

  ErrorGetReadNotificationState(this.msg);

  @override
  List<Object> get props => [msg];
}
