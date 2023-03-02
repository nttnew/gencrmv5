import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/bloc/blocs.dart';
import 'package:gen_crm/src/src_index.dart';

part 'forgot_password_otp_event.dart';
part 'forgot_password_otp_state.dart';

class ForgotPasswordOTPBloc extends Bloc<ForgotPasswordOTPEvent, ForgotPasswordOtpState> {
  final UserRepository userRepository;

  ForgotPasswordOTPBloc({required UserRepository userRepository}) : userRepository = userRepository, super(InitForgotOtp());

  @override
  void onTransition(Transition<ForgotPasswordOTPEvent, ForgotPasswordOtpState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<ForgotPasswordOtpState> mapEventToState(ForgotPasswordOTPEvent event) async* {
    if (event is FormForgotPasswordOTPSubmitted) {
      try{
          var response = await userRepository.forgotPasswordOtp(
              email: event.email,
            code: event.code,
            username: event.username,
              timestamp: AppValue.DATE_TIME_FORMAT.format(DateTime.now()),
          );
          if (response.code == BASE_URL.SUCCESS_200) {
            yield ForgotPassOtpSuccess();
            // GetSnackBarUtils.removeSnackBar();
            // AppNavigator.navigateForgotPasswordReset([state.email.value, response.payload]);
          }   else
            yield ErrorForgotOtp(response.msg ?? '');
      } catch (e) {
        yield ErrorForgotOtp(MESSAGES.CONNECT_ERROR);
        throw e;
      }
      }
  }
  static ForgotPasswordOTPBloc of(BuildContext context) => BlocProvider.of<ForgotPasswordOTPBloc>(context);
}
