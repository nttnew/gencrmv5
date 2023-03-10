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
  final Map<String,dynamic> data;
  final File? files;

  AddCustomerOrEvent(this.data,{this.files});

}

class EditCustomerEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  EditCustomerEvent(this.data,{this.files});

}

class AddContactCustomerEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  AddContactCustomerEvent(this.data,{this.files});

}

class AddOpportunityEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  AddOpportunityEvent(this.data,{this.files});

}

class AddContractEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  AddContractEvent(this.data,{this.files});

}

class AddJobEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  AddJobEvent(this.data,{this.files});
}

class AddSupportEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  AddSupportEvent(this.data,{this.files});
}

class AddJobOppEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  AddJobOppEvent(this.data,{this.files});
}

class EditJobEvent extends AddDataEvent {
  final Map<String,dynamic> data;
  final File? files;

  EditJobEvent(this.data,{this.files});
}