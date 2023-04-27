part of 'product_module_bloc.dart';

abstract class ProductModuleEvent extends Equatable {
  ProductModuleEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListProductModuleEvent extends ProductModuleEvent {
  int? page;
  String? querySearch;
  String? typeProduct;
  String? filter;

  InitGetListProductModuleEvent({
    this.page,
    this.querySearch,
    this.filter,
    this.typeProduct,
  });
}
