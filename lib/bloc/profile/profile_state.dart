part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];

}

class InitProfileState extends ProfileState{}

class LoadingProfileState extends ProfileState{}

class SuccessProfileState extends ProfileState{}

class FalseProfileState extends ProfileState{
  final String error;
  FalseProfileState({required this.error});
  @override
  List<Object> get props => [error];
}