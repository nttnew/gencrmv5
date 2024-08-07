import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/app_const.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/form_input/form_input.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../l10n/key_text.dart';
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
              title: getT(KeyT.notification),
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
                        AppValue.vSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                WidgetText(
                                    title: getT(KeyT.forgot_password),
                                    style: AppStyle.DEFAULT_20_BOLD),
                                SizedBox(
                                  height: 5,
                                ),
                                WidgetText(
                                  title: getT(
                                      KeyT.please_enter_email_register_account),
                                  style: AppStyle.DEFAULT_14,
                                ),
                                AppValue.vSpaceMedium,
                              ],
                            ),
                          ],
                        ),
                        AppValue.vSpaceSmall,
                        _buildTextFieldEmail(context, bloc),
                        AppValue.vSpaceSmall,
                        _buildTextFieldUsername(context, bloc),
                        AppValue.vSpaceMedium,
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
      return ButtonCustom(
        marginHorizontal: 0,
        backgroundColor: getBackgroundWithIsCar(),
        onTap: () => bloc.add(FormForgotPasswordSubmitted()),
        title: (getT(KeyT.continue_my)).toUpperCase(),
      );
    });
  }

  _buildTextFieldEmail(BuildContext context, ForgotPasswordBloc bloc) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
      return FormInputBase(
        onChange: (value) => bloc.add(EmailForgotPasswordChanged(email: value)),
        focusNode: _EmailFocusNode,
        textInputType: TextInputType.emailAddress,
        errorText:
            state.email.invalid ? getT(KeyT.this_email_is_invalid) : null,
        label: getT(KeyT.email),
      );
    });
  }

  _buildTextFieldUsername(BuildContext context, ForgotPasswordBloc bloc) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
      return FormInputBase(
        onChange: (value) =>
            bloc.add(UserForgotPasswordChanged(username: value)),
        focusNode: _UserFocusNode,
        textInputType: TextInputType.text,
        errorText:
            state.username.invalid ? getT(KeyT.this_account_is_invalid) : null,
        label: getT(KeyT.user),
      );
    });
  }
}
