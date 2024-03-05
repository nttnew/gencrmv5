part of 'detail_chance_bloc.dart';

abstract class DetailChanceState extends Equatable {
  const DetailChanceState();
  @override
  List<Object?> get props => [];
}

class InitGetListDetailChance extends DetailChanceState {}

class UpdateGetListDetailChanceState extends DetailChanceState {
  final List<InfoDataModel> data;

  const UpdateGetListDetailChanceState(this.data);
  @override
  List<Object> get props => [data];
}

class LoadingListDetailChanceState extends DetailChanceState {}

class ErrorGetListDetailChanceState extends DetailChanceState {
  final String msg;

  ErrorGetListDetailChanceState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessDeleteChanceState extends DetailChanceState {}

class ErrorDeleteChanceState extends DetailChanceState {
  final String msg;

  ErrorDeleteChanceState(this.msg);
  @override
  List<Object> get props => [msg];
}
