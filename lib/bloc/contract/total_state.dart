part of 'total_bloc.dart';

abstract class TotalState extends Equatable {
  const TotalState();
  @override
  List<Object?> get props => [];
}
class InitGetTotalState extends TotalState {}

class SuccessTotalState extends TotalState{
  final double total;
  const SuccessTotalState(this.total);
  @override
  List<Object> get props => [total];
}

class LoadingTotalState extends TotalState {
}


class ErrorTotalState extends TotalState{
  final String msg;

  ErrorTotalState(this.msg);
  @override
  List<Object> get props => [msg];
}