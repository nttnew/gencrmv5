part of 'info_user_bloc.dart';

abstract class InfoUserState extends Equatable {
  const InfoUserState();
  @override
  List<Object?> get props => [];
}
class InitUserState extends InfoUserState {
  const InitUserState._();
  const InitUserState.unknown() : this._();
  @override
  List<Object> get props => [];
}
class UpdateInfoUserState extends InfoUserState{
  final InfoUser infoUser;
  const UpdateInfoUserState(this.infoUser);
  @override
  List<Object> get props => [infoUser];
}

class LoginExpiredState extends InfoUserState{
  final String message;
  LoginExpiredState({required this.message});
  @override
  List<Object?> get props => [message];
}

class UploadUserState extends InfoUserState{
  final InfoUser user;
  UploadUserState({required this.user});
  @override
  List<Object?> get props => [user];
}