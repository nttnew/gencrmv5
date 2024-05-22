import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_pitel_voip/pitel_sdk/pitel_client.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_crm/api_resfull/dio_provider.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
// import 'package:gen_crm/firebase/firebase_config.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/src/models/model_generator/report_option.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/event_repository_storage.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:get/get.dart' as GET;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/key_text.dart';
import '../../src/app_const.dart';
import '../../src/models/model_generator/customer_clue.dart';
import '../../src/models/validate_form/no_data.dart';
import '../../widgets/listview/list_load_infinity.dart';
import '../../widgets/loading_api.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final EventRepositoryStorage localRepository;
  late List<Customer> listMenuFlash = [];
  BehaviorSubject<LanguagesResponse> localeLocalSelect = BehaviorSubject();
  static const String UNREGISTER = 'UNREGISTER';
  static const String REGISTERED = 'REGISTERED';
  LoginData? loginData;
  BehaviorSubject<FilterResponse> locationStatusStream = BehaviorSubject();
  BehaviorSubject<List<dynamic>> isShowLocaiton = BehaviorSubject.seeded([]);
  BehaviorSubject<dynamic> responseDetailXeDichVuStream = BehaviorSubject();
  String? valueLocation;
  String? location;
  TrangThaiHDReport? valueTrangThai;
  LoadMoreController loadMoreControllerCar = LoadMoreController();
  LoadMoreController loadMoreControllerBieuMau = LoadMoreController();
  String? trangThaiDichVu;
  String idDetailCarMain = '';

  dispose() {
    trangThaiDichVu = null;
    valueLocation = null;
    location = null;
    isShowLocaiton.add([]);
    valueTrangThai = null;
  }

  initData() async {
    loadMoreControllerCar.page = BASE_URL.PAGE_DEFAULT;
    loadMoreControllerCar.isLoadMore = true;
    final data = await getXeDichVu(
      page: BASE_URL.PAGE_DEFAULT,
    );
    if (data is String) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.an_error_occurred),
        textButton1: getT(KeyT.try_again),
        onTap1: () async {
          loadMoreControllerCar.page = BASE_URL.PAGE_DEFAULT;
          loadMoreControllerCar.isLoadMore = true;
          final data = await getXeDichVu(
            page: BASE_URL.PAGE_DEFAULT,
          );
          await loadMoreControllerCar.initData(data ?? []);
          GET.Get.back();
        },
      );
    } else {
      await loadMoreControllerCar.initData(data ?? []);
    }
  }

  LoginBloc({
    required this.userRepository,
    required this.localRepository,
  }) : super(LoginState(
          email: UserName.pure(),
          domain: NoData.pure(),
          password: Password.pure(),
          status: FormzStatus.invalid,
          message: '',
          user: LoginData(),
          device_token: '',
        ));

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    super.onTransition(transition);
  }

  Future<void> getDetailXeDichVu() async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.postDetailXeDichVu(
        idDetailCarMain,
      );
      if (isSuccess(response.code)) {
        resDynamic = response.data;
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      responseDetailXeDichVuStream.add(resDynamic);
    }
    responseDetailXeDichVuStream.add(resDynamic);
  }

  Future<dynamic> postUpdateTTHD({
    required String idTT,
  }) async {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.postUpdateTTHD(
        idDetailCarMain,
        idTT,
      );
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final msg = response.getOrElse('msg', () => -1);
      LoadingApi().popLoading();
      if (isSuccess(statusCode)) {
        return '';
      } else if (statusCode == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        return msg;
      }
    } catch (e) {
      LoadingApi().popLoading();
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> postUpdateTDNTH({
    required String id,
    required String idTD,
    required String idNTH,
  }) async {
    LoadingApi().pushLoading();
    try {
      final response = await userRepository.postUpdateTDNTH(
        id,
        idTD,
        idNTH,
      );
      final statusCode =
          (response as Map<String, dynamic>).getOrElse('code', () => -1);
      final msg = response.getOrElse('msg', () => -1);
      LoadingApi().popLoading();

      if (isSuccess(statusCode)) {
        return '';
      } else if (statusCode == BASE_URL.SUCCESS_999) {
        loginSessionExpired();
      } else {
        return msg;
      }
    } catch (e) {
      LoadingApi().popLoading();
      return getT(KeyT.an_error_occurred);
    }
  }

  Future<dynamic> getXeDichVu({
    int page = BASE_URL.PAGE_DEFAULT,
  }) async {
    dynamic resDynamic = '';
    try {
      final response = await userRepository.postXeDichVu(
        page.toString(),
        valueTrangThai?.id ?? '',
        location ?? '',
      );
      if (isSuccess(response.code)) {
        resDynamic = response.data?.dataHD ?? [];
      } else if (isFail(response.code)) {
        loginSessionExpired();
      } else
        resDynamic = response.msg ?? '';
    } catch (e) {
      resDynamic = getT(KeyT.an_error_occurred);
      return resDynamic;
    }
    return resDynamic;
  }

  Future<void> getVersionInfoCar({isCheck = false}) async {
    if (isCheck) {
      if ((shareLocal.getString(PreferencesKey.INFO_VERSION) == null ||
          shareLocal.getString(PreferencesKey.INFO_VERSION) == '' ||
          shareLocal.getString(PreferencesKey.INFO_VERSION) == []))
        getVersionCar();
    } else {
      getVersionCar();
    }
  }

  getVersionCar() async {
    try {
      final response = await userRepository.getVersionInfoCar();
      if (isSuccess(response.code)) {
        await shareLocal.putString(
            PreferencesKey.INFO_VERSION, jsonEncode(response.data?.toJson()));
      }
    } catch (e) {
      throw e;
    }
  }

  bool checkRegisterSuccess() {
    return shareLocal
            .getString(PreferencesKey.REGISTER_MSG)
            .toString()
            .toUpperCase() ==
        REGISTERED;
  }

  void logout(BuildContext context) async {
    shareLocal.putString(PreferencesKey.REGISTER_MSG, LoginBloc.UNREGISTER);
    PitelClient.getInstance().logoutExtension(getSipInfo());
    // FirebaseConfig.deleteTokenFcm();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PreferencesKey.IS_LOGGED_IN, false);
  }

  Future<void> getChiNhanh() async {
    try {
      final response = await userRepository.getReportOption2();
      if (isSuccess(response.code)) {
        locationStatusStream.add(response);
        if ((response.data?.diem_ban?.length ?? 0) > 1)
          isShowLocaiton.add(response.data?.diem_ban ?? []);
      }
    } catch (e) {
      ShowDialogCustom.showDialogBase(
        title: getT(KeyT.notification),
        content: getT(KeyT.an_error_occurred),
        textButton1: getT(KeyT.try_again),
        onTap1: () {
          getChiNhanh();
          GET.Get.back();
        },
      );
    }
  }

  void getListMenuFlash() {
    String data = shareLocal.getString(PreferencesKey.LIST_MENU_FLASH) ?? "";
    if (data != '') {
      final result = json.decode(data);
      final resultHangXe = result.map((e) => Customer.fromJson(e)).toList();
      final Set<Customer> list = {};
      for (final obj in resultHangXe) {
        list.add(obj);
      }
      listMenuFlash = list.toList();
    }
  }

  Future<void> getDataCall() async {
    String data = await shareLocal.getString(PreferencesKey.DATA_CALL) ?? "";
    if (data != '') {
      final result = json.decode(data);
      loginData = LoginData.fromJson(result);
    }
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is DomainChanged) {
      final domain = NoData.dirty(event.domain);
      yield state.copyWith(
        domain: domain.valid ? domain : NoData.pure(event.domain),
        status: Formz.validate([domain, state.email, state.password]),
      );
    } else if (event is EmailChanged) {
      final email = UserName.dirty(event.email);
      yield state.copyWith(
        email: email.valid ? email : UserName.pure(event.email),
        status: Formz.validate([state.domain, email, state.password]),
      );
    } else if (event is PasswordChanged) {
      final password = Password.dirty(event.password);
      yield state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([state.domain, state.email, password]),
      );
    } else if (event is DomainUnfocused) {
      final domain = NoData.dirty(state.domain.value);
      yield state.copyWith(
        domain: domain,
        status: Formz.validate([domain, state.email, state.password]),
      );
    } else if (event is EmailUnfocused) {
      final email = UserName.dirty(state.email.value);
      yield state.copyWith(
        email: email,
        status: Formz.validate([state.domain, email, state.password]),
      );
    } else if (event is PasswordUnfocused) {
      final password = Password.dirty(state.password.value);
      yield state.copyWith(
        password: password,
        status: Formz.validate([state.domain, state.email, password]),
      );
    } else if (event is FormSubmitted) {
      try {
        if (state.status.isValidated) {
          LoadingApi().pushLoading(isLogin: true);

          yield state.copyWith(status: FormzStatus.submissionInProgress);
          var response = await userRepository.loginApp(
            email: state.email.value,
            password: state.password.value,
            platform: Platform.isIOS ? 'iOS' : 'Android',
            device_token: event.device_token,
          );
          shareLocal.putString(PreferencesKey.DEVICE_TOKEN, event.device_token);
          if (response.code == BASE_URL.SUCCESS) {
            shareLocal.putString(
                PreferencesKey.CAR_CRM, response.data?.carCRM.toString() ?? '');

            /// 1 = true
            DioProvider.instance(
              sess: response.data?.session_id,
              token: response.data?.token,
            );
            final userName =
                await shareLocal.getString(PreferencesKey.USER_NAME);
            if (userName != state.email.value.trim()) {
              shareLocal.putString(PreferencesKey.LOGIN_FINGER_PRINT, "false");
              shareLocal.putString(
                  PreferencesKey.SHOW_LOGIN_FINGER_PRINT, "true");
            }
            await shareLocal.putString(
                PreferencesKey.USER_NAME, state.email.value);
            await _saveData(response);
            await shareLocal.putString(
                PreferencesKey.USER_PASSWORD, state.password.value);
            LoadingApi().popLoading();

            yield state.copyWith(
                status: FormzStatus.submissionSuccess,
                message: response.msg ?? '',
                user: response.data!);
          } else {
            LoadingApi().popLoading();

            yield state.copyWith(
                status: FormzStatus.submissionFailure,
                message: response.msg ?? '');
          }
        }
      } catch (e) {
        LoadingApi().popLoading();
        yield state.copyWith(
            status: FormzStatus.submissionFailure,
            message: getT(KeyT.an_error_occurred));
        throw e;
      }
    } else {
      if (event is LoginWithFingerPrint) {
        LoadingApi().pushLoading(isLogin: true);
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
            device_token: event.device_token,
          );
          shareLocal.putString(PreferencesKey.DEVICE_TOKEN, event.device_token);
          if (response.code == BASE_URL.SUCCESS) {
            shareLocal.putString(
                PreferencesKey.CAR_CRM, response.data?.carCRM.toString() ?? '');
            DioProvider.instance(
              sess: response.data?.session_id,
              token: response.data?.token,
            );
            await _saveData(response);
            LoadingApi().popLoading();
            yield state.copyWith(
                status: FormzStatus.submissionSuccess,
                message: response.msg ?? '',
                user: response.data!);
          } else {
            LoadingApi().popLoading();
            yield state.copyWith(
                status: FormzStatus.submissionFailure,
                message: response.msg ?? '');
          }
        } catch (e) {
          LoadingApi().popLoading();
          yield state.copyWith(
              status: FormzStatus.submissionFailure,
              message: getT(KeyT.an_error_occurred));
          throw e;
        }
      }
    }
  }

  Future<void> _saveData(LoginResponse response) async {
    await shareLocal.putString(
        PreferencesKey.DATA_CALL, jsonEncode(response.data));
    await localRepository.saveUser(jsonEncode(response.data));
    await shareLocal.putString(
        PreferencesKey.SESS, response.data?.session_id ?? '');
    await shareLocal.putString(
        PreferencesKey.TOKEN, response.data?.token ?? '');
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
    await shareLocal.putString(
        PreferencesKey.LANGUAGE_BE, jsonEncode(response.data?.languages ?? []));
    for (final value in response.data?.languages ?? []) {
      if (value.defaultLanguages == 1) {
        final lang = await shareLocal.getString(PreferencesKey.LANGUAGE) ?? '';
        if (lang == '') setLanguage(value);
      }
    }
    await getLanguageAPI();
    await getLocationApi();
    await getMenuMain();
    // address app local
    final resAddressLocal =
        shareLocal.getString(PreferencesKey.LIST_ADDRESS_APP);
    final baseUrl = shareLocal.getString(PreferencesKey.URL_BASE_FORMAT);
    List<dynamic> listAddressDynamic = [];
    listAddressDynamic.add(baseUrl);
    if (resAddressLocal != null) {
      listAddressDynamic.addAll(jsonDecode(resAddressLocal) as List<dynamic>);
    }
    shareLocal.putString(PreferencesKey.LIST_ADDRESS_APP,
        jsonEncode(removeDuplicates(listAddressDynamic)));
  }

  List<dynamic> removeDuplicates(List<dynamic> list) {
    Set<dynamic> uniqueItems =
        {}; // Tạo một set để lưu trữ các giá trị duy nhất

    // Lặp qua danh sách và thêm các giá trị vào set
    for (dynamic item in list) {
      uniqueItems.add(item);
    }

    // Chuyển đổi set trở lại thành danh sách và trả về
    return uniqueItems.toList();
  }

  Future<void> getMenuMain() async {
    try {
      final response = await userRepository.getMenuMain();
      if (isSuccess(response.code)) {
        await shareLocal.putString(
          PreferencesKey.MENU,
          jsonEncode(response.data?.mainMenu),
        );
        listMenuFlash = [];
        listMenuFlash.addAll(response.data?.quickMenu ?? []);
        await shareLocal.putString(
          PreferencesKey.LIST_MENU_FLASH,
          jsonEncode(response.data?.quickMenu),
        );
      } else {
        loginSessionExpired();
      }
    } catch (e) {
      loginSessionExpired();
    }
  }

  void getLanguage() async {
    final lang = await shareLocal.getString(PreferencesKey.LANGUAGE) ?? '';
    if (lang != '') {
      LanguagesResponse language = LanguagesResponse.fromJson(
          jsonDecode(shareLocal.getString(PreferencesKey.LANGUAGE) ?? ''));
      addLocalLang(language);
      localeLocalSelect.add(language);
    }
  }

  Future<void> getLanguageAPI() async {
    try {
      final response = await userRepository.getLanguage();
      if ((response['error'] == BASE_URL.SUCCESS_200)) {
        await shareLocal.putString(
            PreferencesKey.LANGUAGE_BE_ALL, jsonEncode(response['data']));
      }
    } catch (e) {}
  }

  Future<void> getLocationApi() async {
    try {
      final response = await userRepository.getDataLocation();
      if (response != null && response != '') {
        await shareLocal.putString(
            PreferencesKey.LOCATION, jsonEncode(response));
      }
    } catch (e) {}
  }

  void addLocalLang(LanguagesResponse langRes) {
    if (shareLocal.getString(PreferencesKey.TOKEN) != '' ||
        shareLocal.getString(PreferencesKey.TOKEN) != null)
      DioProvider.instance(
          token: shareLocal.getString(PreferencesKey.TOKEN),
          sess: shareLocal.getString(PreferencesKey.SESS));
  }

  Future<void> reloadLang() async {
    LoadingApi().pushLoading();
    await getLanguageAPI();
    await getLocationApi();
    LoadingApi().popLoading();
  }

  void setLanguage(LanguagesResponse language) {
    shareLocal.putString(PreferencesKey.LANGUAGE, jsonEncode(language));
    shareLocal.putString(PreferencesKey.LANGUAGE_NAME, language.name ?? '');
    localeLocalSelect.add(language);
    addLocalLang(language);
  }

  Future<dynamic> getBieuMau({String id = '5' // dich vu,
      }) async {
    dynamic res = getT(KeyT.an_error_occurred);
    try {
      final response = await userRepository.getBieuMau(module: id);
      if (isSuccess(response.code)) {
        res = response.data ?? [];
      } else if (isFail(response.code)) {
        res = response.msg ?? '';
      } else {
        res = response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
      return getT(KeyT.an_error_occurred);
    }
    LoadingApi().popLoading();
    return res;
  }

  Future<Map<String, dynamic>> getPdf({
    String module = '5', // dich vu,
    required String idDetail,
    required String idBieuMau,
  }) async {
    LoadingApi().pushLoading();

    Map<String, dynamic> res = {
      'mes': getT(KeyT.an_error_occurred),
      'html': '',
    };

    try {
      final response = await userRepository.getPdf(
        module: module,
        idDetail: idDetail,
        idBieuMau: idBieuMau,
      );
      if (isSuccess(response.code)) {
        res['html'] = response.data?.link ?? '';
        res['mes'] = '';
      } else if (isFail(response.code)) {
        res['mes'] = response.msg ?? '';
      } else {
        res['mes'] = response.msg ?? '';
      }
    } catch (e) {
      LoadingApi().popLoading();
      res['mes'] = getT(KeyT.an_error_occurred);
      return res;
    }
    LoadingApi().popLoading();
    return res;
  }

  static LoginBloc of(BuildContext context) =>
      BlocProvider.of<LoginBloc>(context);
}
