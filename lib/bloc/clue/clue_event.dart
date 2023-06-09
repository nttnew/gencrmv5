part of 'clue_bloc.dart';

abstract class GetListClueEvent extends Equatable {
  GetListClueEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListClueEvent extends GetListClueEvent {
  final int? page;
  final String? search;
  final String? filter;
  final String? ids;

  InitGetListClueEvent({
    this.filter,
    this.page,
    this.search,
    this.ids,
  });
}
