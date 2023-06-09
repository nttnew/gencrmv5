part of 'work_bloc.dart';

abstract class WorkEvent extends Equatable {
  WorkEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListWorkEvent extends WorkEvent {
  final String? filter;
  final int? page;
  final String? search;
  final String? ids;

  InitGetListWorkEvent({
    this.filter,
    this.page,
    this.search,
    this.ids,
  });
}
