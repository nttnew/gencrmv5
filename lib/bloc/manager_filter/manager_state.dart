part of 'manager_bloc.dart';

abstract class ManagerState extends Equatable {
  const ManagerState();
  @override
  List<Object?> get props => [];
}

class InitGetManager extends ManagerState {}

class GetManagerState extends ManagerState {
  final List<TreeNodeData> managers;
  const GetManagerState(this.managers);
  @override
  List<Object> get props => [managers];
}

class LoadingManagerState extends ManagerState {}

class ErrorGetManagerState extends ManagerState {
  final String msg;

  ErrorGetManagerState(this.msg);
  @override
  List<Object> get props => [msg];
}
