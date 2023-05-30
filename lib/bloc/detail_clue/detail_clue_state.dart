part of 'detail_clue_bloc.dart';

abstract class DetailClueState extends Equatable {
  DetailClueState();

  @override
  List<Object?> get props => [];
}

class InitGetDetailClueState extends DetailClueState {}

class GetDetailClueState extends DetailClueState {
  List<DetailClueGroupName>? list;
  GetDetailClueState(this.list);
  @override
  List<Object?> get props => [list];
}

class LoadingDetailClueState extends DetailClueState {}

class ErrorGetDetailClueState extends DetailClueState {
  final String msg;

  ErrorGetDetailClueState(this.msg);
  @override
  List<Object> get props => [msg];
}

class SuccessDeleteClueState extends DetailClueState {}

class ErrorDeleteClueState extends DetailClueState {
  final String msg;

  ErrorDeleteClueState(this.msg);
  @override
  List<Object> get props => [msg];
}
