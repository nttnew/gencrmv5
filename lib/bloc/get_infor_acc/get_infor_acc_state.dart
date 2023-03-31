part of 'get_infor_acc_bloc.dart';

abstract class GetInforAccState extends Equatable {
  const GetInforAccState();
  @override
  List<Object?> get props => [];
}

class InitGetInforAccState extends GetInforAccState {}

class UpdateGetInforAccState extends GetInforAccState {
  final InforAcc inforAcc;

  const UpdateGetInforAccState(this.inforAcc);

  @override
  List<Object> get props => [inforAcc];
}

class LoadingInforAccState extends GetInforAccState {}

class ErrorGetInForAccState extends GetInforAccState {
  final String msg;

  ErrorGetInForAccState(this.msg);
  @override
  List<Object> get props => [msg];
}
