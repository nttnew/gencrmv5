part of 'work_clue_bloc.dart';
abstract class WorkClueEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];

  WorkClueEvent();
}
class GetWorkClue extends WorkClueEvent {

  String? id;
  GetWorkClue({this.id});
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
