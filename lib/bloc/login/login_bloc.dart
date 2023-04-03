import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_crm/api_resfull/dio_provider.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/event_repository_storage.dart';
import 'package:gen_crm/storages/share_local.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final EventRepositoryStorage localRepository;

  LoginBloc({required this.userRepository, required this.localRepository})
      : super(LoginState(
            email: UserName.pure(),
            password: Password.pure(),
            status: FormzStatus.invalid,
            message: '',
            user: LoginData(),
            device_token: ''));

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      final email = UserName.dirty(event.email);
      yield state.copyWith(
        email: email.valid ? email : UserName.pure(event.email),
        status: Formz.validate([email, state.password]),
      );
    } else if (event is PasswordChanged) {
      final password = Password.dirty(event.password);
      yield state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([state.email, password]),
      );
    } else if (event is EmailUnfocused) {
      final email = UserName.dirty(state.email.value);
      yield state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      );
    } else if (event is PasswordUnfocused) {
      final password = Password.dirty(state.password.value);
      yield state.copyWith(
        password: password,
        status: Formz.validate([state.email, password]),
      );
    } else if (event is FormSubmitted) {
      try {
        if (state.status.isValidated) {
          yield state.copyWith(status: FormzStatus.submissionInProgress);
          var response = await userRepository.loginApp(
              email: state.email.value,
              password: state.password.value,
              platform: Platform.isIOS ? 'iOS' : 'Android',
              device_token: event.device_token);
          if (response.code == BASE_URL.SUCCESS) {
            await localRepository.saveUser(jsonEncode(response.data));
            await shareLocal.putString(
                PreferencesKey.SESS, response.data!.session_id!);
            await shareLocal.putString(
                PreferencesKey.TOKEN, response.data!.token!);
            await shareLocal.putString(
                PreferencesKey.MENU, jsonEncode(response.data!.menu!));
            await shareLocal.putBools(PreferencesKey.FIRST_TIME, true);
            await shareLocal.putString(
                dotenv.env[PreferencesKey.TOKEN]!, response.data!.token!);
            await shareLocal.putString(
                PreferencesKey.USER_NAME, state.email.value);
            await shareLocal.putString(PreferencesKey.USER_EMAIL,
                response.data!.info_user!.email ?? "");
            await shareLocal.putString(PreferencesKey.USER_PHONE,
                response.data!.info_user!.phone ?? "");
            await shareLocal.putString(PreferencesKey.USER_ADDRESS,
                response.data!.info_user!.dia_chi ?? "");
            await shareLocal.putString(PreferencesKey.USER_FULLNAME,
                response.data!.info_user!.fullname ?? "");
            await shareLocal.putString(PreferencesKey.URL_AVATAR,
                response.data!.info_user!.avatar ?? "");
            await shareLocal.putString(
                PreferencesKey.MONEY, response.data!.tien_te ?? "");
            await shareLocal.putString(
                PreferencesKey.USER_PASSWORD, state.password.value);

            DioProvider.instance(
                sess: response.data!.session_id!, token: response.data!.token);
            yield state.copyWith(
                status: FormzStatus.submissionSuccess,
                message: response.msg ?? '',
                user: response.data!);
            // Future.delayed(Duration(milliseconds: 500), () async* {
            //   yield SaveUserState(response.data!);
            // });
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure,
                message: response.msg ?? '');
          }
        }
      } catch (e) {
        yield state.copyWith(
            status: FormzStatus.submissionFailure,
            message: MESSAGES.CONNECT_ERROR);
        throw e;
      }
    } else {
      if (event is LoginWithFingerPrint) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);
        try {
          String userName =
              shareLocal.getString(PreferencesKey.USER_NAME) ?? "";
          String password =
              shareLocal.getString(PreferencesKey.USER_PASSWORD) ?? "";
          var response = await userRepository.loginApp(
              email: userName,
              password: password,
              platform: Platform.isIOS ? 'iOS' : 'Android',
              device_token: event.device_token);
          if (response.code == BASE_URL.SUCCESS) {
            await localRepository.saveUser(jsonEncode(response.data));
            await shareLocal.putString(
                PreferencesKey.SESS, response.data!.session_id!);
            await shareLocal.putString(
                PreferencesKey.TOKEN, response.data!.token!);
            await shareLocal.putString(
                PreferencesKey.MENU, jsonEncode(response.data!.menu!));
            await shareLocal.putBools(PreferencesKey.FIRST_TIME, true);
            await shareLocal.putString(
                dotenv.env[PreferencesKey.TOKEN]!, response.data!.token!);
            await shareLocal.putString(PreferencesKey.USER_EMAIL,
                response.data!.info_user!.email ?? "");
            await shareLocal.putString(PreferencesKey.USER_PHONE,
                response.data!.info_user!.phone ?? "");
            await shareLocal.putString(PreferencesKey.USER_ADDRESS,
                response.data!.info_user!.dia_chi ?? "");
            await shareLocal.putString(PreferencesKey.USER_FULLNAME,
                response.data!.info_user!.fullname ?? "");
            await shareLocal.putString(PreferencesKey.URL_AVATAR,
                response.data!.info_user!.avatar ?? "");
            await shareLocal.putString(
                PreferencesKey.MONEY, response.data!.tien_te ?? "");

            DioProvider.instance(
                sess: response.data!.session_id!, token: response.data!.token);
            yield state.copyWith(
                status: FormzStatus.submissionSuccess,
                message: response.msg ?? '',
                user: response.data!);
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure,
                message: response.msg ?? '');
          }
        } catch (e) {
          yield state.copyWith(
              status: FormzStatus.submissionFailure,
              message: MESSAGES.CONNECT_ERROR);
          throw e;
        }
      }
    }
  }

  static LoginBloc of(BuildContext context) =>
      BlocProvider.of<LoginBloc>(context);
}
