part of 'report_bloc.dart';

abstract class ReportState extends Equatable{
  ReportState();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class InitGetReportWorkState extends ReportState {}

class SuccessReportWorkState extends ReportState{
   final List<List<String>> dataTime;
   final List<List<String>> dataLocation;
   final int thoi_gian_mac_dinh;

   SuccessReportWorkState(this.dataTime,this.dataLocation,this.thoi_gian_mac_dinh);
  @override
  List<Object> get props => [dataTime,dataLocation,thoi_gian_mac_dinh];
}
class LoadingReportWorkState extends ReportState {
}


class ErrorReportWorkState extends ReportState{
  final String msg;

  ErrorReportWorkState(this.msg);
  @override
  List<Object> get props => [msg];
}


