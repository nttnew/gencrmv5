part of 'report_product_bloc.dart';

abstract class ReportProductState extends Equatable {
  ReportProductState();

  @override
  List<Object?> get props => [];
}

class InitReportProductState extends ReportProductState {}

class InitReportSelectProductState extends ReportProductState {}

class SuccessReportProductState extends ReportProductState {
  final List<ListReportProduct> list;

  SuccessReportProductState(this.list);
  @override
  List<Object> get props => [list];
}

class SuccessReportSelectState extends ReportProductState {
  final List<ListReportProduct> listSelect;

  SuccessReportSelectState(this.listSelect);
  @override
  List<Object> get props => [listSelect];
}

class LoadingReportProductState extends ReportProductState {}

class LoadingReportSelectProductState extends ReportProductState {}

class ErrorReportProductState extends ReportProductState {
  final String msg;

  ErrorReportProductState(this.msg);
  @override
  List<Object> get props => [msg];
}

class ErrorReportSelectProductState extends ReportProductState {
  final String msg;

  ErrorReportSelectProductState(this.msg);
  @override
  List<Object> get props => [msg];
}
