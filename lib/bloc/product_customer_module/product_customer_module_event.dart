part of 'product_customer_module_bloc.dart';

abstract class ProductCustomerModuleEvent extends Equatable {
  ProductCustomerModuleEvent();
  @override
  List<Object?> get props => [];
}

class GetProductCustomerModuleEvent extends ProductCustomerModuleEvent {
  final int? page;
  final String? querySearch;
  final String? filter;
  final String? ids;

  GetProductCustomerModuleEvent({
    this.page,
    this.querySearch,
    this.filter,
    this.ids,
  });
}
