part of 'readed_list_notifi_bloc.dart';

abstract class ReadedListNotifiState extends Equatable {
  @override
  List<Object?> get props => [];

  ReadedListNotifiState();
}

class InitGetReadedListNotifiState extends ReadedListNotifiState {}

class UpdateReadedListNotifiState extends ReadedListNotifiState {
  List<DataNotification> list;
  String total;
  int limit, page;

  UpdateReadedListNotifiState(
      {required this.list,
      required this.page,
      required this.total,
      required this.limit});

  @override
  List<Object> get props => [this.list, this.total, this.limit, this.page];
}

class LoadingReadedListNotifiState extends ReadedListNotifiState {}

class DeleteReadedListNotifiState extends ReadedListNotifiState {}

class ErrorDeleteReadedListNotifiState extends ReadedListNotifiState {
  final String msg;

  ErrorDeleteReadedListNotifiState(this.msg);

  @override
  List<Object> get props => [msg];
}

class ErrorGetReadedListNotifiState extends ReadedListNotifiState {
  final String msg;

  ErrorGetReadedListNotifiState(this.msg);

  @override
  List<Object> get props => [msg];
}
