part of 'job_chance_bloc.dart';

abstract class GetJobChanceEvent extends Equatable {
  const GetJobChanceEvent();
  @override
  List<Object?> get props => [];
}

class InitGetJobEventChance extends GetJobChanceEvent {
  final int id;

  InitGetJobEventChance(this.id);
}
