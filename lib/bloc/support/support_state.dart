part of 'support_bloc.dart';

abstract class SupportState extends Equatable {
  const SupportState();
  @override
  List<Object?> get props => [];
}

class InitGetSupport extends SupportState {}

class LoadingSupportState extends SupportState {}

class ErrorGetSupportState extends SupportState {
  final String msg;

  ErrorGetSupportState(this.msg);
  @override
  List<Object> get props => [msg];
}
