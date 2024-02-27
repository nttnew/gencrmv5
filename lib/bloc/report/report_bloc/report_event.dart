import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class InitReportEvent extends ReportEvent {
  const InitReportEvent(this.time);
  final int? time;
  @override
  List<Object> get props => [];
}
