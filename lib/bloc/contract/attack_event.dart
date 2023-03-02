part of 'attack_bloc.dart';

abstract class AttackEvent extends Equatable {
  const AttackEvent();
  @override
  List<Object?> get props => [];
}


class InitAttackEvent extends AttackEvent {
  final File? file;

  InitAttackEvent({this.file});
}

class LoadingAttackEvent extends AttackEvent {
}
