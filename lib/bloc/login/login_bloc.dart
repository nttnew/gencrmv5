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
import 'package:gen_crm/l10n/l10n.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/event_repository_storage.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:plugin_pitel/pitel_sdk/pitel_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart' as GET;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final EventRepositoryStorage localRepository;
  late List<ItemMenu> listMenuFlash = [];
  BehaviorSubject<Locale> locale = BehaviorSubject.seeded(L10n.all.first);
  static const String UNREGISTER = 'UNREGISTER';
  static const String REGISTERED = 'REGISTERED';
  late BehaviorSubject<String> receivedMsg = BehaviorSubject.seeded(UNREGISTER);
  LoginData? loginData;

  LoginBloc({
    required this.userRepository,
    required this.localRepository,
  }) : super(LoginState(
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

  bool checkRegisterSuccess() {
    return receivedMsg.value == REGISTERED;
  }

  void logout(BuildContext context) {
    shareLocal.putString(PreferencesKey.REGISTER_CALL, 'true');
    receivedMsg.add(LoginBloc.UNREGISTER);
    _removeDeviceToken(context);
    PitelClient.getInstance().pitelCall.unregister();
  }

  Future<void> _removeDeviceToken(BuildContext context) async {
    final String domainUrl = shareLocal.getString(PreferencesKey.URL_BASE);
    final String domain = domainUrl.substring(
        domainUrl.indexOf('//') + 2, domainUrl.lastIndexOf('/'));
    final String user =
        LoginBloc.of(context).loginData?.info_user?.extension ?? '0';
    String deviceToken =
        await shareLocal.getString(PreferencesKey.DEVICE_TOKEN) ?? '';
    await PitelClient.getInstance().removeDeviceToken(
      deviceToken: deviceToken, // Device token
      domain: domain,
      extension: user,
    );
    await shareLocal.putString(PreferencesKey.DEVICE_TOKEN, '');
  }

  void getListMenuFlash() {
    String data = shareLocal.getString(PreferencesKey.LIST_MENU_FLASH) ?? "";
    if (data != '') {
      final result = json.decode(data);
      final resultHangXe = result.map((e) => ItemMenu.fromJson(e)).toList();
      final Set<ItemMenu> list = {};
      for (final obj in resultHangXe) {
        list.add(obj);
      }
      listMenuFlash = list.toList();
    }
  }

  void getDataCall() {
    String data = shareLocal.getString(PreferencesKey.DATA_CALL) ?? "";
    if (data != '') {
      final result = json.decode(data);
      loginData = LoginData.fromJson(result);
    }
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
            await shareLocal.putString(
                PreferencesKey.USER_NAME, state.email.value);
            await _saveData(response);
            await shareLocal.putString(
                PreferencesKey.USER_PASSWORD, state.password.value);
            DioProvider.instance(
                sess: response.data?.session_id, token: response.data?.token);
            yield state.copyWith(
                status: FormzStatus.submissionSuccess,
                message: response.msg ?? '',
                user: response.data!);
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure,
                message: response.msg ?? '');
          }
        }
      } catch (e) {
        yield state.copyWith(
            status: FormzStatus.submissionFailure,
            message: AppLocalizations.of(GET.Get.context!)?.an_error_occurred);
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
            await _saveData(response);
            DioProvider.instance(
                sess: response.data?.session_id, token: response.data?.token);
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
              message:
                  AppLocalizations.of(GET.Get.context!)?.an_error_occurred);
          throw e;
        }
      }
    }
  }

  Future<void> _saveData(LoginResponse response) async {
    listMenuFlash = [];
    listMenuFlash.addAll(response.data?.quick ?? []);
    await shareLocal.putString(
        PreferencesKey.LIST_MENU_FLASH, jsonEncode(response.data?.quick));
    await shareLocal.putString(
        PreferencesKey.DATA_CALL, jsonEncode(response.data));
    await localRepository.saveUser(jsonEncode(response.data));
    await shareLocal.putString(
        PreferencesKey.SESS, response.data?.session_id ?? '');
    await shareLocal.putString(
        PreferencesKey.TOKEN, response.data?.token ?? '');
    await shareLocal.putString(
        PreferencesKey.MENU, jsonEncode(response.data?.menu ?? ''));
    await shareLocal.putBools(PreferencesKey.FIRST_TIME, true);
    await shareLocal.putString(
        dotenv.env[PreferencesKey.TOKEN] ?? '', response.data?.token ?? '');
    await shareLocal.putString(
        PreferencesKey.USER_EMAIL, response.data?.info_user?.email ?? "");
    await shareLocal.putString(
        PreferencesKey.USER_PHONE, response.data?.info_user?.phone ?? "");
    await shareLocal.putString(
        PreferencesKey.USER_ADDRESS, response.data?.info_user?.dia_chi ?? "");
    await shareLocal.putString(
        PreferencesKey.USER_FULLNAME, response.data?.info_user?.fullname ?? "");
    await shareLocal.putString(
        PreferencesKey.URL_AVATAR, response.data?.info_user?.avatar ?? "");
    await shareLocal.putString(
        PreferencesKey.ID_USER, response.data?.info_user?.user_id ?? "");
    await shareLocal.putString(
        PreferencesKey.MONEY, response.data?.tien_te ?? "");
  }

  static LoginBloc of(BuildContext context) =>
      BlocProvider.of<LoginBloc>(context);
}
