// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/widgets/widgets.dart';

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
                title: MESSAGES.NOTIFICATION,
                content: MESSAGES.SUCCESS,
                onTap1: () => AppNavigator.navigateLogout(),

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

          //GetSnackBarUtils.createFailure(message: state.message);
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
                MESSAGES.FULL_NAME,
                style: AppStyle.DEFAULT_16_BOLD,
              ),
              AppValue.vSpaceSmall,
              _buildTextFieldFullName(bloc),
              AppValue.vSpaceMedium,
              Text(
                MESSAGES.EMAIL,
                style: AppStyle.DEFAULT_16_BOLD,
              ),
              AppValue.vSpaceSmall,
              _buildTextFieldEmail(bloc),
              AppValue.vSpaceMedium,
              Text(
                MESSAGES.PASSWORD,
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
            // onTap: () {
            //   ShowDialogCustom.showLoading();
            // },
            enable: state.status.isValidated,
            backgroundColor: COLORS.PRIMARY_COLOR,
            text: MESSAGES.REGISTER,
          );
        });
  }

  _buildTextFieldPassword(RegisterBloc bloc) {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return WidgetInput(
        onChanged: (value) =>
            bloc.add(PasswordRegisterChanged(password: value)),
        errorText: state.password.invalid ? MESSAGES.PASSWORD_ERROR : null,
        obscureText: obscurePassword,
        focusNode: _passwordFocusNode,
        boxDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: COLORS.WHITE),
        hint: MESSAGES.PASSWORD_HINT,
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
        hint: MESSAGES.EMAIL_HINT,
        errorText: state.email.invalid ? MESSAGES.EMAIL_ERROR : null,
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
        hint: MESSAGES.FULL_NAME_HINT,
        errorText: state.fullName.invalid ? MESSAGES.WARNING_FULL_NAME : null,
      );
    });
  }
}
