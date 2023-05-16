import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/widgets/widget_button.dart';
import 'package:gen_crm/widgets/widget_input.dart';
import '../../../../src/src_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
      appBar: AppBar(
        backgroundColor: COLORS.PRIMARY_COLOR,
        title: Text(
          'Đổi mật khẩu',
          style: AppStyle.DEFAULT_18_BOLD,
        ),
        leading: _buildBack(),
        toolbarHeight: AppValue.heights * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: AppValue.heights - AppValue.heights * 0.1,
          padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
          color: Colors.white,
          child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
            listener: (context, state) {
              if (state.status.isSubmissionSuccess) {
                GetSnackBarUtils.removeSnackBar();
                ShowDialogCustom.showDialogBase(
                  onTap1: () => {AppNavigator.navigateLogin()},
                  title: MESSAGES.SUCCESS,
                  content: state.message,
                );
              }
              if (state.status.isSubmissionInProgress) {
                GetSnackBarUtils.createProgress();
              }
              if (state.status.isSubmissionFailure) {
                GetSnackBarUtils.removeSnackBar();
                ShowDialogCustom.showDialogBase(
                  title: MESSAGES.NOTIFICATION,
                  content: state.message,
                );
              }
            },
            child: Column(
              children: [
                AppValue.vSpaceTiny,
                _buildCurrentPass(bloc),
                AppValue.vSpaceMedium,
                _buildNewPass(bloc),
                AppValue.vSpaceMedium,
                _buildConfirmNewPass(bloc),
                Spacer(),
                BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                    builder: (context, state) {
                  return WidgetButton(
                    onTap: () {
                      state.status.isValidated
                          ? bloc.add(FormChangePasswordSubmitted())
                          : ShowDialogCustom.showDialogBase(
                                  title: MESSAGES.NOTIFICATION,
                                  content: 'Kiểm tra lại thông tin',
                               );
                    },
                    height: 45,
                    padding: EdgeInsets.all(0),
                    backgroundColor: COLORS.SECONDS_COLOR,
                    text: 'Hoàn thành',
                    textColor: COLORS.BLACK,
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBack() {
    return IconButton(
      onPressed: () {
        AppNavigator.navigateBack();
      },
      icon: Image.asset(
        ICONS.IC_BACK_PNG,
        height: 28,
        width: 28,
        color: COLORS.BLACK,
      ),
    );
  }

  _buildCurrentPass(ChangePasswordBloc bloc) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return GestureDetector(
        child: WidgetInput(
          colorFix: COLORS.WHITE,
          height: 55,
          obscureText: obscurePassword,
          focusNode: _passwordFocusNode,
          errorText: state.oldPassword.invalid ? MESSAGES.PASSWORD_ERROR : null,
          onChanged: (value) =>
              bloc.add(OldPasswordChanged(oldPassword: value)),
          endIcon: GestureDetector(
            onTap: () => setState(() => obscurePassword = !obscurePassword),
            child: SvgPicture.asset(
              obscurePassword ? ICONS.IC_HINT_PASS_SVG : ICONS.IC_HINT_SVG,
              color: COLORS.GREY,
              height: 25,
              width: 25,
            ),
          ),
          widthIcon: null,
          inputController: null,
          enabled: null,
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 1, color: COLORS.GREY.withOpacity(0.8))),
          inputType: TextInputType.text,
          hintStyle: AppStyle.DEFAULT_16.copyWith(color: Colors.grey),
          hint: 'Nhập mật khẩu hiện tại',
          Fix: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white),
                        left: BorderSide(color: Colors.white),
                        right: BorderSide(color: Colors.white),
                      ),
                    ),
                    height: 11),
                Text('Mật khẩu hiện tại', style: AppStyle.DEFAULT_16_BOLD),
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
          colorFix: COLORS.WHITE,
          height: 55,
          obscureText: obscureNewPassword,
          focusNode: _newPasswordFocusNode,
          errorText: state.newPassword.invalid ? MESSAGES.PASSWORD_ERROR : null,
          onChanged: (value) =>
              bloc.add(NewPasswordChanged(newPassword: value)),
          endIcon: GestureDetector(
            onTap: () =>
                setState(() => obscureNewPassword = !obscureNewPassword),
            child: SvgPicture.asset(
              obscureNewPassword ? ICONS.IC_HINT_PASS_SVG : ICONS.IC_HINT_SVG,
              color: COLORS.GREY,
              height: 25,
              width: 25,
            ),
          ),
          widthIcon: null,
          inputController: null,
          enabled: null,
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 1, color: COLORS.GREY.withOpacity(0.8))),
          inputType: TextInputType.text,
          hintStyle: AppStyle.DEFAULT_16.copyWith(color: Colors.grey),
          hint: 'Nhập mật khẩu mới',
          Fix: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white),
                        left: BorderSide(color: Colors.white),
                        right: BorderSide(color: Colors.white),
                      ),
                    ),
                    height: 11),
                Text('Mật khẩu mới', style: AppStyle.DEFAULT_16_BOLD),
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
          colorFix: COLORS.WHITE,
          height: 55,
          obscureText: obscureConfirmPassword,
          focusNode: _confirmPassFocusNode,
          errorText: state.repeatPassword.invalid
              ? MESSAGES.CONFIRM_PASSWORD_ERROR
              : null,
          onChanged: (value) {
            bloc.add(RepeatPasswordChanged(repeatPassword: value));
          },
          endIcon: GestureDetector(
            onTap: () => setState(
                () => obscureConfirmPassword = !obscureConfirmPassword),
            child: SvgPicture.asset(
              obscureConfirmPassword
                  ? ICONS.IC_HINT_PASS_SVG
                  : ICONS.IC_HINT_SVG,
              color: COLORS.GREY,
              height: 25,
              width: 25,
            ),
          ),
          widthIcon: null,
          inputController: null,
          enabled: null,
          boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 1, color: COLORS.GREY.withOpacity(0.8))),
          inputType: TextInputType.text,
          hintStyle: AppStyle.DEFAULT_16.copyWith(color: Colors.grey),
          hint: 'Nhập lại mật khẩu',
          Fix: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white),
                        left: BorderSide(color: Colors.white),
                        right: BorderSide(color: Colors.white),
                      ),
                    ),
                    height: 11),
                Text('Nhập lại mật khẩu', style: AppStyle.DEFAULT_16_BOLD),
              ],
            ),
          ),
        ),
      );
    });
  }
}
