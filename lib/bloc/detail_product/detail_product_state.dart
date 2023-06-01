part of 'detail_product_bloc.dart';

abstract class DetailProductState extends Equatable {
  const DetailProductState();
  @override
  List<Object?> get props => [];
}

class InitGetDetailProduct extends DetailProductState {}

class UpdateGetDetailProductState extends DetailProductState {
  final DetailProductResponse? productInfo;
  const UpdateGetDetailProductState(this.productInfo);
  @override
  List<Object?> get props => [productInfo];
}

class LoadingDetailProductState extends DetailProductState {}

class ErrorGetDetailProductState extends DetailProductState {
  final String msg;

  ErrorGetDetailProductState(this.msg);
  @override
  List<Object> get props => [msg];
}

class LoadingDeleteProductState extends DetailProductState {}

class SuccessDeleteProductState extends DetailProductState {}

class ErrorDeleteProductState extends DetailProductState {
  final String msg;

  ErrorDeleteProductState(this.msg);
  @override
  List<Object> get props => [msg];
}
