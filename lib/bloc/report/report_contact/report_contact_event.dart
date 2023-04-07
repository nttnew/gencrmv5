part of 'report_contact_bloc.dart';

abstract class ReportContactEvent extends Equatable {
  const ReportContactEvent();

  @override
  List<Object> get props => [];
}

class LoadingReportContactEvent extends ReportContactEvent {}

class InitReportContactEvent extends ReportContactEvent {
  final int? id;
  final int? page;
  final String? location, gt;
  final int? time;

  const InitReportContactEvent(
      {this.page, this.location, this.time, this.id, this.gt});

  @override
  List<Object> get props => [];
}
