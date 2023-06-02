part of 'add_service_bloc.dart';

abstract class AddServiceVoucherEvent extends Equatable {
  const AddServiceVoucherEvent();
  @override
  List<Object?> get props => [];
}

class PostServiceVoucherEvent extends AddServiceVoucherEvent {
  final String sdt;
  final String bienSoXe;

  PostServiceVoucherEvent(this.sdt, this.bienSoXe);
  @override
  List<Object?> get props => [sdt, bienSoXe];
}

class SaveVoucherServiceEvent extends AddServiceVoucherEvent {
  final VoucherServiceRequest voucherServiceRequest;
  final List<File>? listFile;

  SaveVoucherServiceEvent(
    this.voucherServiceRequest,
    this.listFile,
  );
  @override
  List<Object?> get props => [voucherServiceRequest, listFile];
}
