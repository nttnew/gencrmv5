import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/src/src_index.dart';
import '../../l10n/key_text.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final UserRepository userRepository;

  ResetPasswordBloc({required UserRepository userRepository})
      : userRepository = userRepository,
        super(InitReset());

  @override
  void onTransition(
      Transition<ResetPasswordEvent, ResetPasswordState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent event) async* {
    if (event is FormResetPasswordSubmitted) {
      try {
        var response = await userRepository.resetPassword(
          username: event.username,
          newPass: event.newPass,
          email: event.email,
          timestamp: AppValue.DATE_TIME_FORMAT.format(DateTime.now()),
        );
        if (response.code == BASE_URL.SUCCESS_200) {
          yield ResetPassSuccess();
        } else
          yield ErrorReset(response.msg ?? '');
      } catch (e) {
        yield ErrorReset(
            getT(KeyT.an_error_occurred));
        throw e;
      }
    }
  }

  static ResetPasswordBloc of(BuildContext context) =>
      BlocProvider.of<ResetPasswordBloc>(context);
}
