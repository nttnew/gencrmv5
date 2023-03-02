part of 'work_bloc.dart';

abstract class WorkEvent extends Equatable{
  WorkEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListWorkEvent extends WorkEvent{
  String? pageIndex,text,filter_id;
  InitGetListWorkEvent(this.pageIndex,this.text,this.filter_id);
  @override
  List<Object?> get props => [pageIndex,text,filter_id];
}