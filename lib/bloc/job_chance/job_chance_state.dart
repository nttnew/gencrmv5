part of 'job_chance_bloc.dart';

abstract class JobChanceState extends Equatable {
  const JobChanceState();
  @override
  List<Object?> get props => [];
}

class InitGetJobChance extends JobChanceState {}

class UpdateGetJobChanceState extends JobChanceState {
  final List<DataFormAdd> data;

  const UpdateGetJobChanceState(this.data);
  @override
  List<Object> get props => [data];
}

class LoadingJobChanceState extends JobChanceState {}

class ErrorGetJobChanceState extends JobChanceState {
  final String msg;

  ErrorGetJobChanceState(this.msg);
  @override
  List<Object> get props => [msg];
}
