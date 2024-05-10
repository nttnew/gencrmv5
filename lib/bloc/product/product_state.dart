part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class InitGetListProductState extends ProductState {}

class SuccessGetListProductState extends ProductState {
  final List<ProductItem> listProduct;
  final List<List<dynamic>> listDvt;
  final List<List<dynamic>> listVat;
  final int total;

  SuccessGetListProductState(
    this.listProduct,
    this.listDvt,
    this.listVat,
    this.total,
  );
  @override
  List<Object> get props => [
        listProduct,
        listDvt,
        listVat,
        total,
      ];
}

class LoadingGetListProductState extends ProductState {}

class ErrorGetListProductState extends ProductState {
  final String msg;

  ErrorGetListProductState(this.msg);
  @override
  List<Object> get props => [msg];
}
