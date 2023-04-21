part of 'attack_bloc.dart';

abstract class AttackState extends Equatable {
  const AttackState();
  @override
  List<Object?> get props => [];
}

class InitAttackState extends AttackState {}

class SuccessAttackState extends AttackState {
  final List<File>? files;
  const SuccessAttackState({this.files});
  @override
  List<Object> get props => [files!];
}

class LoadingAttackState extends AttackState {}

class ErrorAttackState extends AttackState {
  final String msg;

  ErrorAttackState(this.msg);
  @override
  List<Object> get props => [msg];
}
