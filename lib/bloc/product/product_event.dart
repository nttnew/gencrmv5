part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  ProductEvent();
  @override
  List<Object?> get props => [];
}


class InitGetListProductEvent extends ProductEvent {
  String page,querySearch;

  InitGetListProductEvent(this.page,this.querySearch);
}
