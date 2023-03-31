import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/src_index.dart';

part 'profile_state.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;
  ProfileBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(InitProfileState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FormSubmitProfileEvent) {
      yield* _mapProfileEventToState(infoUser: event.info);
    }
  }

  Stream<ProfileState> _mapProfileEventToState(
      {required ParamChangeInfo infoUser}) async* {
    GetSnackBarUtils.createProgress();
    yield LoadingProfileState();
    if (infoUser.imageBase64 != null && infoUser.imageBase64 != '') {
      try {
        final response =
            await _userRepository.postUpdateProfile(infoUser: infoUser);
        if (response.code == BASE_URL.SUCCESS) {
          yield SuccessProfileState();
        } else
          yield FalseProfileState(error: response.message ?? 'Có lỗi xảy ra');
      } catch (e) {
        yield FalseProfileState(error: 'Lỗi không xác định');
        throw e;
      }
    } else {
      try {
        ParamChangeInfoNotImage data = ParamChangeInfoNotImage(
            id: infoUser.id,
            userCode: infoUser.userCode,
            fullname: infoUser.fullname,
            phone: infoUser.phone,
            email: infoUser.email,
            gender: infoUser.gender,
            address: infoUser.address);
        final response =
            await _userRepository.postUpdateProfileNotImage(infoUser: data);
        if (response.code == BASE_URL.SUCCESS) {
          yield SuccessProfileState();
        } else
          yield FalseProfileState(error: response.message ?? 'Có lỗi xảy ra');
      } catch (e) {
        yield FalseProfileState(error: 'Lỗi không xác định');
        throw e;
      }
    }
  }

  static ProfileBloc of(BuildContext context) =>
      BlocProvider.of<ProfileBloc>(context);
}
