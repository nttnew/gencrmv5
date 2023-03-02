part of 'add_job_chance_bloc.dart';

abstract class AddJobChanceEvent extends Equatable {
  const AddJobChanceEvent();
  @override
  List<Object?> get props => [];
}


class InitGetAddJobEventChance extends AddJobChanceEvent {
  final int id;

  InitGetAddJobEventChance(this.id,);
}
