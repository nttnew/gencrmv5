import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gen_crm/api_resfull/dio_provider.dart';
import 'package:gen_crm/src/models/model_generator/login_response.dart';
import 'package:gen_crm/storages/share_local.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool obscurePassword = true;
  late LoginData user;
  TextEditingController _unameController = TextEditingController();
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
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginBloc>().add(PasswordUnfocused());
      }
    });
    if (canAuthenticate &&
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
    super.dispose();
  }

  getUname() async {
    _unameController.text =
        await shareLocal.getString(PreferencesKey.USER_NAME) ?? "";
    if (_unameController.text != "")
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
            title: AppLocalizations.of(Get.context!)?.notification,
            content: state.message,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppValue.vSpaceSmall,
              _buildTextFieldUsername(bloc),
              AppValue.vSpaceMedium,
              _buildTextFieldPassword(bloc),
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
              _buildChangeAddressApplication(),
            ],
          ),
        ),
      ),
    );
  }

  _buildChangeAddressApplication() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          ShowDialogCustom.showDialogTwoButtonAddress(onTap2: (String text) {
            if (text != "") {
              String urlBase = '';
              if (text.split('/').length == 1) {
                urlBase = 'https://$text/';
              } else if (text.split('/').length == 2) {
                urlBase = 'https://$text';
              } else if (text.contains('https://') &&
                  text.split('/').length < 4) {
                urlBase = '$text/';
              } else {
                urlBase = text;
              }
              shareLocal.putString(PreferencesKey.URL_BASE, urlBase);
              DioProvider.instance(baseUrl: urlBase);
              Get.back();
              widget.reload();
            } else
              Get.back();
          });
        },
        child: Text(
          AppLocalizations.of(Get.context!)?.change_address_application??'',
          style: AppStyle.DEFAULT_14W500.copyWith(
            color: HexColor("#006CB1"),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => AppNavigator.navigateForgotPassword(),
        child: Text(
          AppLocalizations.of(Get.context!)?.forgot_password ?? '' + "?",
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  _buildButtonLogin(LoginBloc bloc) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return WidgetButton(
            onTap: () async {
              final baseUrl =
                  await shareLocal.getString(PreferencesKey.URL_BASE) ?? '';
              if (baseUrl == '' || baseUrl == 'null') {
                shareLocal.putString(
                    PreferencesKey.URL_BASE, BASE_URL.URL_DEMO);
                DioProvider.instance(baseUrl: BASE_URL.URL_DEMO);
              }
              state.status.isValidated
                  ? bloc.add(FormSubmitted(device_token: tokenFirebase ?? ''))
                  : ShowDialogCustom.showDialogBase(
                      title: AppLocalizations.of(Get.context!)?.notification,
                      content: AppLocalizations.of(Get.context!)
                          ?.check_the_information,
                    );
            },
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: HexColor("#D0F1EB"),
            ),
            enable: state.status.isValidated,
            textStyle: AppStyle.DEFAULT_18_BOLD,
            text: AppLocalizations.of(Get.context!)?.login,
          );
        });
  }

  _buildTextFieldPassword(LoginBloc bloc) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return WidgetInput(
        colorFix: Theme.of(context).scaffoldBackgroundColor,
        Fix: WidgetText(
            title: AppLocalizations.of(Get.context!)?.password,
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        onChanged: (value) => bloc.add(PasswordChanged(password: value)),
        errorText: state.password.invalid
            ? AppLocalizations.of(Get.context!)
                ?.password_must_be_at_least_6_characters
            : null,
        obscureText: obscurePassword,
        focusNode: _passwordFocusNode,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor("#838A91")),
        ),
      );
    });
  }

  _buildTextFieldUsername(LoginBloc bloc) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return WidgetInput(
        colorFix: Theme.of(context).scaffoldBackgroundColor,
        onChanged: (value) => bloc.add(EmailChanged(email: value)),
        // inputType: TextInputType.emailAddress,
        focusNode: _emailFocusNode,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor("#838A91")),
        ),
        inputController: _unameController,
        errorText: state.email.invalid
            ? AppLocalizations.of(Get.context!)?.this_account_is_invalid
            : null,
        Fix: WidgetText(
            title: AppLocalizations.of(Get.context!)?.account,
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      );
    });
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
                    title:
                        AppLocalizations.of(Get.context!)?.print_finger_face_id,
                    style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
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
          localizedReason:
              AppLocalizations.of(Get.context!)?.login_with_fingerprint_face_id??'',
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
