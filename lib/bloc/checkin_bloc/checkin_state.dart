part of 'checkin_bloc.dart';

abstract class CheckInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitCheckInState extends CheckInState {}

class LoadingCheckInState extends InitCheckInState {}

class SuccessCheckInState extends InitCheckInState {
  @override
  List<Object?> get props => [];
}

class ErrorCheckInState extends InitCheckInState {
  final String msg;

  ErrorCheckInState(this.msg);
  @override
  List<Object> get props => [msg];
}
