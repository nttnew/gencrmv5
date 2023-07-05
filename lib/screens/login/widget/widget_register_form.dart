import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class WidgetRegisterForm extends StatefulWidget {
  @override
  _WidgetRegisterFormState createState() => _WidgetRegisterFormState();
}

class _WidgetRegisterFormState extends State<WidgetRegisterForm> {
  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _fullNameFocusNode.addListener(() {
      if (!_fullNameFocusNode.hasFocus) {
        context.read<RegisterBloc>().add(FullNameRegisterUnfocused());
      }
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<RegisterBloc>().add(EmailRegisterUnfocused());
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<RegisterBloc>().add(PasswordRegisterUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = RegisterBloc.of(context);
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          GetSnackBarUtils.removeSnackBar();
          ShowDialogCustom.showDialogBase(
            title: AppLocalizations.of(Get.context!)?.notification,
            content: AppLocalizations.of(Get.context!)?.success,
            onTap1: () => AppNavigator.navigateLogout(),
          );
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
      child: Container(
        decoration: BoxDecoration(
            color: COLORS.BACKGROUND, borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(Get.context!)?.full_name ?? '',
                style: AppStyle.DEFAULT_16_BOLD,
              ),
              AppValue.vSpaceSmall,
              _buildTextFieldFullName(bloc),
              AppValue.vSpaceSmall,
              Text(
                AppLocalizations.of(Get.context!)?.email ?? '',
                style: AppStyle.DEFAULT_16_BOLD,
              ),
              AppValue.vSpaceSmall,
              _buildTextFieldEmail(bloc),
              AppValue.vSpaceSmall,
              Text(
                AppLocalizations.of(Get.context!)?.password ?? '',
                style: AppStyle.DEFAULT_16_BOLD,
              ),
              AppValue.vSpaceSmall,
              _buildTextFieldPassword(bloc),
              AppValue.vSpaceLarge,
              _buildButtonRegister(bloc),
            ],
          ),
        ),
      ),
    );
  }

  _buildButtonRegister(RegisterBloc bloc) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return WidgetButton(
            onTap: () => state.status.isValidated
                ? bloc.add(RegisterFormSubmitted())
                : null,
            enable: state.status.isValidated,
            backgroundColor: COLORS.PRIMARY_COLOR,
            text: AppLocalizations.of(Get.context!)?.register,
          );
        });
  }

  _buildTextFieldPassword(RegisterBloc bloc) {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return WidgetInput(
        onChanged: (value) =>
            bloc.add(PasswordRegisterChanged(password: value)),
        errorText: state.password.invalid
            ? AppLocalizations.of(Get.context!)
                ?.password_must_be_at_least_6_characters
            : null,
        obscureText: obscurePassword,
        focusNode: _passwordFocusNode,
        boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: COLORS.WHITE),
        hint: AppLocalizations.of(Get.context!)?.enter_your_password,
        endIcon: GestureDetector(
          onTap: () => setState(() => obscurePassword = !obscurePassword),
          child: Icon(
            obscurePassword
                ? CommunityMaterialIcons.eye_outline
                : CommunityMaterialIcons.eye_off_outline,
            color: COLORS.GREY,
            size: 25,
          ),
        ),
      );
    });
  }

  _buildTextFieldEmail(RegisterBloc bloc) {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return WidgetInput(
        onChanged: (value) => bloc.add(EmailRegisterChanged(email: value)),
        inputType: TextInputType.emailAddress,
        focusNode: _emailFocusNode,
        boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: COLORS.WHITE),
        hint: AppLocalizations.of(Get.context!)?.enter_your_email,
        errorText: state.email.invalid
            ? AppLocalizations.of(Get.context!)?.this_account_is_invalid
            : null,
      );
    });
  }

  _buildTextFieldFullName(RegisterBloc bloc) {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return WidgetInput(
        onChanged: (value) =>
            bloc.add(FullNameRegisterChanged(fullName: value)),
        inputType: TextInputType.text,
        focusNode: _fullNameFocusNode,
        boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: COLORS.WHITE),
        hint: AppLocalizations.of(Get.context!)?.enter_full_name,
        errorText: state.fullName.invalid
            ? AppLocalizations.of(Get.context!)?.name_cannot_be_left_blank
            : null,
      );
    });
  }
}
