part of 'detail_chance_bloc.dart';

abstract class DetailChanceEvent extends Equatable {
  const DetailChanceEvent();
  @override
  List<Object?> get props => [];
}

class InitGetListDetailEvent extends DetailChanceEvent {
  final int id;

  InitGetListDetailEvent(this.id);
}

class InitDeleteChanceEvent extends DetailChanceEvent {
  final String id;

  InitDeleteChanceEvent(this.id);
}
