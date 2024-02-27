part of 'option_bloc.dart';

abstract class OptionEvent extends Equatable {
  const OptionEvent();

  @override
  List<Object> get props => [];
}

class InitOptionEvent extends OptionEvent {
  final int type;
  final String? kyDf;
  final int? time;
  final String? location;

  InitOptionEvent(
    this.type, {
    this.kyDf,
    this.time,
    this.location,
  });

  @override
  List<Object> get props => [
        type,
      ];
}
