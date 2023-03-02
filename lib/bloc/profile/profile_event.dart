part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class FormSubmitProfileEvent extends ProfileEvent {
  final ParamChangeInfo info;

  FormSubmitProfileEvent({required this.info});

  @override
  String toString() {
    return 'FormSubmitProfileEvent{info: $info}';
  }

  List<Object> get props => [info];
}

class UpdateProfileSuccess extends ProfileEvent {}