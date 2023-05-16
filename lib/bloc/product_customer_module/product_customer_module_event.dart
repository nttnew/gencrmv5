part of 'product_customer_module_bloc.dart';

abstract class ProductCustomerModuleEvent extends Equatable {
  ProductCustomerModuleEvent();
  @override
  List<Object?> get props => [];
}

class GetProductCustomerModuleEvent extends ProductCustomerModuleEvent {
  int? page;
  String? querySearch;
  String? filter;

  GetProductCustomerModuleEvent({
    this.page,
    this.querySearch,
    this.filter,
  });
}
