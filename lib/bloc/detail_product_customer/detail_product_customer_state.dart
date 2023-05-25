part of 'detail_product_customer_bloc.dart';

abstract class DetailProductCustomerState extends Equatable {
  const DetailProductCustomerState();
  @override
  List<Object?> get props => [];
}

class InitGetDetailProduct extends DetailProductCustomerState {}

class GetDetailProductCustomerState extends DetailProductCustomerState {
  final DetailProductCustomerResponse productInfo;
  const GetDetailProductCustomerState(this.productInfo);
  @override
  List<Object> get props => [productInfo];
}

class LoadingDetailProductCustomerState extends DetailProductCustomerState {}

class ErrorGetDetailProductCustomerState extends DetailProductCustomerState {
  final String msg;

  ErrorGetDetailProductCustomerState(this.msg);
  @override
  List<Object> get props => [msg];
}

class LoadingDeleteProductState extends DetailProductCustomerState {}

class SuccessDeleteProductState extends DetailProductCustomerState {}

class ErrorDeleteProductState extends DetailProductCustomerState {
  final String msg;

  ErrorDeleteProductState(this.msg);
  @override
  List<Object> get props => [msg];
}
