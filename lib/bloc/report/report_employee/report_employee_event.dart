part of 'report_employee_bloc.dart';

abstract class ReportEmployeeEvent extends Equatable {
  const ReportEmployeeEvent();

  @override
  List<Object> get props => [];
}

class InitReportEmployeeEvent extends ReportEmployeeEvent {
  final int? time;
  final String? timeTo;
  final int? diemBan;
  final String? timeFrom;

  const InitReportEmployeeEvent({this.time, this.timeTo, this.diemBan, this.timeFrom});

  @override
  List<Object> get props => [];
}

