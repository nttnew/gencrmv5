part of 'detail_work_bloc.dart';

abstract class DetailWorkState extends Equatable {
  DetailWorkState();

  @override
  List<Object?> get props => [];
}

class InitGetDetailWorkState extends DetailWorkState {}

class SuccessDetailWorkState extends DetailWorkState {
  final List<InfoDataModel> dataList;
  final CheckInLocation? checkIn, checkOut;
  final int? location;
  final String? diDong;
  final String? audioUrl;

  SuccessDetailWorkState(
    this.dataList,
    this.location,
    this.diDong,
    this.checkIn,
    this.checkOut,
    this.audioUrl,
  );

  @override
  List<Object?> get props => [
        dataList,
        location,
        checkIn,
        checkOut,
        diDong,
        audioUrl,
      ];
}

class LoadingDetailWorkState extends DetailWorkState {}

class ErrorGetDetailWorkState extends DetailWorkState {
  final String msg;

  ErrorGetDetailWorkState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessDeleteWorkState extends DetailWorkState {}

class LoadingDeleteWorkState extends DetailWorkState {}

class ErrorDeleteWorkState extends DetailWorkState {
  final String msg;

  ErrorDeleteWorkState(this.msg);
  @override
  List<Object> get props => [msg];
}
