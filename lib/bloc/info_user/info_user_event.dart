part of 'info_user_bloc.dart';

abstract class InfoUserEvent extends Equatable {
  const InfoUserEvent();
  @override
  List<Object?> get props => [];
}
class LoadResponseToken extends InfoUserEvent{}
class InitDataEvent extends InfoUserEvent {}
class AddDataEvent extends InfoUserEvent {}
class UploadImagesEvent extends InfoUserEvent{
  final File file;
  final ProfileBloc bloc;
  UploadImagesEvent({required this.file, required this.bloc});
  @override
  List<Object?> get props => [file];
}
