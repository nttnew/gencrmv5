import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gen_crm/api_resfull/api.dart';
import 'package:gen_crm/src/models/validate_form/confirm_password.dart';
import 'package:gen_crm/src/models/validate_form/new_password.dart';
import 'package:gen_crm/src/src_index.dart';
import 'package:gen_crm/storages/share_local.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository userRepository;

  ChangePasswordBloc({required this.userRepository})
      : super(const ChangePasswordState());

  @override
  void onTransition(
      Transition<ChangePasswordEvent, ChangePasswordState> transition) {
    super.onTransition(transition);
  }

  String repeatPass = "";
  String oldPass = "";
  @override
  Stream<ChangePasswordState> mapEventToState(
      ChangePasswordEvent event) async* {
    if (event is OldPasswordChanged) {
      oldPass = event.oldPassword;
      final oldPassword = Password.dirty(event.oldPassword);
      yield state.copyWith(
        oldPassword:
            oldPassword.valid ? oldPassword : Password.pure(event.oldPassword),
        status: Formz.validate(
            [oldPassword, state.newPassword, state.repeatPassword]),
      );
    } else if (event is NewPasswordChanged) {
      final newPassword = NewPassword.dirty(
          password: state.oldPassword.value, value: event.newPassword);
      yield state.copyWith(
        newPassword: newPassword.valid
            ? newPassword
            : NewPassword.pure(password: state.oldPassword.value),
        status: Formz.validate(
            [state.oldPassword, newPassword, state.repeatPassword]),
      );
    } else if (event is RepeatPasswordChanged) {
      repeatPass = event.repeatPassword;
      final repeatPassword = ConfirmedPassword.dirty(
        password: state.newPassword.value,
        value: event.repeatPassword,
      );

      yield state.copyWith(
        repeatPassword: repeatPassword,
        status: Formz.validate(
            [state.oldPassword, state.newPassword, repeatPassword]),
      );
    } else if (event is OldPasswordUnfocused) {
      final oldPassword = Password.dirty(state.oldPassword.value);
      yield state.copyWith(
        oldPassword: oldPassword,
        status: Formz.validate(
            [oldPassword, state.newPassword, state.repeatPassword]),
      );
    } else if (event is NewPasswordUnfocused) {
      final newPassword =
          NewPassword.dirty(password: oldPass, value: state.newPassword.value);
      yield state.copyWith(
        newPassword: newPassword,
        status: Formz.validate(
            [state.oldPassword, newPassword, state.repeatPassword]),
      );
    } else if (event is RepeatPasswordUnfocused) {
      final repeatPassword = ConfirmedPassword.dirty(
          password: state.newPassword.value, value: repeatPass);
      yield state.copyWith(
        repeatPassword: repeatPassword,
        status: Formz.validate(
            [state.oldPassword, state.newPassword, repeatPassword]),
      );
    } else if (event is FormChangePasswordSubmitted) {
      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);

        try {
          var response = await userRepository.updatePass(
              username: shareLocal.getString(PreferencesKey.USER_NAME),
              oldpass: state.oldPassword.value,
              newpass: state.newPassword.value);
          if (response.code == BASE_URL.SUCCESS_200) {
            yield state.copyWith(
                status: FormzStatus.submissionSuccess, message: response.msg);
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure, message: response.msg);
          }
        } catch (e) {
          yield state.copyWith(
              status: FormzStatus.submissionFailure,
              message: MESSAGES.CONNECT_ERROR);
          throw e;
        }
      }
    }
  }

  static ChangePasswordBloc of(BuildContext context) =>
      BlocProvider.of<ChangePasswordBloc>(context);
}
