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
