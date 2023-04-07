part of 'work_bloc.dart';

abstract class WorkState extends Equatable {
  WorkState();

  @override
  List<Object?> get props => [];
}

class InitGetListWorkState extends WorkState {}

class SuccessGetListWorkState extends WorkState {
  List<WorkItemData> data_list;
  int pageCount;
  List<FilterData> data_filter;
  SuccessGetListWorkState(this.data_list, this.pageCount, this.data_filter);
  @override
  List<Object> get props => [data_list, pageCount, data_filter];
}

class LoadingListWorkState extends WorkState {}

class ErrorGetListWorkState extends WorkState {
  final String msg;

  ErrorGetListWorkState(this.msg);
  @override
  List<Object> get props => [msg];
}
