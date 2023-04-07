import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../widgets/rounder_bootom_appbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _EmailFocusNode = FocusNode();
  final _UserFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _EmailFocusNode.addListener(() {
      if (!_EmailFocusNode.hasFocus) {
        context.read<ForgotPasswordBloc>().add(EmailForgotPasswordUnfocused());
      }
    });
    _UserFocusNode.addListener(() {
      if (!_UserFocusNode.hasFocus) {
        context.read<ForgotPasswordBloc>().add(UserForgotPasswordUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _EmailFocusNode.dispose();
    _UserFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ForgotPasswordBloc.of(context);
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            GetSnackBarUtils.removeSnackBar();
            AppNavigator.navigateForgotPasswordOTP(
                state.email.value.toString(), state.username.value.toString());
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
                                WidgetText(
                                    title: "Quên mật khẩu",
                                    style: AppStyle.DEFAULT_20_BOLD),
                                SizedBox(
                                  height: 5,
                                ),
                                WidgetText(
                                  title:
                                      "Vui lòng nhập email đăng ký tài khoản",
                                  style: AppStyle.DEFAULT_12,
                                ),
                                AppValue.vSpaceMedium,
                              ],
                            ),
                          ],
                        ),
                        AppValue.vSpaceMedium,
                        _buildTextFieldEmail(context, bloc),
                        AppValue.vSpaceMedium,
                        _buildTextFieldUsername(context, bloc),
                        _buildButtonSubmit(bloc),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ),
        ));
  }

  _buildButtonSubmit(ForgotPasswordBloc bloc) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
      return WidgetButton(
        onTap: () => bloc.add(FormForgotPasswordSubmitted()),
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: HexColor("#A6C1BC"),
        ),
        textStyle: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w600),
        text: MESSAGES.NEXT.toUpperCase(),
      );
    });
  }

  _buildTextFieldEmail(BuildContext context, ForgotPasswordBloc bloc) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
      return WidgetInput(
        onChanged: (value) =>
            bloc.add(EmailForgotPasswordChanged(email: value)),
        colorFix: Theme.of(context).scaffoldBackgroundColor,
        focusNode: _EmailFocusNode,
        inputType: TextInputType.emailAddress,
        errorText: state.email.invalid ? MESSAGES.EMAIL_ERROR : null,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor("#838A91")),
        ),
        Fix: WidgetText(
            title: "Email",
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      );
    });
  }

  _buildTextFieldUsername(BuildContext context, ForgotPasswordBloc bloc) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
      return WidgetInput(
        onChanged: (value) =>
            bloc.add(UserForgotPasswordChanged(username: value)),
        colorFix: Theme.of(context).scaffoldBackgroundColor,
        focusNode: _UserFocusNode,
        inputType: TextInputType.text,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor("#838A91")),
        ),
        Fix: Text("User",
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      );
    });
  }
}
