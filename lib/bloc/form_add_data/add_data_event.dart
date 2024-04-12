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

class AddCustomerEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddCustomerEvent(this.data, {this.files});
}

class EditCustomerEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  EditCustomerEvent(this.data, {this.files});
}

class AddContactCustomerEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;
  final bool isEdit;

  AddContactCustomerEvent(this.data, {this.files, this.isEdit = false});
}

class AddOpportunityEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;
  final bool isEdit;

  AddOpportunityEvent(this.data, {this.files, this.isEdit = false});
}

class AddContractEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;
  final bool isEdit;

  AddContractEvent(this.data, {this.files, this.isEdit = false});
}

class AddJobEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  AddJobEvent(this.data, {this.files});
}

class AddSupportEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;
  final bool isEdit;

  AddSupportEvent(this.data, {this.files, this.isEdit = false});
}

class EditJobEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  EditJobEvent(this.data, {this.files});
}

class AddProductEvent extends AddDataEvent {
  final FormDataCustom data;
  final List<File>? files;

  AddProductEvent(this.data, {this.files});
}

class EditProductEvent extends AddDataEvent {
  final FormDataCustom data;
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

class QuickContractSaveEvent extends AddDataEvent {
  final Map<String, dynamic> data;
  final List<File>? files;

  QuickContractSaveEvent(
    this.data,
    this.files,
  );
}

class AddPayment extends AddDataEvent {
  final Map<String, dynamic> data;

  AddPayment(
    this.data,
  );
}

class EditPayment extends AddDataEvent {
  final Map<String, dynamic> data;

  EditPayment(
    this.data,
  );
}
