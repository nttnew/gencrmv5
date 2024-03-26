import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/api_resfull/dio_provider.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';
import '../../../l10n/key_text.dart';
import '../../../widgets/form_input/form_input.dart';
import '../../../widgets/loading_api.dart';

class WidgetLoginForm extends StatefulWidget {
  WidgetLoginForm({
    Key? key,
    required this.reload,
    required this.isLogin,
  }) : super(key: key);

  final Function reload;
  final bool isLogin;

  @override
  _WidgetLoginFormState createState() => _WidgetLoginFormState();
}

class _WidgetLoginFormState extends State<WidgetLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailFocusNode = FocusNode();
  final _domainFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool obscurePassword = true;
  late LoginData user;
  TextEditingController _unameController = TextEditingController();
  TextEditingController _domainController = TextEditingController();
  String baseUrl = "";
  String? tokenFirebase;

  final LocalAuthentication auth = LocalAuthentication();
  bool canAuthenticateWithBiometrics = false;
  bool canAuthenticate = false;
  List<BiometricType> availableBiometrics = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    tokenFirebase = await messaging.getToken();
    canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    availableBiometrics = await auth.getAvailableBiometrics();
    setState(() {
      canAuthenticateWithBiometrics = canAuthenticateWithBiometrics;
      canAuthenticate = canAuthenticate;
      availableBiometrics = availableBiometrics;
    });
    getUname();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginBloc>().add(EmailUnfocused());
      }
    });
    _domainFocusNode.addListener(() {
      if (!_domainFocusNode.hasFocus) {
        context.read<LoginBloc>().add(DomainUnfocused());
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginBloc>().add(PasswordUnfocused());
      }
    });
    if (widget.isLogin &&
        canAuthenticate &&
        shareLocal.getString(PreferencesKey.LOGIN_FINGER_PRINT) == "true" &&
        shareLocal.getString(PreferencesKey.USER) != "" &&
        shareLocal.getString(PreferencesKey.USER) != null) {
      loginWithFingerPrint();
    }
  }

  @override
  void didChangeDependencies() {
    LoginBloc.of(context).add(PasswordChanged(password: ''));
    if (widget.isLogin &&
        shareLocal.getString(PreferencesKey.LOGIN_FINGER_PRINT) == "true" &&
        shareLocal.getString(PreferencesKey.USER) != "" &&
        shareLocal.getString(PreferencesKey.USER) != null) {
      loginWithFingerPrint();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _domainFocusNode.dispose();
    super.dispose();
  }

  getUname() async {
    _unameController.text =
        await shareLocal.getString(PreferencesKey.USER_NAME) ?? '';
    _domainController.text =
        await shareLocal.getString(PreferencesKey.URL_BASE_FORMAT) ?? '';
    if (_domainController.text != '')
      LoginBloc.of(context).add(DomainChanged(domain: _domainController.text));
    if (_unameController.text != '')
      LoginBloc.of(context).add(EmailChanged(email: _unameController.text));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoginBloc.of(context);
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          GetSnackBarUtils.removeSnackBar();
          AppNavigator.navigateMain(data: state.user);
        }
        if (state.status.isSubmissionInProgress) {
          GetSnackBarUtils.createProgress();
        }
        if (state.status.isSubmissionFailure) {
          GetSnackBarUtils.removeSnackBar();
          ShowDialogCustom.showDialogBase(
              title: getT(KeyT.notification),
              content: state.message,
              onWhen: () {
                LoadingApi().popLoading();
              });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppValue.vSpaceSmall,
              FormInputBase(
                controller: _unameController,
                textInputAction: TextInputAction.next,
                title: getT(KeyT.account),
                onChange: (value) => bloc.add(EmailChanged(email: value)),
                validateFun: (v) {
                  if (v.trim() == '') {
                    return getT(KeyT.this_account_is_invalid);
                  }
                  return null;
                },
              ),
              AppValue.vSpaceSmall,
              FormInputBase(
                isPass: true,
                textInputAction: TextInputAction.next,
                title: getT(KeyT.password),
                onChange: (value) => bloc.add(PasswordChanged(password: value)),
                validateFun: (v) {
                  if (v.trim() == '') {
                    return getT(KeyT.password_must_be_at_least_6_characters);
                  }
                  return null;
                },
              ),
              AppValue.vSpaceSmall,
              FormInputBase(
                controller: _domainController,
                textInputAction: TextInputAction.done,
                title: getT(KeyT.change_address_application),
                onChange: (value) => bloc.add(DomainChanged(domain: value)),
                validateFun: (v) {
                  if (v.trim() == '') {
                    return getT(KeyT.validate_address_app);
                  }
                  return null;
                },
                suffixConstraint: BoxConstraints(
                  maxHeight: 20,
                  maxWidth: 44,
                ),
                iconWidget:
                    shareLocal.getString(PreferencesKey.LIST_ADDRESS_APP) !=
                            null
                        ? GestureDetector(
                            onTap: () async {
                              final data =
                                  await ShowDialogCustom.showDialogScreenBase(
                                isPop: true,
                                child: _itemShowAddressApp(),
                              );
                              if (data != null) {
                                _domainController.text = data;
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 16,
                                left: 8,
                              ),
                              child: Image.asset(
                                ICONS.IC_SELECT_ADDRESS_PNG,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : null,
                onSubmit: () {
                  _onLogin(bloc);
                },
              ),
              AppValue.vSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFingerPrintButton(),
                  _buildForgotPassword(),
                ],
              ),
              AppValue.vSpaceSmall,
              _buildButtonLogin(bloc),
              AppValue.vSpaceMedium,
            ],
          ),
        ),
      ),
    );
  }

  _itemShowAddressApp() {
    final List<dynamic> listAddress =
        jsonDecode(shareLocal.getString(PreferencesKey.LIST_ADDRESS_APP));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          getT(KeyT.change_address_application),
          style: AppStyle.DEFAULT_18_BOLD,
        ),
        ListView.builder(
          padding: EdgeInsets.only(
            top: 16,
          ),
          shrinkWrap: true,
          itemCount: listAddress.length,
          itemBuilder: (context, i) => GestureDetector(
            onTap: () {
              Get.back(
                result: listAddress[i].toString(),
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(
                vertical: 4,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: COLORS.WHITE,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    8,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: COLORS.BLACK.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                listAddress[i],
                style: AppStyle.DEFAULT_16_BOLD,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getDataDomain() {
    final text = _domainController.text;
    shareLocal.putString(PreferencesKey.URL_BASE_FORMAT, text);
    String urlBase = '';
    if (text.split('/').length == 1) {
      urlBase = 'https://$text/';
    } else if (text.split('/').length == 2) {
      urlBase = 'https://$text';
    } else if (text.contains('https://') && text.split('/').length < 4) {
      urlBase = '$text/';
    } else {
      urlBase = text;
    }
    shareLocal.putString(PreferencesKey.URL_BASE, urlBase);
    DioProvider.instance(baseUrl: urlBase);
  }

  _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => AppNavigator.navigateForgotPassword(),
        child: Text(
          getT(KeyT.forgot_password),
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  _onLogin(bloc) {
    if ((_formKey.currentState?.validate() ?? false)) {
      _getDataDomain();
      bloc.add(FormSubmitted(device_token: tokenFirebase ?? ''));
    }
  }

  _buildButtonLogin(LoginBloc bloc) {
    return WidgetButton(
      onTap: () async {
        _onLogin(bloc);
      },
      boxDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor("#D0F1EB"),
      ),
      textStyle: AppStyle.DEFAULT_18_BOLD,
      text: getT(KeyT.login),
    );
  }

  _buildFingerPrintButton() {
    return canAuthenticate &&
            shareLocal.getString(PreferencesKey.LOGIN_FINGER_PRINT) == "true" &&
            shareLocal.getString(PreferencesKey.USER) != "" &&
            shareLocal.getString(PreferencesKey.USER) != null
        ? Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: loginWithFingerPrint,
              child: Row(
                children: [
                  Image.asset(
                    ICONS.IC_FACE_PNG,
                    height: 24,
                    width: 24,
                    color: COLORS.BLACK,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  WidgetText(
                    title: getT(KeyT.print_finger_face_id),
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          )
        : SizedBox();
  }

  loginWithFingerPrint() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final didAuthenticate = await auth.authenticate(
          localizedReason: getT(KeyT.login_with_fingerprint_face_id),
          options: const AuthenticationOptions(biometricOnly: true));
      if (didAuthenticate) {
        LoginBloc.of(context)
            .add(LoginWithFingerPrint(device_token: tokenFirebase ?? ''));
      } else {
        return;
      }
    } catch (e) {
      throw e;
    }
  }
}
