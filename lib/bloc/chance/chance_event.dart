part of 'chance_bloc.dart';

abstract class GetListChanceEvent extends Equatable {
  const GetListChanceEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListOrderEventChance extends GetListChanceEvent {
  final String filter;
  final int page;
  final String search;
  final bool? isLoadMore;

  InitGetListOrderEventChance(this.filter, this.page, this.search,
      {this.isLoadMore});
}
