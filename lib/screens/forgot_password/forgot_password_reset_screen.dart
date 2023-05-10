import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets/rounder_bootom_appbar.dart';

class ForgotPasswordResetScreen extends StatefulWidget {
  @override
  State<ForgotPasswordResetScreen> createState() =>
      _ForgotPasswordResetScreenState();
}

class _ForgotPasswordResetScreenState extends State<ForgotPasswordResetScreen> {
  String email = Get.arguments[0];
  String username = Get.arguments[1];
  String newPass = '';
  String cfPass = '';

  final _newPassFocusNode = FocusNode();
  final _cfPassFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _newPassFocusNode.addListener(() {
      if (!_newPassFocusNode.hasFocus) {
        context.read<ResetPasswordBloc>().add(NewPasswordResetUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _newPassFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ResetPasswordBloc.of(context);
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPassSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WidgetDialog(
                title: MESSAGES.NOTIFICATION,
                content: 'Cập nhật mật khẩu thành công!',
                onTap1: () {
                  AppNavigator.navigateLogin();
                },
                textButton1: MESSAGES.OKE,
                backgroundButton1: COLORS.PRIMARY_COLOR,
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
                                "Cập nhật mật khẩu",
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Nhập mật khẩu mới để đăng nhập tài khoản",
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              AppValue.vSpaceMedium,
                            ],
                          ),
                        ],
                      ),
                      AppValue.vSpaceMedium,
                      _buildTextFieldPassword(context, bloc),
                      AppValue.vSpaceMedium,
                      _buildTextFieldPasswordPressAgain(context),
                      AppValue.vSpaceSmall,
                      _buildButtonSubmit(bloc)
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

  _buildButtonSubmit(ResetPasswordBloc bloc) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        builder: (context, state) {
      return WidgetButton(
          onTap: () {
            if (cfPass == newPass) {
              if (cfPass.length < 6 || newPass.length < 6) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WidgetDialog(
                      title: MESSAGES.NOTIFICATION,
                      content: 'Mật khẩu có ít nhất 6 kí tự',
                    );
                  },
                );
              } else
                bloc.add(FormResetPasswordSubmitted(
                    newPass: newPass, username: username, email: email));
            } else
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WidgetDialog(
                    title: MESSAGES.NOTIFICATION,
                    content: 'Mật khẩu không trùng khớp!',
                  );
                },
              );
          },
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor("#A6C1BC"),
          ),
          textStyle: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              fontSize: 14),
          text: "Hoàn thành");
    });
  }

  _buildTextFieldPassword(BuildContext context, ResetPasswordBloc bloc) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        builder: (context, state) {
      return WidgetInput(
        onChanged: (value) => newPass = value,
        focusNode: _newPassFocusNode,
        inputType: TextInputType.text,
        colorFix: Theme.of(context).scaffoldBackgroundColor,
        Fix: Text("Mật khẩu",
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        obscureText: true,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor("#838A91")),
        ),
      );
    });
  }

  _buildTextFieldPasswordPressAgain(BuildContext context) {
    return WidgetInput(
      onChanged: (value) {
        cfPass = value;
      },
      focusNode: _cfPassFocusNode,
      inputType: TextInputType.text,
      colorFix: Theme.of(context).scaffoldBackgroundColor,
      Fix: Text("Nhập lại mật khẩu",
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              fontSize: 14)),
      obscureText: true,
      boxDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor("#838A91")),
      ),
    );
  }
}
