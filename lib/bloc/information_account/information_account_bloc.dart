import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../api_resfull/user_repository.dart';
import '../../l10n/key_text.dart';
import '../../src/base.dart';
import '../../src/models/index.dart';
import '../../src/models/validate_form/email.dart';
part 'information_account_event.dart';
part 'information_account_state.dart';

class InforAccBloc extends Bloc<InforAccEvent, InforAccState> {
  final UserRepository userRepository;

  InforAccBloc({required this.userRepository}) : super(const InforAccState());

  @override
  void onTransition(Transition<InforAccEvent, InforAccState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<InforAccState> mapEventToState(InforAccEvent event) async* {
    if (event is EmailChanged) {
      final email = Email.dirty(event.email);
      yield state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([
          state.phone,
          email,
        ]),
      );
    } else if (event is EmailUnfocused) {
      final email = Email.dirty(state.email.value);
      yield state.copyWith(
        email: email,
        status: Formz.validate([
          state.phone,
          email,
        ]),
      );
    } else if (event is PhoneChanged) {
      final phone = Phone.dirty(event.phone);
      yield state.copyWith(
        phone: phone.valid ? phone : Phone.pure(event.phone),
        status: Formz.validate([
          phone,
          state.email,
        ]),
      );
    } else if (event is PhoneUnfocused) {
      final phone = Phone.dirty(state.phone.value);
      yield state.copyWith(
        phone: phone,
        status: Formz.validate([
          phone,
          state.email,
        ]),
      );
    } else if (event is FormInforAccSubmitted) {
      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);
        try {
          var response = await userRepository.changeInforAcc(
              fullName: event.fullName,
              phone: state.phone.value,
              email: state.email.value,
              address: event.address,
              avatar: event.avatar);
          if (response.code == BASE_URL.SUCCESS_200 ||
              response.code == BASE_URL.SUCCESS) {
            yield state.copyWith(
                status: FormzStatus.submissionSuccess, message: response.msg);
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure, message: response.msg);
          }
        } catch (e) {
          yield state.copyWith(
              status: FormzStatus.submissionFailure,
              message:
                  getT(KeyT.an_error_occurred));
          throw e;
        }
      }
    } else if (event is FormInforAccNoAvatarSubmitted) {
      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);

        try {
          var response = await userRepository.changeInforAccNoAvatar(
              fullName: event.fullName,
              phone: state.phone.value,
              email: state.email.value,
              address: event.address);
          if (response.code == BASE_URL.SUCCESS_200 ||
              response.code == BASE_URL.SUCCESS) {
            yield state.copyWith(
                status: FormzStatus.submissionSuccess, message: response.msg);
          } else {
            yield state.copyWith(
                status: FormzStatus.submissionFailure, message: response.msg);
          }
        } catch (e) {
          yield state.copyWith(
              status: FormzStatus.submissionFailure,
              message:
                  getT(KeyT.an_error_occurred));
          throw e;
        }
      }
    }
  }

  static InforAccBloc of(BuildContext context) =>
      BlocProvider.of<InforAccBloc>(context);
}
