part of 'attack_bloc.dart';

abstract class AttackEvent extends Equatable {
  const AttackEvent();
  @override
  List<Object?> get props => [];
}

class InitAttackEvent extends AttackEvent {
  final List<File>? files;

  InitAttackEvent({this.files});
}

class RemoveAttackEvent extends AttackEvent {
  final File file;

  RemoveAttackEvent({required this.file});
}

class RemoveAllAttackEvent extends AttackEvent {}

class LoadingAttackEvent extends AttackEvent {}
