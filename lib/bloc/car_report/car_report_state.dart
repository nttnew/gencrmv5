part of 'car_report_bloc.dart';

abstract class CarReportState extends Equatable {
  const CarReportState();
  @override
  List<Object?> get props => [];
}

class InitGetListCarReport extends CarReportState {}

class LoadingListCarReportState extends CarReportState {}

class SuccessCarReportState extends CarReportState {
  final DataCarDashboard? responseCarDashboard;
  SuccessCarReportState(this.responseCarDashboard);
  @override
  List<Object?> get props => [responseCarDashboard];
}


class SuccessGetListCarReportState extends CarReportState {
  final List<ItemResponseReportCar>? itemResponseReportCars;
  SuccessGetListCarReportState(this.itemResponseReportCars);
  @override
  List<Object?> get props => [itemResponseReportCars];
}

class ErrorGetListCarReportState extends CarReportState {
  final String msg;

  ErrorGetListCarReportState(this.msg);
  @override
  List<Object> get props => [msg];
}
