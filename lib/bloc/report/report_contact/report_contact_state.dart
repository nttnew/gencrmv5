part of 'report_contact_bloc.dart';

abstract class ReportContactState extends Equatable {
  ReportContactState();

  @override
  List<Object?> get props => [];
}

class InitReportContactState extends ReportContactState {}

class SuccessReportContactState extends ReportContactState {
  final List<DataListContact> data;
  final String total;

  SuccessReportContactState(this.data, this.total);
  @override
  List<Object> get props => [data, total];
}

class LoadingReportContactState extends ReportContactState {}

class ErrorReportContactState extends ReportContactState {
  final String msg;

  ErrorReportContactState(this.msg);
  @override
  List<Object> get props => [msg];
}
