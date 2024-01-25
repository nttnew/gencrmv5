part of 'quy_so_report_bloc.dart';

abstract class QuySoReportState extends Equatable {
  const QuySoReportState();
  @override
  List<Object?> get props => [];
}

class InitGetListQuySoReport extends QuySoReportState {}

class LoadingListQuySoReportState extends QuySoReportState {}

class SuccessQuySoReportState extends QuySoReportState {
  final DataBaoCaoSoQuy? dataQuySo;
  SuccessQuySoReportState(this.dataQuySo);
  @override
  List<Object?> get props => [dataQuySo];
}

class ErrorGetListQuySoReportState extends QuySoReportState {
  final String msg;

  ErrorGetListQuySoReportState(this.msg);
  @override
  List<Object> get props => [msg];
}
