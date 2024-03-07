part of 'detail_support_bloc.dart';

abstract class DetailSupportState extends Equatable {
  const DetailSupportState();
  @override
  List<Object?> get props => [];
}

class InitGetDetailSupport extends DetailSupportState {}

class SuccessGetDetailSupportState extends DetailSupportState {
  final List<InfoDataModel> dataDetailSupport;
  final CheckInLocation? checkIn, checkOut;
  final int? location;
  const SuccessGetDetailSupportState(this.dataDetailSupport, this.location,this.checkIn,this.checkOut,);
  @override
  List<Object?> get props => [dataDetailSupport, location];
}

class LoadingDetailSupportState extends DetailSupportState {}

class ErrorGetDetailSupportState extends DetailSupportState {
  final String msg;

  ErrorGetDetailSupportState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessDeleteSupportState extends DetailSupportState {}

class ErrorDeleteSupportState extends DetailSupportState {
  final String msg;

  ErrorDeleteSupportState(this.msg);
  @override
  List<Object> get props => [msg];
}
