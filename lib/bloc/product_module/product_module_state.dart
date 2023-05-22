part of 'product_module_bloc.dart';

abstract class ProductModuleState extends Equatable {
  const ProductModuleState();
  @override
  List<Object?> get props => [];
}

class InitGetListProductModuleState extends ProductModuleState {}

class SuccessGetListProductModuleState extends ProductModuleState {
  final List<ProductModule> list;
  SuccessGetListProductModuleState(this.list);

  @override
  List<Object> get props => [list];
}

class LoadingGetListProductModuleState extends ProductModuleState {}

class ErrorGetListProductModuleState extends ProductModuleState {
  final String msg;

  ErrorGetListProductModuleState(this.msg);
  @override
  List<Object> get props => [msg];
}
