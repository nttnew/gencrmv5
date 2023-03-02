part of 'report_employee_bloc.dart';

abstract class ReportEmployeeState extends Equatable{
  ReportEmployeeState();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class InitReportEmployeeState extends ReportEmployeeState {}

class SuccessReportEmployeeState extends ReportEmployeeState{
  final List<DataEmployList> data;


  SuccessReportEmployeeState(this.data);
  @override
  List<Object> get props => [data];
}
class LoadingReportEmployeeState extends ReportEmployeeState {
}


class ErrorReportEmployeeState extends ReportEmployeeState{
  final String msg;

  ErrorReportEmployeeState(this.msg);
  @override
  List<Object> get props => [msg];
}


