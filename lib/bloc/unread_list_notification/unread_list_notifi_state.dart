part of 'unread_list_notifi_bloc.dart';

abstract class UnReadListNotifiState extends Equatable {
  @override
  List<Object?> get props => [];

  UnReadListNotifiState();
}

class InitGetUnReadListNotifiState extends UnReadListNotifiState {}

class UpdateUnReadListNotifiState extends UnReadListNotifiState {
  List<DataNotification> list;
  String total;
  int limit, page;

  UpdateUnReadListNotifiState(
      {required this.list,
      required this.page,
      required this.total,
      required this.limit});

  @override
  List<Object> get props => [this.list, this.total, this.limit, this.page];
}

class LoadingUnReadListNotifiState extends UnReadListNotifiState {}

class DeleteUnReadListNotifiState extends UnReadListNotifiState {}

class ReadUnReadListNotifiState extends UnReadListNotifiState {}

class ErrorReadUnReadListNotifiState extends UnReadListNotifiState {
  final String msg;

  ErrorReadUnReadListNotifiState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorDeleteUnReadListNotifiState extends UnReadListNotifiState {
  final String msg;

  ErrorDeleteUnReadListNotifiState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorGetUnReadListNotifiState extends UnReadListNotifiState {
  final String msg;

  ErrorGetUnReadListNotifiState(this.msg);

  @override
  List<Object> get props => [msg];
}

class NotificationNeedRead extends UnReadListNotifiState {}
