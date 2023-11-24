part of 'add_data_bloc.dart';

abstract class AddDataEvent extends Equatable {
  const AddDataEvent();
  @override
  List<Object?> get props => [];
}

class InitAddCusOrEvent extends AddDataEvent {
  InitAddCusOrEvent();
}

class AddCustomerOrEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddCustomerOrEvent(this.data, {this.files});
}

class EditCustomerEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  EditCustomerEvent(this.data, {this.files});
}

class AddContactCustomerEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddContactCustomerEvent(this.data, {this.files});
}

class AddOpportunityEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddOpportunityEvent(this.data, {this.files});
}

class AddContractEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddContractEvent(this.data, {this.files});
}

class AddJobEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddJobEvent(this.data, {this.files});
}

class AddSupportEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddSupportEvent(this.data, {this.files});
}

class EditJobEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  EditJobEvent(this.data, {this.files});
}

class AddProductEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddProductEvent(this.data, {this.files});
}

class EditProductEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;
  final int id;

  EditProductEvent(this.data, this.id, {this.files});
}

class AddProductCustomerEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddProductCustomerEvent(this.data, {this.files});
}

class EditProductCustomerEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  EditProductCustomerEvent(this.data, {this.files});
}

class SignEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final String type;

  SignEvent(
    this.data,
    this.type,
  );
}
