import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../l10n/key_text.dart';
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
          ShowDialogCustom.showDialogBase(
            title: getT(KeyT.notification),
            content: getT(KeyT.update_password_successful),
            onTap1: () {
              AppNavigator.navigateLogin();
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
                                getT(KeyT.update_password),
                                style: TextStyle(
                                    fontFamily: "Quicksand",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                getT(KeyT
                                    .enter_a_new_password_to_log_into_your_account),
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
                      AppValue.vSpaceSmall,
                      _buildTextFieldPassword(context, bloc),
                      AppValue.vSpaceSmall,
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
                ShowDialogCustom.showDialogBase(
                    title: getT(KeyT.notification),
                    content: getT(KeyT.password_must_be_at_least_6_characters));
              } else
                bloc.add(FormResetPasswordSubmitted(
                    newPass: newPass, username: username, email: email));
            } else
              ShowDialogCustom.showDialogBase(
                  title: getT(KeyT.notification),
                  content: getT(KeyT.password_not_match));
          },
          boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: COLORS.SECONDS_COLOR,
          ),
          textStyle: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w600,
              fontSize: 14),
          text: getT(KeyT.completed));
    });
  }

  _buildTextFieldPassword(BuildContext context, ResetPasswordBloc bloc) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        builder: (context, state) {
      return WidgetInput(
        onChanged: (value) => newPass = value,
        focusNode: _newPassFocusNode,
        inputType: TextInputType.text,
        colorTxtLabel: Theme.of(context).scaffoldBackgroundColor,
        textLabel: Text(getT(KeyT.password),
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        obscureText: true,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: COLORS.ff838A91),
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
      colorTxtLabel: Theme.of(context).scaffoldBackgroundColor,
      textLabel: Text(
        getT(KeyT.enter_password_again),
        style: TextStyle(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      obscureText: true,
      boxDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: COLORS.ff838A91),
      ),
    );
  }
}
