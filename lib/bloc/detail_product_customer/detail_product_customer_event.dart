part of 'detail_product_customer_bloc.dart';

abstract class DetailProductCustomerEvent extends Equatable {
  const DetailProductCustomerEvent();
  @override
  List<Object?> get props => [];
}

class InitGetDetailProductCustomerEvent extends DetailProductCustomerEvent {
  final String id;

  InitGetDetailProductCustomerEvent(this.id);
}

class DeleteProductEvent extends DetailProductCustomerEvent {
  final String id;

  DeleteProductEvent(this.id);
}
