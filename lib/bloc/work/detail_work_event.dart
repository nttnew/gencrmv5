part of 'detail_work_bloc.dart';

abstract class DetailWorkEvent extends Equatable {
  DetailWorkEvent();
  @override
  List<Object?> get props => [];
}

class InitGetDetailWorkEvent extends DetailWorkEvent {
  final int? id;
  InitGetDetailWorkEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class InitDeleteWorkEvent extends DetailWorkEvent {
  final int? id;
  InitDeleteWorkEvent(this.id);
  @override
  List<Object?> get props => [id];
}

