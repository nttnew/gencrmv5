part of 'total_bloc.dart';

abstract class TotalEvent extends Equatable {
  const TotalEvent();
  @override
  List<Object?> get props => [];
}

class InitTotalEvent extends TotalEvent {
  final double total;

  InitTotalEvent(this.total);
}
