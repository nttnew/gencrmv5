part of 'readed_list_notifi_bloc.dart';

abstract class ReadNotificationState extends Equatable {
  @override
  List<Object?> get props => [];

  ReadNotificationState();
}

class InitGetReadNotificationState extends ReadNotificationState {}

class UpdateReadNotificationState extends ReadNotificationState {
  final List<DataNotification> list;
  final String total;
  final int limit, page;

  UpdateReadNotificationState(
      {required this.list,
      required this.page,
      required this.total,
      required this.limit});

  @override
  List<Object> get props => [this.list, this.total, this.limit, this.page];
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
