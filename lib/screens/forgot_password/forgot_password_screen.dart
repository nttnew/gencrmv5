import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

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
            ShowDialogCustom.showDialogBase(
              title: AppLocalizations.of(Get.context!)?.notification,
              content: state.message,
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
                                    title: AppLocalizations.of(Get.context!)
                                        ?.forgot_password,
                                    style: AppStyle.DEFAULT_20_BOLD),
                                SizedBox(
                                  height: 5,
                                ),
                                WidgetText(
                                  title: AppLocalizations.of(Get.context!)
                                      ?.please_enter_email_register_account,
                                  style: AppStyle.DEFAULT_14,
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
          color: HexColor("#D0F1EB"),
        ),
        textStyle: AppStyle.DEFAULT_14.copyWith(fontWeight: FontWeight.w600),
        text: (AppLocalizations.of(Get.context!)?.continue_my ?? '')
            .toUpperCase(),
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
        errorText: state.email.invalid
            ? AppLocalizations.of(Get.context!)?.this_account_is_invalid
            : null,
        boxDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: HexColor("#838A91")),
        ),
        Fix: WidgetText(
            title: AppLocalizations.of(Get.context!)?.email,
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
        Fix: Text(AppLocalizations.of(Get.context!)?.user??'',
            style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      );
    });
  }
}
