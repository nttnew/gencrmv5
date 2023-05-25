part of 'form_add_data_bloc.dart';

abstract class FormAddEvent extends Equatable {
  const FormAddEvent();
  @override
  List<Object?> get props => [];
}

class InitFormAddCusOrEvent extends FormAddEvent {
  InitFormAddCusOrEvent();
}

class InitFormAddContactCusEvent extends FormAddEvent {
  final String? id;

  InitFormAddContactCusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddOppCusEvent extends FormAddEvent {
  final String? id;

  InitFormAddOppCusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddContractCusEvent extends FormAddEvent {
  final String? id;

  InitFormAddContractCusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddJobCusEvent extends FormAddEvent {
  final String? id;

  InitFormAddJobCusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddSupportCusEvent extends FormAddEvent {
  final String? id;

  InitFormAddSupportCusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddAgencyEvent extends FormAddEvent {
  final String? id;

  InitFormAddAgencyEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class InitFormAddChanceEvent extends FormAddEvent {
  final String? id;

  InitFormAddChanceEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class InitFormAddContractEvent extends FormAddEvent {
  final String? id;

  InitFormAddContractEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class InitFormAddJobEvent extends FormAddEvent {
  final String? id;

  InitFormAddJobEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class InitFormAddSupportEvent extends FormAddEvent {
  final String? id;

  InitFormAddSupportEvent({this.id});
  @override
  List<Object?> get props => [id];
}

class InitFormAddJobOppEvent extends FormAddEvent {
  final String? id;

  InitFormAddJobOppEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddJobChanceEvent extends FormAddEvent {
  final String? id;

  InitFormAddJobChanceEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddSupportContractEvent extends FormAddEvent {
  final String? id;

  InitFormAddSupportContractEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddJobContractEvent extends FormAddEvent {
  final String? id;

  InitFormAddJobContractEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddProductEvent extends FormAddEvent {
  InitFormAddProductEvent();
}

class InitFormAddProductCustomerEvent extends FormAddEvent {
  InitFormAddProductCustomerEvent();
}

class InitFormAddSignEvent extends FormAddEvent {
  final String? id;

  InitFormAddSignEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ResetDataEvent extends FormAddEvent {
  ResetDataEvent();
}

class InitFormAddCHProductCustomerEvent extends FormAddEvent {
  final int id;

  InitFormAddCHProductCustomerEvent(this.id);
  @override
  List<Object> get props => [id];
}

class InitFormAddCVProductCustomerEvent extends FormAddEvent {
  final int id;

  InitFormAddCVProductCustomerEvent(this.id);
  @override
  List<Object> get props => [id];
}

class InitFormAddHDProductCustomerEvent extends FormAddEvent {
  final int id;

  InitFormAddHDProductCustomerEvent(this.id);
  @override
  List<Object> get props => [id];
}

class InitFormAddHTProductCustomerEvent extends FormAddEvent {
  final int id;

  InitFormAddHTProductCustomerEvent(this.id);
  @override
  List<Object> get props => [id];
}
