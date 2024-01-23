part of 'chance_bloc.dart';

abstract class ChanceState extends Equatable {
  const ChanceState();
  @override
  List<Object?> get props => [];
}

class InitGetListChance extends ChanceState {}
