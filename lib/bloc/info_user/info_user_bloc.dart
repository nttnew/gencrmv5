import 'dart:io';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/bloc/profile/profile_bloc.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/storages.dart';

part 'info_user_event.dart';
part 'info_user_state.dart';

class InfoUserBloc extends Bloc<InfoUserEvent, InfoUserState> {
  final EventRepositoryStorage _localRepository;
  final UserRepository userRepository;
  final BuildContext? context;

  InfoUserBloc(
      {required UserRepository userRepository,
      required EventRepositoryStorage localRepository,
      this.context})
      : userRepository = userRepository,
        _localRepository = localRepository,
        super(const InitUserState.unknown());

  @override
  Stream<InfoUserState> mapEventToState(InfoUserEvent event) async* {
    if (event is LoadResponseToken) {
      yield* _mapResponseTokenToState();
    } else if (event is InitDataEvent) {
      yield* _mapInfoUserState();
    } else if (event is AddDataEvent) {
      yield* _mapAddDataInfoUserState();
    } else if (event is UploadImagesEvent) {
      yield* _mapUploadImagesState(event.file, event.bloc);
    }
  }

  Stream<InfoUserState> _mapResponseTokenToState() async* {
    try {} catch (e) {
      throw e;
    }
  }

  Stream<InfoUserState> _mapInfoUserState() async* {
    try {
      final loadUser = await this._localRepository.loadUser();
      userRepository.addUser(LoginData.fromJson(json.decode(loadUser)));
    } catch (e) {
      throw e;
    }
  }

  Stream<InfoUserState> _mapAddDataInfoUserState() async* {
    try {
      final infoUser = await this.userRepository.getInfoUser();
      await _localRepository.saveUserID(infoUser.payload!.id!.toString());
      yield UpdateInfoUserState(infoUser.payload!);
      if (infoUser.payload!.fullName == null ||
          infoUser.payload!.fullName == '') {
        AppNavigator.navigateEditInfo(infoUser.payload!);
      }
    } catch (e) {
      yield LoginExpiredState(message: MESSAGES.LOGIN_EXPIRED);
      throw e;
    }
  }

  Stream<InfoUserState> _mapUploadImagesState(
      File file, ProfileBloc bloc) async* {
    try {} catch (e) {
      await GetSnackBarUtils.createFailure(message: MESSAGES.CONNECT_ERROR);
      throw e;
    }
  }

  static InfoUserBloc of(BuildContext context) =>
      BlocProvider.of<InfoUserBloc>(context);
}
