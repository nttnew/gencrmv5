part of 'customer_bloc.dart';

abstract class GetListCustomerEvent extends Equatable {
  const GetListCustomerEvent();
  @override
  List<Object?> get props => [];
}


class InitGetListOrderEvent extends GetListCustomerEvent {
  final String filter;
  final int page;
  final String search;
  final bool? isLoadMore;

  InitGetListOrderEvent(this.filter, this.page, this.search,{this.isLoadMore});
}

class AddCustomerIndividualEvent extends GetListCustomerEvent {
  final Map<String,dynamic> data;
  final File? files;

  AddCustomerIndividualEvent(this.data,{this.files});

}
