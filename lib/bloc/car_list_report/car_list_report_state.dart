part of 'car_list_report_bloc.dart';

abstract class CarListReportState extends Equatable {
  const CarListReportState();
  @override
  List<Object?> get props => [];
}

class InitGetListCarListReport extends CarListReportState {}

class LoadingListCarListReportState extends CarListReportState {}

class SuccessGetCarListReportState extends CarListReportState {
  final List<ItemResponseReportCar> itemResponseReportCars;
  SuccessGetCarListReportState(this.itemResponseReportCars);
  @override
  List<Object> get props => [itemResponseReportCars];
}

class ErrorGetListCarListReportState extends CarListReportState {
  final String msg;

  ErrorGetListCarListReportState(this.msg);
  @override
  List<Object> get props => [msg];
}
