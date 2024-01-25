part of 'option_bloc.dart';

abstract class OptionEvent extends Equatable {
  const OptionEvent();

  @override
  List<Object> get props => [];
}

class InitOptionEvent extends OptionEvent {
  final int type;
  final String? kyDf;
  InitOptionEvent(
    this.type, {
    this.kyDf,
  });

  @override
  List<Object> get props => [type];
}
