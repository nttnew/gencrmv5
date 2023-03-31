part of 'detail_customer_bloc.dart';

abstract class DetailCustomerEvent extends Equatable {
  const DetailCustomerEvent();
  @override
  List<Object?> get props => [];
}

class InitGetDetailCustomerEvent extends DetailCustomerEvent {
  final int id;

  InitGetDetailCustomerEvent(this.id);
}

class DeleteCustomerEvent extends DetailCustomerEvent {
  final int id;

  DeleteCustomerEvent(this.id);
}
