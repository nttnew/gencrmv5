part of 'add_job_chance_bloc.dart';

abstract class AddJobChanceState extends Equatable {
  const AddJobChanceState();
  @override
  List<Object?> get props => [];
}

class InitGetAddJobChance extends AddJobChanceState {}

class UpdateGetAddJobChanceState extends AddJobChanceState {
  final List<Field_General> data;

  const UpdateGetAddJobChanceState(this.data);

  @override
  List<Object> get props => [data];
}

class LoadingAddJobChanceState extends AddJobChanceState {}

class ErrorGetAddJobChanceState extends AddJobChanceState {
  final String msg;

  ErrorGetAddJobChanceState(this.msg);
  @override
  List<Object> get props => [msg];
}
