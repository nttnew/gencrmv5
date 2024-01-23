part of 'customer_bloc.dart';

abstract class GetListCustomerEvent extends Equatable {
  const GetListCustomerEvent();
  @override
  List<Object?> get props => [];
}

class AddCustomerIndividualEvent extends GetListCustomerEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddCustomerIndividualEvent(this.data, {this.files});
}
