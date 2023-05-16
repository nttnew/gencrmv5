part of 'form_edit_bloc.dart';

abstract class FormEditEvent extends Equatable {
  const FormEditEvent();
  @override
  List<Object?> get props => [];
}

class InitFormEditCusEvent extends FormEditEvent {
  final String? id;

  InitFormEditCusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditClueEvent extends FormEditEvent {
  final String? id;

  InitFormEditClueEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditChanceEvent extends FormEditEvent {
  final String? id;

  InitFormEditChanceEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditJobEvent extends FormEditEvent {
  final String? id;

  InitFormEditJobEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditSupportEvent extends FormEditEvent {
  final String? id;

  InitFormEditSupportEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditContractEvent extends FormEditEvent {
  final String? id;

  InitFormEditContractEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitGetContactByCustomerEvent extends FormEditEvent {
  final String? id;

  InitGetContactByCustomerEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditProductEvent extends FormEditEvent {
  final String? id;

  InitFormEditProductEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditProductCustomerEvent extends FormEditEvent {
  final String? id;

  InitFormEditProductCustomerEvent(this.id);
  @override
  List<Object?> get props => [id];
}
