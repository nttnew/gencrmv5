part of 'report_product_bloc.dart';

abstract class ReportProductEvent extends Equatable {
  const ReportProductEvent();

  @override
  List<Object> get props => [];
}

class InitReportProductEvent extends ReportProductEvent {
  final int? cl;
  final String? location;
  final int? time;
  final String? timeFrom;
  final String? timeTo;

  const InitReportProductEvent(
      {this.timeFrom, this.timeTo, this.cl, this.location, this.time});

  @override
  List<Object> get props => [];
}

class SelectReportProductEvent extends ReportProductEvent {
  final int? cl;
  final String? location;
  final int? time;
  final String? timeFrom;
  final String? timeTo;

  const SelectReportProductEvent(
      {this.timeFrom, this.timeTo, this.cl, this.location, this.time});

  @override
  List<Object> get props => [];
}
