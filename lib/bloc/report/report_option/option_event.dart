part of 'option_bloc.dart';

abstract class OptionEvent extends Equatable {
  const OptionEvent();

  @override
  List<Object> get props => [];
}

class InitOptionEvent extends OptionEvent {
  final int type;
  InitOptionEvent(this.type);

  @override
  List<Object> get props => [type];
}

