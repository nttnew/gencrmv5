part of 'infor_bloc.dart';

abstract class InfoState extends Equatable {
  @override
  List<Object?> get props => [];

  InfoState();
}

class InitGetInfoState extends InfoState {}

class UpdateGetInfoState extends InfoState {
  final String? gioiThieu;

  UpdateGetInfoState(this.gioiThieu);
}

class LoadingGetInfoState extends InfoState {}

class ErrorGetInfoState extends InfoState {
  final String msg;

  ErrorGetInfoState(this.msg);
  @override
  List<Object> get props => [msg];
}
