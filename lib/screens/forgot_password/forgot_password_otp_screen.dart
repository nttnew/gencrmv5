import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/forgot_password_otp/forgot_password_otp_bloc.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../bloc/forgot_password/forgot_password_bloc.dart';
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WidgetDialog(
                title: MESSAGES.NOTIFICATION,
                content: state.msg,
              );
            },
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
                                "Xác thực tài khoản",
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Vui lòng nhập mã OTP được gửi đến email:",
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: HexColor("#006CB1")),
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
        text: TextSpan(
          text: 'Chưa nhận được mã?',
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  bloc.add(FormForgotPasswordSubmitted());
                },
              text: ' Gửi lại',
              style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: HexColor("#006CB1")),
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
            color: HexColor("#A6C1BC"),
          ),
          textStyle: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              fontSize: 14),
          text: "Xác nhận");
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
        Fix: Text("Mã xác thực",
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      );
    });
  }
}
