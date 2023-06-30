import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/forgot_password_otp/forgot_password_otp_bloc.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../bloc/forgot_password/forgot_password_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../src/src_index.dart';
import '../../widgets/rounder_bootom_appbar.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {
  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  String email = Get.arguments[0];
  String username = Get.arguments[1];
  String code = '';

  final _OtpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _OtpFocusNode.addListener(() {
      if (!_OtpFocusNode.hasFocus) {
        context
            .read<ForgotPasswordOTPBloc>()
            .add(OtpCodeForgotPasswordOTPUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _OtpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ForgotPasswordOTPBloc.of(context);
    final bloc2 = ForgotPasswordBloc.of(context);
    return BlocListener<ForgotPasswordOTPBloc, ForgotPasswordOtpState>(
      listener: (context, state) {
        if (state is ForgotPassOtpSuccess) {
          AppNavigator.navigateForgotPasswordReset(email, username);
        }
        if (state is ErrorForgotOtp) {
          GetSnackBarUtils.removeSnackBar();
          ShowDialogCustom.showDialogBase(
            title: AppLocalizations.of(Get.context!)?.notification,
            content: state.msg,
          );
        }
      },
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: SingleChildScrollView(
          child: WidgetTouchHideKeyBoard(
              child: Column(
            children: [
              RoundedAppBar(),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AppValue.vSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                AppLocalizations.of(Get.context!)
                                    ?.account_verification??'',
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                AppLocalizations.of(Get.context!)
                                    ?.please_enter_the_otp_sent_to_the_email??'',
                                style: AppStyle.DEFAULT_14W500,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: COLORS.ff006CB1),
                              ),
                              AppValue.vSpaceMedium,
                            ],
                          ),
                        ],
                      ),
                      AppValue.vSpaceMedium,
                      _buildPassAuth(context, bloc),
                      AppValue.vSpaceSmall,
                      _buildButtonSubmit(bloc),
                      AppValue.vSpaceSmall,
                      _buildSendAgain(bloc2),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  _buildSendAgain(ForgotPasswordBloc bloc) {
    return Align(
      child: RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(
          text: AppLocalizations.of(Get.context!)?.have_not_received_the_code,
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: COLORS.BLACK),
          children: <TextSpan>[
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  bloc.add(FormForgotPasswordSubmitted());
                },
              text: AppLocalizations.of(Get.context!)?.send_again,
              style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: COLORS.ff006CB1),
            ),
          ],
        ),
      ),
    );
  }

  _buildButtonSubmit(ForgotPasswordOTPBloc bloc) {
    return BlocBuilder<ForgotPasswordOTPBloc, ForgotPasswordOtpState>(
        builder: (context, state) {
      return WidgetButton(
          onTap: () {
            bloc.add(FormForgotPasswordOTPSubmitted(
                code: code, username: username, email: email));
          },
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor("#D0F1EB"),
          ),
          textStyle: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              fontSize: 14),
          text: AppLocalizations.of(Get.context!)?.confirm);
    });
  }

  _buildPassAuth(BuildContext context, ForgotPasswordOTPBloc bloc) {
    return BlocBuilder<ForgotPasswordOTPBloc, ForgotPasswordOtpState>(
        builder: (context, state) {
      return WidgetInput(
        onChanged: (value) => code = value,
        colorFix: Theme.of(context).scaffoldBackgroundColor,
        focusNode: _OtpFocusNode,
        inputType: TextInputType.emailAddress,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor("#838A91")),
        ),
        Fix: Text(AppLocalizations.of(Get.context!)?.verification_codes ?? '',
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      );
    });
  }
}
