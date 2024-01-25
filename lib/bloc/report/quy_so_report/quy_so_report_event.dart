part of 'quy_so_report_bloc.dart';

abstract class QuySoReportEvent extends Equatable {
  const QuySoReportEvent();
  @override
  List<Object?> get props => [];
}

class GetDashboardQuySo extends QuySoReportEvent {
  final String? nam;
  final String? kyTaiChinh;
  final String? location;

  GetDashboardQuySo({
    this.nam,
    this.kyTaiChinh,
    this.location,
  });
}
