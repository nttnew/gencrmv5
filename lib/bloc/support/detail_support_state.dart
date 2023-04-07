part of 'detail_support_bloc.dart';

abstract class DetailSupportState extends Equatable {
  const DetailSupportState();
  @override
  List<Object?> get props => [];
}

class InitGetDetailSupport extends DetailSupportState {}

class SuccessGetDetailSupportState extends DetailSupportState {
  final List<DataDetailChance> dataDetailSupport;
  const SuccessGetDetailSupportState(this.dataDetailSupport);
  @override
  List<Object> get props => [dataDetailSupport];
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
