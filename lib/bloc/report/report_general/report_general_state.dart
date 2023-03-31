part of 'report_general_bloc.dart';

abstract class ReportGeneralState extends Equatable {
  ReportGeneralState();

  @override
  List<Object?> get props => [];
}

class InitReportGeneralState extends ReportGeneralState {}

class SuccessReportGeneralState extends ReportGeneralState {
  final DataGeneral? data;

  SuccessReportGeneralState(this.data);
  @override
  List<Object> get props => [];
}

class LoadingReportGeneralState extends ReportGeneralState {}

class ErrorReportGeneralState extends ReportGeneralState {
  final String msg;

  ErrorReportGeneralState(this.msg);
  @override
  List<Object> get props => [msg];
}
