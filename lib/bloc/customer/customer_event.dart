part of 'customer_bloc.dart';

abstract class GetListCustomerEvent extends Equatable {
  const GetListCustomerEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListOrderEvent extends GetListCustomerEvent {
  final String? filter;
  final int? page;
  final String? search;
  final String? ids;
  final bool? isLoadMore;

  InitGetListOrderEvent({
    this.page,
    this.search,
    this.filter,
    this.isLoadMore,
    this.ids,
  });
}

class AddCustomerIndividualEvent extends GetListCustomerEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddCustomerIndividualEvent(this.data, {this.files});
}
