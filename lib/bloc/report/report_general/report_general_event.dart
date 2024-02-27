part of 'report_general_bloc.dart';

abstract class ReportGeneralEvent extends Equatable {
  const ReportGeneralEvent();

  @override
  List<Object> get props => [];
}

class InitReportGeneralEvent extends ReportGeneralEvent {
  final int? page;
  final String? location;
  final int? time;

  const InitReportGeneralEvent(this.page, this.location, this.time);

  @override
  List<Object> get props => [];
}

class SelectReportGeneralEvent extends ReportGeneralEvent {
  final String? location;
  final int? time;

  const SelectReportGeneralEvent(this.location, this.time);

  @override
  List<Object> get props => [];
}
