part of 'detail_work_bloc.dart';

abstract class DetailWorkState extends Equatable {
  DetailWorkState();

  @override
  List<Object?> get props => [];
}

class InitGetDetailWorkState extends DetailWorkState {}

class SuccessDetailWorkState extends DetailWorkState {
  List<DetailWorkData> data_list;
  int? location;
  SuccessDetailWorkState(this.data_list, this.location);
  @override
  List<Object> get props => [data_list, location!];
}

class LoadingDetailWorkState extends DetailWorkState {}

class ErrorGetDetailWorkState extends DetailWorkState {
  final String msg;

  ErrorGetDetailWorkState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessDeleteWorkState extends DetailWorkState {}

class LoadingDeleteWorkState extends DetailWorkState {}

class ErrorDeleteWorkState extends DetailWorkState {
  final String msg;

  ErrorDeleteWorkState(this.msg);
  @override
  List<Object> get props => [msg];
}
