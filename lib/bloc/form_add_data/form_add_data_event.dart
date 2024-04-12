part of 'form_add_data_bloc.dart';

abstract class FormAddEvent extends Equatable {
  const FormAddEvent();
  @override
  List<Object?> get props => [];
}

class InitFormAddCusOrEvent extends FormAddEvent {
  InitFormAddCusOrEvent();
}

class InitFormAddCustomerEvent extends FormAddEvent {
  InitFormAddCustomerEvent();
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
  final int? idCustomer;
  InitFormAddProductCustomerEvent({
    this.idCustomer,
  });
}

class InitFormAddSignEvent extends FormAddEvent {
  final String? id;
  final String type;

  InitFormAddSignEvent(
    this.id,
    this.type,
  );

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

class InitFormAddQuickContract extends FormAddEvent {
  final String sdt;
  final String bienSoXe;

  InitFormAddQuickContract(this.sdt, this.bienSoXe);
  @override
  List<Object?> get props => [sdt, bienSoXe];
}

class InitFormEditCusEvent extends FormAddEvent {
  final String? id;

  InitFormEditCusEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditClueEvent extends FormAddEvent {
  final String? id;

  InitFormEditClueEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditChanceEvent extends FormAddEvent {
  final String? id;

  InitFormEditChanceEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditJobEvent extends FormAddEvent {
  final String? id;

  InitFormEditJobEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditSupportEvent extends FormAddEvent {
  final String? id;

  InitFormEditSupportEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditContractEvent extends FormAddEvent {
  final String? id;

  InitFormEditContractEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitGetContactByCustomerEvent extends FormAddEvent {
  final String? id;

  InitGetContactByCustomerEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditProductEvent extends FormAddEvent {
  final String? id;

  InitFormEditProductEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditProductCustomerEvent extends FormAddEvent {
  final String? id;

  InitFormEditProductCustomerEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormAddPaymentEvent extends FormAddEvent {
  final String? id;

  InitFormAddPaymentEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitFormEditPaymentEvent extends FormAddEvent {
  final String? id;
  final String? idPay;
  final String? idDetail;

  InitFormEditPaymentEvent(
    this.id,
    this.idPay,
    this.idDetail,
  );
  @override
  List<Object?> get props => [id, idPay, idDetail];
}
