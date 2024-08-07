part of 'infor_bloc.dart';

abstract class GetInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];

  GetInfoEvent();
}

class InitGetInfoEvent extends GetInfoEvent {
  InitGetInfoEvent();
}
