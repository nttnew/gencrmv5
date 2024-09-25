import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/validate_form/email.dart';
part 'information_account_event.dart';
part 'information_account_state.dart';

class InfoAccBloc extends Bloc<InfoAccEvent, InfoAccState> {
  final UserRepository userRepository;

  InfoAccBloc({required this.userRepository}) : super(const InfoAccState());

  @override
  void onTransition(Transition<InfoAccEvent, InfoAccState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<InfoAccState> mapEventToState(InfoAccEvent event) async* {
    if (event is EmailChanged) {
      final email = Email.dirty(event.email);
      yield state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([
          email,
        ]),
      );
    } else if (event is EmailUnfocused) {
      final email = Email.dirty(state.email.value);
      yield state.copyWith(
        email: email,
        status: Formz.validate([
          email,
        ]),
      );
    } else if (event is FormInfoAccSubmitted) {
      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);
        try {
          var response = await userRepository.changeInforAcc(
              fullName: event.fullName,
              phone: event.phone,
              email: state.email.value,
              address: event.address,
              avatar: event.avatar);
          if (isSuccess(response.code)) {
            yield state.copyWith(
                status: FormzStatus.submissionSuccess, message: response.msg);
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure, message: response.msg);
          }
        } catch (e) {
          yield state.copyWith(
              status: FormzStatus.submissionFailure,
              message: getT(KeyT.an_error_occurred));
          throw e;
        }
      }
    } else if (event is FormInfoAccNoAvatarSubmitted) {
      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);

        try {
          var response = await userRepository.changeInforAccNoAvatar(
              fullName: event.fullName,
              phone: event.phone,
              email: state.email.value,
              address: event.address);
          if (isSuccess(response.code)) {
            yield state.copyWith(
                status: FormzStatus.submissionSuccess, message: response.msg);
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure, message: response.msg);
          }
        } catch (e) {
          yield state.copyWith(
              status: FormzStatus.submissionFailure,
              message: getT(KeyT.an_error_occurred));
          throw e;
        }
      }
    }
  }

  static InfoAccBloc of(BuildContext context) =>
      BlocProvider.of<InfoAccBloc>(context);
}
