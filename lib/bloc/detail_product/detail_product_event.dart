part of 'detail_product_bloc.dart';

abstract class DetailProductEvent extends Equatable {
  const DetailProductEvent();
  @override
  List<Object?> get props => [];
}

class InitGetDetailProductEvent extends DetailProductEvent {
  final String id;

  InitGetDetailProductEvent(this.id);
}

class DeleteProductEvent extends DetailProductEvent {
  final String id;

  DeleteProductEvent(this.id);
}
