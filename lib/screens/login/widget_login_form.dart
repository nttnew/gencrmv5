// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

class WidgetLoginForm extends StatefulWidget {
  WidgetLoginForm({Key? key, required this.reload}) : super(key: key);

  final Function reload;

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
    super.initState();
    // fireBase();
    Future.delayed(Duration(seconds: 0), () async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      tokenFirebase = await messaging.getToken();
      print("tokenFireBase: $tokenFirebase");
      canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      availableBiometrics = await auth.getAvailableBiometrics();
      setState(() {
        canAuthenticateWithBiometrics = canAuthenticateWithBiometrics;
        canAuthenticate = canAuthenticate;
        availableBiometrics = availableBiometrics;
      });
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WidgetDialog(
                title: MESSAGES.NOTIFICATION,
                content: state.message,
              );
            },
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
              AppValue.vSpaceSmall,
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
              if (text.split("/").length < 4) {
                dotenv.env[PreferencesKey.BASE_URL] = text + '/';
                shareLocal.putString("baseUrl", text + '/');
                DioProvider.instance(baseUrl: text + '/');
              } else {
                dotenv.env[PreferencesKey.BASE_URL] = text;
                shareLocal.putString("baseUrl", text);
                DioProvider.instance(baseUrl: text);
              }
              Get.back();
              widget.reload();
            } else
              Get.back();
          });
        },
        child: Text(
          "Đổi địa chỉ ứng dụng",
          style: TextStyle(
              fontFamily: "Quicksand",
              color: HexColor("#006CB1"),
              fontWeight: FontWeight.w500,
              fontSize: 12),
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
          MESSAGES.FORGOT_PASSWORD + "?",
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ),
      ),
    );
  }

  _buildButtonLogin(LoginBloc bloc) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return WidgetButton(
              onTap: () {
                // AppNavigator.navigateMain();
                state.status.isValidated
                    ? bloc.add(FormSubmitted(device_token: tokenFirebase ?? ''))
                    : showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const WidgetDialog(
                            title: MESSAGES.NOTIFICATION,
                            content: 'Kiểm tra lại thông tin',
                          );
                        },
                      );
              },
              boxDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#A6C1BC"),
              ),
              enable: state.status.isValidated,
              textStyle:
                  AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w600),
              text: MESSAGES.LOGIN);
        });
  }

  _buildTextFieldPassword(LoginBloc bloc) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return WidgetInput(
        colorFix: Theme.of(context).scaffoldBackgroundColor,
        Fix: WidgetText(
            title: "Mật khẩu",
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        onChanged: (value) => bloc.add(PasswordChanged(password: value)),
        errorText: state.password.invalid ? MESSAGES.PASSWORD_ERROR : null,
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
        errorText: state.email.invalid ? MESSAGES.EMAIL_ERROR : null,
        Fix: WidgetText(
            title: "Tài khoản",
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
                  Icon(Icons.fingerprint),
                  WidgetText(
                    title: "Vân tay",
                    style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
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
          localizedReason: 'Đăng nhập bằng vân tay',
          options: const AuthenticationOptions(biometricOnly: true));
      if (didAuthenticate) {
        LoginBloc.of(context)
            .add(LoginWithFingerPrint(device_token: tokenFirebase ?? ''));
      } else {
        return;
      }
    } catch (e) {
      throw e;
      return;
    }
  }
}
