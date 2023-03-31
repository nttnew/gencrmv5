part of 'option_bloc.dart';

abstract class OptionState extends Equatable {
  OptionState();

  @override
  List<Object?> get props => [];
}

class InitOptionState extends OptionState {}

class SuccessOptionState extends OptionState {
  final List<List<String>> dataTime;
  final List<List<String>> dataLocation;
  final int thoi_gian_mac_dinh;

  SuccessOptionState(this.dataTime, this.dataLocation, this.thoi_gian_mac_dinh);
  @override
  List<Object> get props => [dataTime, dataLocation, thoi_gian_mac_dinh];
}

class LoadingOptionState extends OptionState {}

class ErrorOptionState extends OptionState {
  final String msg;

  ErrorOptionState(this.msg);
  @override
  List<Object> get props => [msg];
}
