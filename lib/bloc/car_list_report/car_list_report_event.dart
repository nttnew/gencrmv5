part of 'car_list_report_bloc.dart';

abstract class CarListReportEvent extends Equatable {
  const CarListReportEvent();
  @override
  List<Object?> get props => [];
}

class GetListReportCar extends CarListReportEvent {
  final String? time;
  final String? timeTo;
  final String? timeFrom;
  final String? diemBan;
  final String page;
  final String trangThai;

  GetListReportCar(
      {this.timeTo,
      this.timeFrom,
      this.time,
      this.diemBan,
      required this.page,
      required this.trangThai});
}
