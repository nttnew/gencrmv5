part of 'get_infor_acc_bloc.dart';

abstract class GetInfoAccEvent extends Equatable {
  @override
  List<Object?> get props => [];

  GetInfoAccEvent();
}

class InitGetInfoAcc extends GetInfoAccEvent {
  InitGetInfoAcc({this.isLoading});

  final bool? isLoading;
}
