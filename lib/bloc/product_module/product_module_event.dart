part of 'product_module_bloc.dart';

abstract class ProductModuleEvent extends Equatable {
  ProductModuleEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListProductModuleEvent extends ProductModuleEvent {
  final int? page;
  final String? querySearch;
  final String? typeProduct;
  final String? filter;
  final String? ids;

  InitGetListProductModuleEvent({
    this.page,
    this.querySearch,
    this.filter,
    this.typeProduct,
    this.ids,
  });
}
