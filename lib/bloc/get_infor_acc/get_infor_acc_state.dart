part of 'get_infor_acc_bloc.dart';

abstract class GetInfoAccState extends Equatable {
  const GetInfoAccState();
  @override
  List<Object?> get props => [];
}

class InitGetInfoAccState extends GetInfoAccState {}

class UpdateGetInfoAccState extends GetInfoAccState {
  final InfoAcc infoAcc;

  const UpdateGetInfoAccState(this.infoAcc);

  @override
  List<Object> get props => [infoAcc];
}

class LoadingInfoAccState extends GetInfoAccState {}

class ErrorGetInForAccState extends GetInfoAccState {
  final String msg;

  ErrorGetInForAccState(this.msg);
  @override
  List<Object> get props => [msg];
}
