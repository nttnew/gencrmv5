import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:gen_crm/api_resfull/user_repository.dart';
import 'package:gen_crm/src/src_index.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;

  RegisterBloc({required this.userRepository})
      : super(const RegisterState());

  @override
  void onTransition(Transition<RegisterEvent, RegisterState> transition) {
    super.onTransition(transition);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is EmailRegisterChanged) {
      final email = UserName.dirty(event.email);
      yield state.copyWith(
        email: email.valid ? email : UserName.pure(event.email),
        status: Formz.validate([state.fullName, email, state.password]),
      );
    } else if (event is PasswordRegisterChanged) {
      final password = Password.dirty(event.password);
      yield state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([state.fullName, state.email, password]),
      );
    } else if (event is FullNameRegisterChanged) {
      final fullName = NotNull.dirty(event.fullName);
      yield state.copyWith(
        fullName: fullName.valid ? fullName : NotNull.pure(event.fullName),
        status: Formz.validate([fullName, state.email, state.password]),
      );

    } else if (event is FullNameRegisterUnfocused) {
      final fullName = NotNull.dirty(state.fullName.value);
      yield state.copyWith(
        fullName: fullName,
        status: Formz.validate([fullName, state.email, state.password]),
      );
    } else if (event is EmailRegisterUnfocused) {
      final email = UserName.dirty(state.email.value);
      yield state.copyWith(
        email: email,
        status: Formz.validate([state.fullName, email, state.password]),
      );
    } else if (event is PasswordRegisterUnfocused) {
      final password = Password.dirty(state.password.value);
      yield state.copyWith(
        password: password,
        status: Formz.validate([state.fullName, state.email, password]),
      );
    }
    else if (event is RegisterFormSubmitted) {
      try{

        if (state.status.isValidated) {
          yield state.copyWith(status: FormzStatus.submissionInProgress);
          var response = await userRepository.registerApp(fullName: state.fullName.value, email: state.email.value, password: state.password.value);
          if (response.code == BASE_URL.SUCCESS) {
            AppNavigator.navigateBack();
            yield state.copyWith(status: FormzStatus.submissionSuccess, message: response.message);
          } else {
            print('lỗi: ${response.message}');
            yield state.copyWith(status: FormzStatus.submissionFailure, message: response.message);
          }
        }
      }catch(e){
        yield state.copyWith(status: FormzStatus.submissionFailure, message: MESSAGES.CONNECT_ERROR);
        throw e;
      }
    }
  }
  static RegisterBloc of(BuildContext context) => BlocProvider.of<RegisterBloc>(context);
}