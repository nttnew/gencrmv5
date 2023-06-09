part of 'chance_bloc.dart';

abstract class GetListChanceEvent extends Equatable {
  const GetListChanceEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListOrderEventChance extends GetListChanceEvent {
  final String? filter;
  final int? page;
  final String? search;
  final String? ids;
  final bool? isLoadMore;

  InitGetListOrderEventChance({
    this.isLoadMore,
    this.filter,
    this.page,
    this.search,
    this.ids,
  });
}
