import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/widgets/btn_thao_tac.dart';
import 'package:gen_crm/widgets/widget_input.dart';
import '../../../../l10n/key_text.dart';
import '../../../../src/src_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/appbar_base.dart';

class ChangePassWordPage extends StatefulWidget {
  const ChangePassWordPage({Key? key}) : super(key: key);

  @override
  State<ChangePassWordPage> createState() => _ChangePassWordPageState();
}

class _ChangePassWordPageState extends State<ChangePassWordPage> {
  bool obscurePassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  final _newPasswordFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPassFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPassFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<ChangePasswordBloc>().add(OldPasswordUnfocused());
      }
    });
    _newPasswordFocusNode.addListener(() {
      if (!_newPasswordFocusNode.hasFocus) {
        context.read<ChangePasswordBloc>().add(NewPasswordUnfocused());
      }
    });
    _confirmPassFocusNode.addListener(() {
      if (!_confirmPassFocusNode.hasFocus) {
        context.read<ChangePasswordBloc>().add(RepeatPasswordUnfocused());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ChangePasswordBloc.of(context);
    return Scaffold(
      appBar: AppbarBaseNormal(getT(KeyT.change_password)),
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
        color: COLORS.WHITE,
        child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              GetSnackBarUtils.removeSnackBar();
              ShowDialogCustom.showDialogBase(
                onTap1: () => {AppNavigator.navigateLogin()},
                title: getT(KeyT.success),
                content: state.message,
              );
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
          child: Column(
            children: [
              AppValue.vSpaceTiny,
              _buildCurrentPass(bloc),
              AppValue.vSpaceSmall,
              _buildNewPass(bloc),
              AppValue.vSpaceSmall,
              _buildConfirmNewPass(bloc),
              Spacer(),
              BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                  builder: (context, state) {
                return ButtonCustom(
                  marginHorizontal: 0,
                  marginVertical: 0,
                  onTap: () {
                    state.status.isValidated
                        ? bloc.add(FormChangePasswordSubmitted())
                        : ShowDialogCustom.showDialogBase(
                            title: getT(KeyT.notification),
                            content: getT(KeyT.check_the_information),
                          );
                  },
                  title: getT(KeyT.completed),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  _buildCurrentPass(ChangePasswordBloc bloc) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return GestureDetector(
        child: WidgetInput(
          colorTxtLabel: COLORS.WHITE,
          height: 55,
          obscureText: obscurePassword,
          focusNode: _passwordFocusNode,
          errorText: state.oldPassword.invalid
              ? getT(KeyT.password_must_be_at_least_6_characters)
              : null,
          onChanged: (value) =>
              bloc.add(OldPasswordChanged(oldPassword: value)),
          widthIcon: null,
          inputController: null,
          enabled: null,
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 1, color: COLORS.GREY.withOpacity(0.8))),
          inputType: TextInputType.text,
          hintStyle: AppStyle.DEFAULT_16.copyWith(color: Colors.grey),
          hint: getT(KeyT.enter_current_password),
          textLabel: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: COLORS.WHITE,
            ),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: COLORS.WHITE),
                        left: BorderSide(color: COLORS.WHITE),
                        right: BorderSide(color: COLORS.WHITE),
                      ),
                    ),
                    height: 11),
                Text(getT(KeyT.current_password),
                    style: AppStyle.DEFAULT_16_BOLD),
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildNewPass(ChangePasswordBloc bloc) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return GestureDetector(
        child: WidgetInput(
          colorTxtLabel: COLORS.WHITE,
          height: 55,
          obscureText: obscureNewPassword,
          focusNode: _newPasswordFocusNode,
          errorText: state.newPassword.invalid
              ? getT(KeyT.password_must_be_at_least_6_characters)
              : null,
          onChanged: (value) =>
              bloc.add(NewPasswordChanged(newPassword: value)),
          widthIcon: null,
          inputController: null,
          enabled: null,
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 1, color: COLORS.GREY.withOpacity(0.8))),
          inputType: TextInputType.text,
          hintStyle: AppStyle.DEFAULT_16.copyWith(color: Colors.grey),
          hint: getT(KeyT.enter_your_new_password),
          textLabel: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: COLORS.WHITE,
            ),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: COLORS.WHITE),
                        left: BorderSide(color: COLORS.WHITE),
                        right: BorderSide(color: COLORS.WHITE),
                      ),
                    ),
                    height: 11),
                Text(getT(KeyT.new_password), style: AppStyle.DEFAULT_16_BOLD),
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildConfirmNewPass(ChangePasswordBloc bloc) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return GestureDetector(
        child: WidgetInput(
          colorTxtLabel: COLORS.WHITE,
          height: 55,
          obscureText: obscureConfirmPassword,
          focusNode: _confirmPassFocusNode,
          errorText: state.repeatPassword.invalid
              ? getT(KeyT.password_not_match)
              : null,
          onChanged: (value) {
            bloc.add(RepeatPasswordChanged(repeatPassword: value));
          },
          widthIcon: null,
          inputController: null,
          enabled: null,
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 1, color: COLORS.GREY.withOpacity(0.8))),
          inputType: TextInputType.text,
          hintStyle: AppStyle.DEFAULT_16.copyWith(color: Colors.grey),
          hint: getT(KeyT.enter_password_again),
          textLabel: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: COLORS.WHITE,
            ),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: COLORS.WHITE),
                        left: BorderSide(color: COLORS.WHITE),
                        right: BorderSide(color: COLORS.WHITE),
                      ),
                    ),
                    height: 11),
                Text(getT(KeyT.enter_password_again),
                    style: AppStyle.DEFAULT_16_BOLD),
              ],
            ),
          ),
        ),
      );
    });
  }
}
