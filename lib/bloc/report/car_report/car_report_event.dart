part of 'car_report_bloc.dart';

abstract class CarReportEvent extends Equatable {
  const CarReportEvent();
  @override
  List<Object?> get props => [];
}

class GetDashboardCar extends CarReportEvent {
  final int? time;
  final String? timeTo;
  final String? timeFrom;
  final String? diemBan;

  GetDashboardCar({
    this.timeTo,
    this.timeFrom,
    this.time,
    this.diemBan,
  });
}
