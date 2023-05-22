part of 'product_customer_module_bloc.dart';

abstract class ProductCustomerModuleState extends Equatable {
  const ProductCustomerModuleState();
  @override
  List<Object?> get props => [];
}

class InitGetListProductCustomerModuleState
    extends ProductCustomerModuleState {}

class SuccessGetListProductCustomerModuleState
    extends ProductCustomerModuleState {
  final List<ProductCustomerResponse> list;
  SuccessGetListProductCustomerModuleState(this.list);

  @override
  List<Object> get props => [list];
}

class LoadingGetListProductCustomerModuleState
    extends ProductCustomerModuleState {}

class ErrorGetListProductCustomerModuleState
    extends ProductCustomerModuleState {
  final String msg;

  ErrorGetListProductCustomerModuleState(this.msg);
  @override
  List<Object> get props => [msg];
}
