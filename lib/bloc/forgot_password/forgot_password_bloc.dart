import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/src/src_index.dart';

import '../../widgets/loading_api.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final UserRepository userRepository;

  ForgotPasswordBloc({required UserRepository userRepository}) : userRepository = userRepository,
        super(ForgotPasswordState(
          email: UserName.pure(),username: NotNull.pure(),
          message: '',status:FormzStatus.invalid,
          timestamp:AppValue.DATE_TIME_FORMAT.format(DateTime.now()) )
      );

  @override
  void onTransition(Transition<ForgotPasswordEvent, ForgotPasswordState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    if (event is EmailForgotPasswordChanged) {
        final email = UserName.dirty(event.email);
        yield state.copyWith(
          email: email.valid ? email : UserName.pure(event.email),
          status: Formz.validate([email,state.username]),
        );
      } else if (event is EmailForgotPasswordUnfocused) {
        final email = UserName.dirty(state.email.value);
        yield state.copyWith(
          email: email,
          status: Formz.validate([email,state.username]),
        );
      } else if (event is UserForgotPasswordChanged) {
      final username = NotNull.dirty(event.username);
      yield state.copyWith(
        username: username.valid ? username : NotNull.pure(event.username),
        status: Formz.validate([username, state.email,]),
      );

    } else if (event is UserForgotPasswordUnfocused) {
      final username = NotNull.dirty(state.username.value);
      yield state.copyWith(
        username: username,
        status: Formz.validate([username, state.email]),
      );
    } else if (event is FormForgotPasswordSubmitted) {
        try {
          if (state.status.isValidated) {
            print("Time ${AppValue.DATE_TIME_FORMAT.format(DateTime.now())}");
          yield state.copyWith(status: FormzStatus.submissionInProgress);
          var response = await userRepository.forgotPassword(
              email: state.email.value, username: state.username.value,
              timestamp: AppValue.DATE_TIME_FORMAT.format(DateTime.now()));
          if ((response.code == BASE_URL.SUCCESS)||(response.code == BASE_URL.SUCCESS_200)) {
            yield state.copyWith(status: FormzStatus.submissionSuccess, message: response.msg??'');
          } else{
            yield state.copyWith(status: FormzStatus.submissionFailure, message: response.msg??'');
          }
          }
        } catch (e) {
          yield state.copyWith(status: FormzStatus.submissionFailure, message: MESSAGES.CONNECT_ERROR);
          print('loiiiii $e');
          throw e;
        }
      }
    }
  // final response = await userRepository.forgotPassword({
  //   // "email": "dai.nguyen@gen.vn",
  //   // "timestamp": AppValue.DATE_TIME_FORMAT.format(DateTime.now()),
  //   // "username": "admin"
  // });
  static ForgotPasswordBloc of(BuildContext context) => BlocProvider.of<ForgotPasswordBloc>(context);
}
